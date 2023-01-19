prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- Oracle APEX export file
--
-- You should run the script connected to SQL*Plus as the owner (parsing schema)
-- of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_imp.import_begin (
 p_version_yyyy_mm_dd=>'2022.10.07'
,p_release=>'22.2.1'
,p_default_workspace_id=>8001034675357261
,p_default_application_id=>1001
,p_default_id_offset=>33107508441090072
,p_default_owner=>'TENFTIP'
);
end;
/
prompt --application/shared_components/plugins/item_type/fcs_text_field
begin
wwv_flow_imp_shared.create_plugin(
 p_id=>wwv_flow_imp.id(1459656641314523373)
,p_plugin_type=>'ITEM TYPE'
,p_name=>'FCS.TEXT_FIELD'
,p_display_name=>'FCS Text Field'
,p_supported_component_types=>'APEX_APPLICATION_PAGE_ITEMS:APEX_APPL_PAGE_IG_COLUMNS'
,p_javascript_file_urls=>'#PLUGIN_FILES#fcs-text-field#MIN#.js'
,p_css_file_urls=>'#PLUGIN_FILES#fcs-text-field#MIN#.css'
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'procedure render ',
'  ( p_item   in            apex_plugin.t_item',
'  , p_plugin in            apex_plugin.t_plugin',
'  , p_param  in            apex_plugin.t_item_render_param',
'  , p_result in out nocopy apex_plugin.t_item_render_result ',
'  ) ',
'as',
'    --',
'    l_result        apex_plugin.t_page_item_render_result; ',
'    l_escaped_value varchar2(32767)           := apex_escape.html(p_param.value);',
'    l_name          apex_plugin.t_input_name;',
'    l_display_value varchar2(32767);',
'    --',
'    l_enter_submit  boolean                   := (coalesce(p_item.attribute_01, ''N'') = ''Y'');',
'    l_is_disabled   boolean                   := (coalesce(p_item.attribute_02, ''N'') = ''Y'');',
'    l_save_state    boolean                   := (coalesce(p_item.attribute_03, ''N'') = ''Y''); -- Send On Page Submit',
'    l_text_case     p_item.attribute_06%type  := p_item.attribute_06;',
'    l_subtype       p_item.attribute_07%type  := p_item.attribute_07;',
'    --',
'begin',
'  --',
'  if p_param.value_set_by_controller and',
'     p_param.is_readonly',
'  then',
'    return;',
'  end if;',
'  --',
'  if p_param.is_printer_friendly',
'  then',
'    --',
'    if not (l_is_disabled and not l_save_state)',
'    then',
'      apex_plugin_util.print_hidden_if_readonly (p_item  => p_item,',
'                                                 p_param => p_param);',
'    end if;',
'    --',
'    l_display_value := l_escaped_value;',
'    --',
'    apex_plugin_util.print_display_only (p_item_name        => p_item.name,',
'                                         p_display_value    => l_display_value,',
'                                         p_show_line_breaks => false,',
'                                         p_escape           => false,',
'                                         p_attributes       => p_item.element_attributes);',
'    --',
'  else',
'    --',
'    if (   not l_is_disabled',
'        or not p_param.is_readonly',
'        or (    l_is_disabled',
'            and l_save_state))',
'    then',
'      l_name := apex_plugin.get_input_name_for_item;',
'    end if;',
'    --',
'    sys.htp.prn(''<input type="''||l_subtype||''" '' ||',
'                apex_plugin_util.get_element_attributes (p_item,',
'                                                         l_name,',
'                                                         ''text_field apex-item-text'' ||',
'                                                           case when l_is_disabled       then '' apex_disabled fcs-disabled-item u-color-14-bg'' end ||',
'                                                           case when p_param.is_readonly then '' fcs-readonly-item'' end',
'                                                        ) ||',
'                ''value="''||l_escaped_value||''" ''||',
'                ''size="''||p_item.element_width||''" ''||',
'                ''maxlength="''||p_item.element_max_length||''" ''||',
'                case when l_text_case = ''U''',
'                then ''data-text-case="UPPER" ''',
'                -- then ''onkeyup="this.value = this.value.toUpperCase();" ''',
'                when l_text_case = ''L''',
'                then ''data-text-case="LOWER" ''',
'                -- then ''onkeyup="this.value = this.value.toLowerCase();" ''',
'                else '''' end ||',
'                --',
'                case when l_enter_submit and not l_is_disabled',
'                then',
'                  ''onkeypress="return apex.submit({request:'''''' || p_item.name || '''''',submitIfEnter:event})" ''',
'                end ||',
'                --',
'                case',
'                  when l_is_disabled',
'                  then',
'                    case when l_save_state',
'                    then',
'                        ''readonly="readonly" ''',
'                    else',
'                        ''disabled="disabled" ''',
'                    end',
'                  when p_param.is_readonly',
'                  then',
'                    ''readonly="readonly" tabindex="-1" ''',
'                end ||',
'                '' />'');',
'    ',
'    --',
'    apex_javascript.add_onload_code(p_code => ''fcsTextField(apex.item('' ||p_item.name || ''))'');',
'    -- l_result.javascript_function := ''fcsTextField(this);'';',
'    -- l_result.javascript_function := ''function() { return fcsTextField(this); }'';',
'    --',
'    if p_item.icon_css_classes is not null',
'    then',
'      sys.htp.prn(''<span class="apex-item-icon fa ''|| apex_escape.html_attribute(p_item.icon_css_classes) ||''" aria-hidden="true"></span>'');',
'    end if;',
'    --',
'    if l_is_disabled and l_save_state and not p_param.value_set_by_controller',
'    then',
'      wwv_flow_plugin_util.print_protected (p_item_name => p_item.name,',
'                                            p_value     => p_param.value);',
'    end if;',
'    --',
'    p_result.is_navigable := not l_is_disabled or not p_param.is_readonly;',
'    --',
'  end if;',
'  --',
'end render;',
'--',
'----------------------------------------------------------------------------------------------------------------------------------',
'--',
'procedure validate',
'  ( p_item     in apex_plugin.t_item',
'  , p_plugin   in apex_plugin.t_plugin',
'  , p_param    in apex_plugin.t_item_validation_param',
'  , p_result   in out nocopy apex_plugin.t_item_validation_result',
'  )',
'is',
'    --',
'    c_trim_spaces      constant varchar2(100) := nvl(p_item.attribute_05, ''BOTH'');',
'    c_restricted_chars constant varchar2(4)   := chr(32) || chr(10) || chr(13) || chr(9);',
'    --',
'    l_value varchar2( 32767 );',
'    --',
'begin',
'  --',
'  if c_trim_spaces != ''NONE''',
'  then',
'    --',
'    l_value := case c_trim_spaces',
'                 when ''LEADING''  then ltrim(p_param.value, c_restricted_chars)',
'                 when ''TRAILING'' then rtrim(p_param.value, c_restricted_chars)',
'                 when ''BOTH''     then ltrim(rtrim(p_param.value, c_restricted_chars), c_restricted_chars)',
'               end;',
'    --',
'    if (   l_value != p_param.value',
'        or (    l_value       is     null',
'            and p_param.value is not null))',
'    then',
'      apex_util.set_session_state (p_name  => p_item.session_state_name,',
'                                   p_value => l_value);',
'    end if;',
'    --',
'  end if;',
'  --',
'end validate;',
'--',
'-------------------------------------------------------------------------------------------------------------------------------',
'--',
''))
,p_api_version=>2
,p_render_function=>'render'
,p_validation_function=>'validate'
,p_standard_attributes=>'VISIBLE:FORM_ELEMENT:SESSION_STATE:READONLY:QUICKPICK:SOURCE:ELEMENT:WIDTH:PLACEHOLDER:ICON:ENCRYPT:FILTER:LINK'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_is_quick_pick=>true
,p_help_text=>'Displays a text field.'
,p_version_identifier=>'1.0'
,p_about_url=>'www.freshcomputers.com.au'
,p_plugin_comment=>'https://github.com/stefandobre/Template-Plugin-Text-Field'
,p_files_version=>165
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(1459656831402530024)
,p_plugin_id=>wwv_flow_imp.id(1459656641314523373)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>40
,p_prompt=>'Submit when Enter pressed'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_is_common=>false
,p_default_value=>'N'
,p_supported_component_types=>'APEX_APPLICATION_PAGE_ITEMS'
,p_is_translatable=>false
,p_help_text=>'Specify whether pressing the <em>Enter</em> key while in this field automatically submits the page.'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(1459657323568537213)
,p_plugin_id=>wwv_flow_imp.id(1459656641314523373)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>50
,p_prompt=>'Disabled'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_is_common=>false
,p_default_value=>'N'
,p_supported_component_types=>'APEX_APPLICATION_PAGE_ITEMS'
,p_is_translatable=>false
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Specify whether this item is disabled, which prevents end users from changing the value.</p>',
'<p>A disabled text item still displays with the same HTML formatting, unlike an item type of <em>Display Only</em>, which removes the HTML formatting. Disabled text items are part of page source, which enables their session state to be evaluated. Con'
||'versely, display only items are not stored in session state.</p>'))
,p_attribute_comment=>wwv_flow_string.join(wwv_flow_t_varchar2(
'$$ DJP  - Is this equivalent to specifying Read Only = Always?',
'If so do we need this attribute?'))
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(1459657820582545787)
,p_plugin_id=>wwv_flow_imp.id(1459656641314523373)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>60
,p_prompt=>'Send On Page Submit'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_is_common=>false
,p_default_value=>'N'
,p_supported_component_types=>'APEX_APPLICATION_PAGE_ITEMS'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_imp.id(1459657323568537213)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'Y'
,p_help_text=>'Specify whether the current item value is stored in session state when the page is submitted.'
,p_attribute_comment=>'$$$ DJP - Why can this only be set when Disabled = Y?'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(590940713627121974)
,p_plugin_id=>wwv_flow_imp.id(1459656641314523373)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>5
,p_display_sequence=>20
,p_prompt=>'Trim Spaces'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_is_common=>false
,p_default_value=>'BOTH'
,p_supported_component_types=>'APEX_APPLICATION_PAGE_ITEMS'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'Select how the item value is trimmed after submitting the page. This setting trims spaces, tabs, and new lines from the text entered.'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(590941009529123873)
,p_plugin_attribute_id=>wwv_flow_imp.id(590940713627121974)
,p_display_sequence=>10
,p_display_value=>'Leading'
,p_return_value=>'LEADING'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(590941407373124847)
,p_plugin_attribute_id=>wwv_flow_imp.id(590940713627121974)
,p_display_sequence=>20
,p_display_value=>'Trailing'
,p_return_value=>'TRAILING'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(590941805432125735)
,p_plugin_attribute_id=>wwv_flow_imp.id(590940713627121974)
,p_display_sequence=>30
,p_display_value=>'Leading and Trailing'
,p_return_value=>'BOTH'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(590942527848130513)
,p_plugin_attribute_id=>wwv_flow_imp.id(590940713627121974)
,p_display_sequence=>40
,p_display_value=>'None'
,p_return_value=>'NONE'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(188715731079869844)
,p_plugin_id=>wwv_flow_imp.id(1459656641314523373)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>6
,p_display_sequence=>30
,p_prompt=>'Text Case'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'N'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(188716291127870757)
,p_plugin_attribute_id=>wwv_flow_imp.id(188715731079869844)
,p_display_sequence=>10
,p_display_value=>'No Change'
,p_return_value=>'N'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(188716724421871736)
,p_plugin_attribute_id=>wwv_flow_imp.id(188715731079869844)
,p_display_sequence=>20
,p_display_value=>'Lower'
,p_return_value=>'L'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(188717157773872286)
,p_plugin_attribute_id=>wwv_flow_imp.id(188715731079869844)
,p_display_sequence=>30
,p_display_value=>'Upper'
,p_return_value=>'U'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(188726600771210045)
,p_plugin_id=>wwv_flow_imp.id(1459656641314523373)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>7
,p_display_sequence=>10
,p_prompt=>'Subtype'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'text'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Select the HTML5 text subtype. This enables devices with on-screen keyboards to show an optimized keyboard layout specific to the subtype, for easier data input. The subtype selection is also used to render an appropriate link with the value of th'
||'e page item, if it is rendered read only. This attribute does not change the text item, or data entry, when using a physical keyboard.</p>',
'<p><strong><em>Note:</em></strong><em> This HTML5 feature only works in modern browsers. Older, non HTML5-compliant, browsers ignore this attribute and render the page item as a normal text field.</em></p>'))
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(188727255754212204)
,p_plugin_attribute_id=>wwv_flow_imp.id(188726600771210045)
,p_display_sequence=>10
,p_display_value=>'Text'
,p_return_value=>'text'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(188727630507213821)
,p_plugin_attribute_id=>wwv_flow_imp.id(188726600771210045)
,p_display_sequence=>20
,p_display_value=>'E-Mail'
,p_return_value=>'email'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(188728013637216422)
,p_plugin_attribute_id=>wwv_flow_imp.id(188726600771210045)
,p_display_sequence=>30
,p_display_value=>'Phone Number'
,p_return_value=>'tel'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(188728399158218211)
,p_plugin_attribute_id=>wwv_flow_imp.id(188726600771210045)
,p_display_sequence=>40
,p_display_value=>'Search'
,p_return_value=>'search'
);
wwv_flow_imp_shared.create_plugin_attr_value(
 p_id=>wwv_flow_imp.id(188728804710220763)
,p_plugin_attribute_id=>wwv_flow_imp.id(188726600771210045)
,p_display_sequence=>50
,p_display_value=>'URL'
,p_return_value=>'url'
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '636F6E737420666373546578744669656C643D653D3E7B224E4F4E4522213D3D652E5F7465787443617365262673657454696D656F7574282828293D3E7B6C657420742C6F3D24282223222B653F2E6964292E636C6F7365737428222E612D494722293B';
wwv_flow_imp.g_varchar2_table(2) := '76617220733B6F2E6C656E6774683E30262628743D6F2E696E746572616374697665477269642822676574566965777322293F2E67726964292C74262628733D742E676574436F6C756D6E7328293F2E66696E642828743D3E653F2E69643F2E696E636C';
wwv_flow_imp.g_varchar2_table(3) := '7564657328742E656C656D656E744964292929292C732626742E6D6F64656C3F2E666F724561636828286F3D3E7B636F6E7374206C3D742E6D6F64656C2E67657456616C7565286F2C732E70726F7065727479293B225550504552223D3D3D652E5F7465';
wwv_flow_imp.g_varchar2_table(4) := '7874436173653F742E6D6F64656C2E73657456616C7565286F2C732E70726F70657274792C6C3F2E746F5570706572436173652829293A224C4F574552223D3D3D652E5F74657874436173652626742E6D6F64656C2E73657456616C7565286F2C732E70';
wwv_flow_imp.g_varchar2_table(5) := '726F70657274792C6C3F2E746F4C6F776572436173652829297D29297D292C353030297D3B';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(110640070690752018)
,p_plugin_id=>wwv_flow_imp.id(1459656641314523373)
,p_file_name=>'fcs-text-field.min.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '2E6663732D64697361626C65642D6974656D7B706F696E7465722D6576656E74733A616C6C7D2E617065782D6974656D2D746578742E6663732D726561646F6E6C792D6974656D7B636F6C6F723A233030303B6261636B67726F756E642D636F6C6F723A';
wwv_flow_imp.g_varchar2_table(2) := '236530646564653B6F7061636974793A313B706F696E7465722D6576656E74733A616C6C7D2E617065782D6974656D2D746578742E6663732D726561646F6E6C792D6974656D3A686F7665727B6261636B67726F756E642D636F6C6F723A236530646564';
wwv_flow_imp.g_varchar2_table(3) := '657D2E617065782D6974656D2D746578742E6663732D726561646F6E6C792D6974656D3A666F6375737B6261636B67726F756E642D636F6C6F723A2365306465646521696D706F7274616E747D';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(154613137183345925)
,p_plugin_id=>wwv_flow_imp.id(1459656641314523373)
,p_file_name=>'fcs-text-field.min.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '636F6E737420666373546578744669656C64203D20286974656D29203D3E207B0D0A2020696620286974656D2E5F7465787443617365203D3D3D20274E4F4E452729207B0D0A2020202072657475726E3B0D0A20207D0D0A0D0A20202F2F20536F6D6574';
wwv_flow_imp.g_varchar2_table(2) := '696D65732074686520746578746669656C6420697320696E69746961746564206265666F7265207468652049472C20736F2064656C617920746865207365617263682E0D0A202073657454696D656F7574282829203D3E207B0D0A202020206C6574205F';
wwv_flow_imp.g_varchar2_table(3) := '677269643B0D0A202020202F2F204C6F6F6B20666F7220494720616E642067657420677269642E0D0A202020206C6574205F696724203D202428272327202B206974656D3F2E6964292E636C6F7365737428272E612D494727293B0D0A20202020696620';
wwv_flow_imp.g_varchar2_table(4) := '285F6967242E6C656E677468203E203029207B0D0A2020202020205F67726964203D205F6967242E696E746572616374697665477269642827676574566965777327293F2E677269643B0D0A202020207D0D0A0D0A2020202076617220636F6C756D6E3B';
wwv_flow_imp.g_varchar2_table(5) := '0D0A20202020696620285F6772696429207B0D0A2020202020202F2F2046696E642074686520636F6C756D6E2072656C6174656420746F207468652074657874206669656C642E0D0A202020202020636F6C756D6E203D205F677269642E676574436F6C';
wwv_flow_imp.g_varchar2_table(6) := '756D6E7328293F2E66696E6428636F6C203D3E206974656D3F2E69643F2E696E636C7564657328636F6C2E656C656D656E74496429293B0D0A202020207D0D0A2020202069662028636F6C756D6E29207B0D0A2020202020202F2F205570646174652065';
wwv_flow_imp.g_varchar2_table(7) := '616368207265636F726420696E2074686520636F6C756D6E2E0D0A2020202020205F677269642E6D6F64656C3F2E666F7245616368287265636F7264203D3E207B0D0A2020202020202020636F6E73742076616C203D205F677269642E6D6F64656C2E67';
wwv_flow_imp.g_varchar2_table(8) := '657456616C7565287265636F72642C20636F6C756D6E2E70726F7065727479293B0D0A2020202020202020696620286974656D2E5F7465787443617365203D3D3D202755505045522729207B0D0A202020202020202020205F677269642E6D6F64656C2E';
wwv_flow_imp.g_varchar2_table(9) := '73657456616C7565287265636F72642C20636F6C756D6E2E70726F70657274792C2076616C3F2E746F5570706572436173652829293B0D0A20202020202020207D20656C736520696620286974656D2E5F7465787443617365203D3D3D20274C4F574552';
wwv_flow_imp.g_varchar2_table(10) := '2729207B0D0A202020202020202020205F677269642E6D6F64656C2E73657456616C7565287265636F72642C20636F6C756D6E2E70726F70657274792C2076616C3F2E746F4C6F776572436173652829293B0D0A20202020202020207D0D0A2020202020';
wwv_flow_imp.g_varchar2_table(11) := '207D293B0D0A202020207D0D0A20207D2C20353030293B0D0A7D3B0D0A';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(188713474939750812)
,p_plugin_id=>wwv_flow_imp.id(1459656641314523373)
,p_file_name=>'fcs-text-field.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '2E6663732D64697361626C65642D6974656D207B200D0A2020202020706F696E7465722D6576656E74733A20616C6C3B0D0A7D0D0A0D0A2F2A205573696E6720636C61737320617065782D6974656D2D746578742061732077656C6C206173206663732D';
wwv_flow_imp.g_varchar2_table(2) := '726561646F6E6C792D6974656D206769766573206974207072696F72697479206F76657220746865207468656D65202A2F0D0A2E617065782D6974656D2D746578742E6663732D726561646F6E6C792D6974656D207B200D0A2020202020636F6C6F723A';
wwv_flow_imp.g_varchar2_table(3) := '20626C61636B3B0D0A20202020206261636B67726F756E642D636F6C6F723A20726762283232342C203232322C20323232293B0D0A20202020206F7061636974793A20313B0D0A2020202020706F696E7465722D6576656E74733A20616C6C3B0D0A7D0D';
wwv_flow_imp.g_varchar2_table(4) := '0A0D0A2E617065782D6974656D2D746578742E6663732D726561646F6E6C792D6974656D3A686F766572207B200D0A20202020206261636B67726F756E642D636F6C6F723A20726762283232342C203232322C20323232293B0D0A7D0D0A0D0A2E617065';
wwv_flow_imp.g_varchar2_table(5) := '782D6974656D2D746578742E6663732D726561646F6E6C792D6974656D3A666F637573207B200D0A20202020206261636B67726F756E642D636F6C6F723A20726762283232342C203232322C20323232292021696D706F7274616E743B0D0A7D0D0A';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(188714159589753156)
,p_plugin_id=>wwv_flow_imp.id(1459656641314523373)
,p_file_name=>'fcs-text-field.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
prompt --application/end_environment
begin
wwv_flow_imp.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false));
commit;
end;
/
set verify on feedback on define on
prompt  ...done
