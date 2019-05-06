Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C49A143DB
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 06:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725827AbfEFEJp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 00:09:45 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:34475 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbfEFEJp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 00:09:45 -0400
Received: by mail-ot1-f66.google.com with SMTP id l17so742437otq.1
        for <netdev@vger.kernel.org>; Sun, 05 May 2019 21:09:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:in-reply-to:references:mime-version:content-transfer-encoding
         :autocrypt:subject:to:cc:from:message-id;
        bh=sdWsXFshCwKCAXq2/1Cpg1LnerYrEbrO9PVz4eNxDEA=;
        b=YJzWLb8d0zusDQc5Imc3fgxGnS/87U+UMQkjs72CZhRVdiK+hksto9KpJt3a06nfN1
         S3uzeisP825SrCdHHGrxAIxK8SYatzL0sgf2VG9FeBhOoHl0Tl/JxMCb1kfXlnV0xrCS
         22Yc5d9R6o41Y48MJmBOV/vAT7JPDx5PTg0ZpyjRKKC4WTTpQ39sy72AqN/OO7pbraJD
         /3H6y1scgh/HUkXivPmE/FQIEQBezeHEHceq99HFZik87ZD8Co/xnype3MxFrCzo0EnL
         ibeUM5W3PsRBDcfw7KPQXX/h1s/w9o7cEYF5f0+otr6bBX+dTdLksSNWvrJzvCAtRVuA
         e1FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:references:mime-version
         :content-transfer-encoding:autocrypt:subject:to:cc:from:message-id;
        bh=sdWsXFshCwKCAXq2/1Cpg1LnerYrEbrO9PVz4eNxDEA=;
        b=fhlaDqlYaiox7mPIDgMlUXGozPBBb1IM5t5eljFMKKmZGfvJWpkmynL2LbcZzAH9Yd
         XilkeRd4QYFq6Q+lmoGicXPelieKRSnEBsMJISIugM72mD3ClV7CtXyF4UUWrKik2LAL
         U6aoSjM6Bu6QXb4JnkT9RYNGwhkSm2ptYtX39YIrWV5lQmgXt96+g27CdNS4Kr+XOEOG
         /CCayI6azknZG3DR3eel7MAbOWzG0Bfg/gr5QJxt6Jtfbjnu+eiMXBXs0x3/QwRSUvjZ
         LMKEEWZa2Lki0LT9DueQLTqBH4XfCssu0mekPzrxj+rntHiCweXKvZ5TPHp6z0g5vOIp
         ON9A==
X-Gm-Message-State: APjAAAXz7t9Wp26Erh8vghwQQ0p/2nWieuCYYWDLFNuYyzBCPlJvJ1fk
        6gC6EHcIUXNOL0AlUWJjY8k=
X-Google-Smtp-Source: APXvYqxu73LBv1EDtzQsB9lQlA6wcl5BP/7caSFnMH4GMPUnHVlH6eaOxrAuZT64q8gqQKJGjZPHtA==
X-Received: by 2002:a9d:7dd8:: with SMTP id k24mr11748374otn.170.1557115784348;
        Sun, 05 May 2019 21:09:44 -0700 (PDT)
Received: from localhost (ip68-101-123-102.oc.oc.cox.net. [68.101.123.102])
        by smtp.gmail.com with ESMTPSA id 24sm227358oiz.14.2019.05.05.21.09.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 May 2019 21:09:43 -0700 (PDT)
Date:   Sun, 05 May 2019 20:43:38 -0700
In-Reply-To: <a10e3ef7-2928-8865-c463-f9edc7261410@gmail.com>
References: <20190411230139.13160-1-olteanv@gmail.com> <3661ec3f-1a13-26d8-f7dc-7a73ac210f08@gmail.com> <a10e3ef7-2928-8865-c463-f9edc7261410@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
Subject: Re: Decoupling phy_device from net_device (was "Re: [PATCH] net: dsa: fixed-link interface is reporting SPEED_UNKNOWN")
To:     Vladimir Oltean <olteanv@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, andrew@lunn.ch,
        davem@davemloft.net
