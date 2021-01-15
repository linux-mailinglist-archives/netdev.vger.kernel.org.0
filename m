Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CDE62F85A4
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 20:40:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387988AbhAOTh6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 14:37:58 -0500
Received: from fllv0015.ext.ti.com ([198.47.19.141]:38910 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732952AbhAOTh4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 14:37:56 -0500
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 10FJZf0h011434;
        Fri, 15 Jan 2021 13:35:41 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1610739341;
        bh=DEQ6bZhEA+ydF3cpyj6mYz/unhwgY9HoC1Fw2uxZ3BI=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=V6ukNKUXlSvtX1cUdjJJCrMMZmmfyBLzJZdS/kUvx61LCXhNVb7XeIx8JoS3NSLRH
         LHLvJW16h8lKG6frO9n5FSjVe6zIAcGeJ58u6A6KjrKVuXSnvzkqf7LlQDhshruQEJ
         h7v4wL7tESf8ocwmTMTXQufofxCTidjIW/Wxgklw=
Received: from DLEE109.ent.ti.com (dlee109.ent.ti.com [157.170.170.41])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 10FJZe0k105994
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 15 Jan 2021 13:35:41 -0600
Received: from DLEE107.ent.ti.com (157.170.170.37) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 15
 Jan 2021 13:35:40 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE107.ent.ti.com
 (157.170.170.37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 15 Jan 2021 13:35:40 -0600
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 10FJZUTY024413;
        Fri, 15 Jan 2021 13:35:33 -0600
Subject: Re: [PATCH v4 net-next 01/11] net: switchdev: remove vid_begin ->
 vid_end range from VLAN objects
To:     Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Petr Machata <petrm@nvidia.com>
References: <20210109000156.1246735-1-olteanv@gmail.com>
 <20210109000156.1246735-2-olteanv@gmail.com>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <75bd8b0d-d765-20f3-e407-28c2ef4ac52e@ti.com>
Date:   Fri, 15 Jan 2021 21:35:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210109000156.1246735-2-olteanv@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 09/01/2021 02:01, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The call path of a switchdev VLAN addition to the bridge looks something
> like this today:
> 
>          nbp_vlan_init
>          |  __br_vlan_set_default_pvid
>          |  |                       |
>          |  |    br_afspec          |
>          |  |        |              |
>          |  |        v              |
>          |  | br_process_vlan_info  |
>          |  |        |              |
>          |  |        v              |
>          |  |   br_vlan_info        |
>          |  |       / \            /
>          |  |      /   \          /
>          |  |     /     \        /
>          |  |    /       \      /
>          v  v   v         v    v
>        nbp_vlan_add   br_vlan_add ------+
>         |              ^      ^ |       |
>         |             /       | |       |
>         |            /       /  /       |
>         \ br_vlan_get_master/  /        v
>          \        ^        /  /  br_vlan_add_existing
>           \       |       /  /          |
>            \      |      /  /          /
>             \     |     /  /          /
>              \    |    /  /          /
>               \   |   /  /          /
>                v  |   | v          /
>                __vlan_add         /
>                   / |            /
>                  /  |           /
>                 v   |          /
>     __vlan_vid_add  |         /
>                 \   |        /
>                  v  v        v
>        br_switchdev_port_vlan_add
> 
> The ranges UAPI was introduced to the bridge in commit bdced7ef7838
> ("bridge: support for multiple vlans and vlan ranges in setlink and
> dellink requests") (Jan 10 2015). But the VLAN ranges (parsed in br_afspec)
> have always been passed one by one, through struct bridge_vlan_info
> tmp_vinfo, to br_vlan_info. So the range never went too far in depth.
> 
> Then Scott Feldman introduced the switchdev_port_bridge_setlink function
> in commit 47f8328bb1a4 ("switchdev: add new switchdev bridge setlink").
> That marked the introduction of the SWITCHDEV_OBJ_PORT_VLAN, which made
> full use of the range. But switchdev_port_bridge_setlink was called like
> this:
> 
> br_setlink
> -> br_afspec
> -> switchdev_port_bridge_setlink
> 
> Basically, the switchdev and the bridge code were not tightly integrated.
> Then commit 41c498b9359e ("bridge: restore br_setlink back to original")
> came, and switchdev drivers were required to implement
> .ndo_bridge_setlink = switchdev_port_bridge_setlink for a while.
> 
> In the meantime, commits such as 0944d6b5a2fa ("bridge: try switchdev op
> first in __vlan_vid_add/del") finally made switchdev penetrate the
> br_vlan_info() barrier and start to develop the call path we have today.
> But remember, br_vlan_info() still receives VLANs one by one.
> 
> Then Arkadi Sharshevsky refactored the switchdev API in 2017 in commit
> 29ab586c3d83 ("net: switchdev: Remove bridge bypass support from
> switchdev") so that drivers would not implement .ndo_bridge_setlink any
> longer. The switchdev_port_bridge_setlink also got deleted.
> This refactoring removed the parallel bridge_setlink implementation from
> switchdev, and left the only switchdev VLAN objects to be the ones
> offloaded from __vlan_vid_add (basically RX filtering) and  __vlan_add
> (the latter coming from commit 9c86ce2c1ae3 ("net: bridge: Notify about
> bridge VLANs")).
> 
> That is to say, today the switchdev VLAN object ranges are not used in
> the kernel. Refactoring the above call path is a bit complicated, when
> the bridge VLAN call path is already a bit complicated.
> 
> Let's go off and finish the job of commit 29ab586c3d83 by deleting the
> bogus iteration through the VLAN ranges from the drivers. Some aspects
> of this feature never made too much sense in the first place. For
> example, what is a range of VLANs all having the BRIDGE_VLAN_INFO_PVID
> flag supposed to mean, when a port can obviously have a single pvid?
> This particular configuration _is_ denied as of commit 6623c60dc28e
> ("bridge: vlan: enforce no pvid flag in vlan ranges"), but from an API
> perspective, the driver still has to play pretend, and only offload the
> vlan->vid_end as pvid. And the addition of a switchdev VLAN object can
> modify the flags of another, completely unrelated, switchdev VLAN
> object! (a VLAN that is PVID will invalidate the PVID flag from whatever
> other VLAN had previously been offloaded with switchdev and had that
> flag. Yet switchdev never notifies about that change, drivers are
> supposed to guess).
> 
> Nonetheless, having a VLAN range in the API makes error handling look
> scarier than it really is - unwinding on errors and all of that.
> When in reality, no one really calls this API with more than one VLAN.
> It is all unnecessary complexity.
> 
> And despite appearing pretentious (two-phase transactional model and
> all), the switchdev API is really sloppy because the VLAN addition and
> removal operations are not paired with one another (you can add a VLAN
> 100 times and delete it just once). The bridge notifies through
> switchdev of a VLAN addition not only when the flags of an existing VLAN
> change, but also when nothing changes. There are switchdev drivers out
> there who don't like adding a VLAN that has already been added, and
> those checks don't really belong at driver level. But the fact that the
> API contains ranges is yet another factor that prevents this from being
> addressed in the future.
> 
> Of the existing switchdev pieces of hardware, it appears that only
> Mellanox Spectrum supports offloading more than one VLAN at a time,
> through mlxsw_sp_port_vlan_set. I have kept that code internal to the
> driver, because there is some more bookkeeping that makes use of it, but
> I deleted it from the switchdev API. But since the switchdev support for
> ranges has already been de facto deleted by a Mellanox employee and
> nobody noticed for 4 years, I'm going to assume it's not a biggie.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com> # switchdev and mlxsw
Reviewed-by: Grygorii Strashko <grygorii.strashko@ti.com> # cpsw_switchdev

-- 
Best regards,
grygorii
