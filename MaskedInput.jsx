import React from 'react';
import MaskedInput from 'react-text-mask'
class MaskedInput extends React.Component {

  // state is for keeping control state before or after changes.
  state = {
    // the things you want to put in state.
    // text: this.props.text //un comment the line to use state insted props
  }


  render() {

    return (
      <MaskedInput
        mask={['(', /[1-9]/, /\d/, /\d/, ')', ' ', /\d/, /\d/, /\d/, '-', /\d/, /\d/, /\d/, /\d/]}
        className="form-control"
        placeholder="Enter a phone number"
        guide={false}
      // onBlur={() => { }}
      // onChange={() => { }}
      />
    );

  }
}

export default MaskedInput