CC:     netdev@vger.kernel.org
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <EE486C77-20C3-4495-9E3D-76EE09505326@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On May 5, 2019 3:00:49 PM PDT, Vladimir Oltean <olteanv@gmail=2Ecom> wrote=
:
>On 4/12/19 8:57 PM, Heiner Kallweit wrote:
>> On 12=2E04=2E2019 01:01, Vladimir Oltean wrote:
>>> With Heiner's recent patch "b6163f194c69 net: phy: improve
>>> genphy_read_status", the phydev->speed is now initialized by default
>to
>>> SPEED_UNKNOWN even for fixed PHYs=2E This is not necessarily bad,
>since it
>>> is not correct to call genphy_config_init() and genphy_read_status()
>for
>>> a fixed PHY=2E
>>>
>> What do you mean with "it is not correct"? Whether the calls are
>always
>> needed may be a valid question, but it's not forbidden to use these
>calls
>> with a fixed PHY=2E Actually in phylib polling mode genphy_read_status
>is
>> called every second also for a fixed PHY=2E swphy emulates all relevant
>> PHY registers=2E
>>=20
>>> This dates back all the way to "39b0c705195e net: dsa: Allow
>>> configuration of CPU & DSA port speeds/duplex" (discussion thread:
>>> https://www=2Espinics=2Enet/lists/netdev/msg340862=2Ehtml)=2E
>>>
>>> I don't seem to understand why these calls were necessary back then,
>but
>>> removing these calls seemingly has no impact now apart from
>preventing
>>> the phydev->speed that was set in of_phy_register_fixed_link() from
>>> getting overwritten=2E
>>>
>> I tend to agree with the change itself, but not with the
>justification=2E
>> For genphy_config_init I'd rather say:
>> genphy_config_init removes invalid modes based on the abilities read
>> from the chip=2E But as we emulate all registers anyway, this doesn't
>> provide any benefit for a swphy=2E
>>=20
>>> Signed-off-by: Vladimir Oltean <olteanv@gmail=2Ecom>
>>> ---
>>>   net/dsa/port=2Ec | 3 ---
>>>   1 file changed, 3 deletions(-)
>>>
>>> diff --git a/net/dsa/port=2Ec b/net/dsa/port=2Ec
>>> index 87769cb38c31=2E=2E481412c892a7 100644
>>> --- a/net/dsa/port=2Ec
>>> +++ b/net/dsa/port=2Ec
>>> @@ -485,9 +485,6 @@ static int
>dsa_port_fixed_link_register_of(struct dsa_port *dp)
>>>   		mode =3D PHY_INTERFACE_MODE_NA;
>>>   	phydev->interface =3D mode;
>>>  =20
>>> -	genphy_config_init(phydev);
>>> -	genphy_read_status(phydev);
>>> -
>>>   	if (ds->ops->adjust_link)
>>>   		ds->ops->adjust_link(ds, port, phydev);
>>>  =20
>>>
>>=20
>
>Hi,
>
>I'd like to resend this, but I'm actually thinking of a nicer way to=20
>deal with the whole situation=2E
>Would people be interested in making phylib/phylink decoupled from the=20
>phydev->attached_dev? The PHY state machine could be made to simply
>call=20
>a notifier block (similar to how switchdev works) registered by=20
>interested parties (MAC driver)=2E
>To keep API compatibility (phylink_create), this notifier block could
>be=20
>put inside the net_device structure and the PHY state machine would
>call=20
>it=2E But a new phylink_create_raw could be added, which passes only the=
=20
>notifier block with no net_device=2E The CPU port and DSA ports would be=
=20
>immediate and obvious users of this (since they don't register net=20
>devices), but there are some other out-of-tree Ethernet drivers out=20
>there that have strange workarounds (create a net device that they
>don't=20
>register) to have the PHY driver do its work=2E
>Wondering what's your opinion on this and if it would be worth
>exploring=2E

If you have patches for that idea, I would be glad to take a look=2E The c=
urrent way of supporting DSA and CPU ports in DSA is now starting to show i=
ts limitations and we are not able to properly make use of PHYLINK at all f=
or those ports=2E For PHYLIB (outside of PHYLINK), I would not want the dec=
oupling to lead to e=2Eg=2E: supporting Ethernet switches with only a singl=
e net_device instance and managing all the ports using the PHYLIB notifier,=
 because that would bypass the model that DSA offers so we could miss oppor=
tunities to fix it, if needed=2E
--=20
Florian
