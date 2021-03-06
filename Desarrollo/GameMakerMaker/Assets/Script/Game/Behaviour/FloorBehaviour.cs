﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FloorBehaviour : Interactuable {


    public override void PostActionAnim(PlayerController player)
    {
        throw new System.NotImplementedException();
    }

    public override void PostAction(PlayerController player)
    {
        player.MarkObjectFloor.transform.rotation = Quaternion.Euler(0, 0, 0);
        player.MarkObjectFloor.transform.localScale = Vector3.one;
        player.MarkObjectFloor.SetActive(false);
    }

    public override bool PreAction(PlayerController player)
    {
        player.MarkObjectFloor.SetActive(true);
        player.MarkObjectFloor.GetComponentInChildren<SoundController>().SetTrigger("MoveClick");
        player.MarkObjectFloor.transform.position = player.click;
        
        return true;
    }

    public override bool HasToStare()
    {
        return false;
    }

    // Use this for initialization
    void Start () {
	}
}
