const fcsTextField = (item) => {
  if (item._textCase === 'NONE') {
    return;
  }

  // Sometimes the textfield is initiated before the IG, so delay the search.
  setTimeout(() => {
    let _grid;
    // Look for IG and get grid.
    let _ig$ = $('#' + item?.id).closest('.a-IG');
    if (_ig$.length > 0) {
      _grid = _ig$.interactiveGrid('getViews')?.grid;
    }

    var column;
    if (_grid) {
      // Find the column related to the text field.
      column = _grid.getColumns()?.find(col => item?.id?.includes(col.elementId));
    }
    if (column) {
      // Update each record in the column.
      _grid.model?.forEach(record => {
        const val = _grid.model.getValue(record, column.property);
        if (item._textCase === 'UPPER') {
          _grid.model.setValue(record, column.property, val?.toUpperCase());
        } else if (item._textCase === 'LOWER') {
          _grid.model.setValue(record, column.property, val?.toLowerCase());
        }
      });
    }
  }, 500);
};
