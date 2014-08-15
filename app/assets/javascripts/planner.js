// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(function(){
    $('input[type="radio"]').click(function(){
        if ($(this).is(':checked'))
        {
            if ($(this).val() == "one_way") {
                $("#via_station").hide();
                $("#journey_date2").hide();
            }
            else {
                if ($(this).val() == "round_trip") {
                    $("#journey_date2").show();
                    $("#via_station").hide();
                }
                else {
                    $("#via_station").show();
                    $("#journey_date2").show();
                }

            }
        }
    });
});