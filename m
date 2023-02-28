Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D11F6A5A55
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 14:48:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbjB1Nsx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 08:48:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbjB1Nss (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 08:48:48 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7430AC
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 05:48:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=public-files.de;
        s=s31663417; t=1677592100; i=frank-w@public-files.de;
        bh=2YpcNOSGE0jbZslKPI/mf3HRAyT+1Nt33F3GdqqN4LE=;
        h=X-UI-Sender-Class:Date:From:To:CC:Subject:Reply-to:In-Reply-To:
         References;
        b=lnyomj0TShlfO+glNYsFWC8oC4SYkr7y2Y25Jiws3bu9Gqm2lMR0MrGg4l02wdIAe
         my20PYTkNz7HHy68YO9KqRgHlyhaamS/wKhvywtk5N/a5oJpMRnM5foY8vGhAVHbRT
         QepO1nFXqHQL6CFBbXvNe72yl369ph3/2d8DpmCw6EH5Kz/zhpz8u8By/GQwtm4B11
         hP9HRfeOyQ/NeSjh6nCzijlrWHZlA2eCIaywX6MuDf8aDCwHkpooMr6XtMxDSkznbl
         iW/dtWWfVRbMmNP+Wxl8YHtDEqt4oqn/gEMDbfTSu79uC5l0dtkt6zVhzxUQkn+XE6
         u84KVW1X7LndA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [IPv6:::1] ([80.187.66.158]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MwfWa-1oZHz741Oc-00yCBo; Tue, 28
 Feb 2023 14:48:20 +0100
Date:   Tue, 28 Feb 2023 14:48:13 +0100
From:   Frank Wunderlich <frank-w@public-files.de>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Felix Fietkau <nbd@nbd.name>, netdev <netdev@vger.kernel.org>,
        erkin.bozoglu@xeront.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Crispin <john@phrozen.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: Re: Choose a default DSA CPU port
User-Agent: K-9 Mail for Android
Reply-to: frank-w@public-files.de
In-Reply-To: <20230228115846.4r2wuyhsccmrpdfh@skbuf>
References: <trinity-4ef08653-c2e7-4da8-8572-4081dca0e2f7-1677271483935@3c-app-gmx-bap70> <20230224210852.np3kduoqhrbzuqg3@skbuf> <trinity-5a3fbd85-79ce-4021-957f-aea9617bb320-1677333013552@3c-app-gmx-bap06> <f9fcf74b-7e30-9b51-776b-6a3537236bf6@arinc9.com> <6383a98a-1b00-913d-0db1-fe33685a8410@arinc9.com> <trinity-6ad483d2-5c50-4f38-b386-f4941c85c1fd-1677413524438@3c-app-gmx-bs15> <20230228115846.4r2wuyhsccmrpdfh@skbuf>
Message-ID: <CB415113-7581-475E-9BB9-48F6A8707C15@public-files.de>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:eA7FU6qF8VHzmU4Cs5gyf60xiFVRRd4n0SnuJjWeN6IeiaB2wIc
 JfvFcomIl/bW+7iNJ8PNc9PO+nq9yRrQ6rrYk/LHQ/OEUIhM+h0EubpQLz8XkeJYyP1UEEv
 xwDQSPmWDKDs76JrRhz8MF+esE2OS14vHwoMwMC0VigUWd+iKbwvQ7qhJWhW9qrM3p9zfs/
 IYR7J6+rnHgVHR8RHcivQ==
UI-OutboundReport: notjunk:1;M01:P0:PUuD8YwBOZo=;V7w3ZqktZSZCzZNVCvpI7OEMSKr
 m1JgxxRM9C/NlkHifB8897McFYYik0TBSi6NhM6/aBmX2SDTfFe2nbDVqPhiniPXNwLbZaeS1
 Un7tmq2sYO5iyK1qkEbF7WkfZbqyJcbdpeAmhbRO0E8hHtOTg4kjstGMoAbdA5C4x+iURYc/P
 zANpOOWBy/EdlxeAjeJgaK5JRWwwS6/YbLaZmHgOM+FzPY0N0JGVxwaAxH5Oh3N+Z875OnWZy
 rsMPcTc4GTVTqAlMdfQpfqcMx6ICwlmpRJdUpoKTxcoP6dspj5Yjgy7FDDNjv+joPKgpDeIQ2
 T5ay+bK416p680Dhfy8Snk24/W1VZhc5CM91Rob4kt8XRKTpBZd6yCxtWKCx9VUrn7PpdUU/k
 kfz8HbyX0xenSMnEGsz5y5RWD0fKF7fsRux9S7KESQSpnMFRrBBXzDf6O3fnytsNT1oTFhlh6
 K7fTVsLAbUzIOAeNnXGlzdA+U4Orf7F0wCvBxX6YvIJiFz1QpRxWWMWgTpwTF/UA/OvSVcHII
 ARcK55avalw0zFOT5Vo0o766hy3veR6ibXqAlL2ZxjMqZ9sRS+ypxXCoohZkMESwFX8o3EOJQ
 oFpIIDzbC1K2jbBcFGmGEKhyGUSEPYEvRFxhM2Gf1ks9VVhmCGyArffgRX419NC5Ar9toTBsA
 TzxLYBRlzDUi8Do2/b8r51XbuWFOXQpmfGPk2Uw5FxGaGggg+Eh/mofmvjBo0NRZh3pzSxOsI
 ZrKuuCrRxqn8jj93Slc9oFjkCx8z+mxWHf4CB0m7vzgWclwxI+zaYYkFDYAaZMO2GyWhPXUSn
 DKzHMj9jrkqmQa7q9kRSoUCWnfXQgw/CvD56nHyzWBQrZSPBgFCTKI+HOSTdqQ2Jrau8v3blb
 HLniwVHPg3Z8MPw2Vqoqcm9QizXThCxTKNewtzyXhjgguhN3eE9ton7uWNcp6rK2i3oPwBrnQ
 XP+4UCvW5//DYzcRAA6PrlUK++ED8r3MKxEa8qSQ+9dhNPUVxEaYVfd6C4p5pWtIMuxe0A==
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 28=2E Februar 2023 12:58:46 MEZ schrieb Vladimir Oltean <olteanv@gmail=
=2Ecom>:
>On Sun, Feb 26, 2023 at 01:12:04PM +0100, Frank Wunderlich wrote:
>> but back to topic=2E=2E=2Ewe have a patch from vladuimir which allows
>> setting the preferred cpu-port=2E=2E=2Ehow do we handle mt7531 here
>> correctly (which still sets port5 if defined and then break)?
>>=20
>> https://git=2Ekernel=2Eorg/pub/scm/linux/kernel/git/netdev/net-next=2Eg=
it/tree/drivers/net/dsa/mt7530=2Ec#n2383
>>=20
>> 	/* BPDU to CPU port */
>> 	dsa_switch_for_each_cpu_port(cpu_dp, ds) {
>> 		mt7530_rmw(priv, MT7531_CFC, MT7531_CPU_PMAP_MASK,
>> 			   BIT(cpu_dp->index));
>> 		break; //<<< should we drop this break only to set all "cpu-bits"? wh=
at happens then (flooding both ports with packets?)
>> 	}
>>=20
>> as dsa only handles only 1 cpu-port we want the real cpu-port
>> (preferred | first)=2E is this bit set also if the master is changed
>> with your follow-up patch?
>
>Could you please make a best-effort attempt at describing what does the
>MT7531_CFC[MT7531_CPU_PMAP_MASK] register affect? From the comment, if
>affects the trapping of control packets=2E Does the MT7530 not have this
>register? Do they behave differently? Does the register affect anything
>else? If that logic is commented out, does DSA-tagged traffic still work
>on MT7531? How about a bridge created with stp_state 1? I don't
>understand at the moment why the hardware allows specifying a port mask
>rather than a single port=2E Intuitively I'd say that if this field
>contains more than one bit set, then control packets would be delivered
>to all CPU ports that are up, effectively resulting in double processing
>in Linux=2E So that doesn't seem to be useful=2E But I don't have enough =
data=2E

I have only this datasheet from bpi for mt7531

https://drive=2Egoogle=2Ecom/file/d/1aVdQz3rbKWjkvdga8-LQ-VFXjmHR8yf9/view

On page 23 the register is defined but without additional information abou=
t setting multiple bits in this range=2E CFC IS CPU_FORWARD_CONTROL registe=
r and CPU_PMAP is a 8bit part of it which have a bit for selecting each por=
t as cpu-port (0-7)=2E I found no information about packets sent over both =
cpu-ports, round-robin or something else=2E

For mt7530 i have no such document=2E

The way i got from mtk some time ago was using a vlan_aware bridge for sel=
ecting a "cpu-port" for a specific user-port=2E At this point port5 was no =
cpu-port and traffic is directly routed to this port bypassing dsa and the =
cpu-port define in driver=2E=2E=2Eafaik this way port5 was handled as userp=
ort too=2E
regards Frank
