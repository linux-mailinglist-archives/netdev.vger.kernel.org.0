Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A96223623CF
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 17:22:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343614AbhDPPWj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 11:22:39 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:35221 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245427AbhDPPWh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 11:22:37 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 641075807C3;
        Fri, 16 Apr 2021 11:22:12 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 16 Apr 2021 11:22:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=pYMXCX
        UB4NrEObMaHNGViuQ/g33HrPafLO6bqyrl1js=; b=eEwlnK3ahM/w8V66CZrDiU
        rHP3k/7/FzxygyY9TiKPbHUtWF59MNvtMZYXHG3NdKJSYO9wTRacx27/+eg1yhCC
        i+YcUg3ShfUAMVJchXh4XxrKdzyCzeu9AMAjCGO/8AhoSic09Sw/LIjhwUvWt5oz
        zHlfNlGjwZAeCKPgjBo2ILESWUUVn5HYRkpzPgGWzsff0nngnJUsdFItPl70535D
        j9+hj5ATM+UPImOckBrBYFb8Nxct8ojl7iBQ55WEW4WmU20wdY9SHSnDIPm1I0ar
        fYS4bTAsuhcvcyFkqgHV20YXhOA4/xi0ItU5bBUVyyyXB005YKuMsT24mJ2X6j/Q
        ==
X-ME-Sender: <xms:o6t5YNwDXiRTnAyaP-nZY4mlfo70WMXkeYXdOKPTwe0Tnw8c9zfO2A>
    <xme:o6t5YNRoRZInK9FaQBqhH8PPaJbnp312Wcb8dejIPl9sCBV3T7G2GZRtGTicOetsu
    zuX-Sz_oQzYyTg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudelhedgkeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpefgvefgveeuudeuffeiffehieffgfejleevtdetueetueffkeevgffgtddugfek
    veenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekgedrvddvledrudehfe
    drudekjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhm
    pehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:o6t5YHVyjBZ_MUPMTOv1Mua1R6b0PWDw4r1nM0laGjRXoz2yW4dIPg>
    <xmx:o6t5YPhFYQdm9JxkJAIUCjt9c_xpSBTU4Cs7GOjCylQqaSkBsKA2pA>
    <xmx:o6t5YPBeK1aVbiEsghlWDhOCHF_6lkMHXm37-FDNVQsV7aCocmm0Dg>
    <xmx:pKt5YL3sZ5u1Ne2ndurWiXHbxYyDn3-lZ_C1wksJhJ7KEQ5Ev0s_CA>
Received: from localhost (igld-84-229-153-187.inter.net.il [84.229.153.187])
        by mail.messagingengine.com (Postfix) with ESMTPA id 89AA71080063;
        Fri, 16 Apr 2021 11:22:10 -0400 (EDT)
Date:   Fri, 16 Apr 2021 18:22:08 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-omap@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: Re: [PATCH resend net-next 2/2] net: bridge: switchdev: include
 local flag in FDB notifications
Message-ID: <YHmroFOPM3Hl/5uP@shredder.lan>
References: <20210414165256.1837753-1-olteanv@gmail.com>
 <20210414165256.1837753-3-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210414165256.1837753-3-olteanv@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 14, 2021 at 07:52:56PM +0300, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> As explained in bugfix commit 6ab4c3117aec ("net: bridge: don't notify
> switchdev for local FDB addresses") as well as in this discussion:
> https://lore.kernel.org/netdev/20210117193009.io3nungdwuzmo5f7@skbuf/
> 
> the switchdev notifiers for FDB entries managed to have a zero-day bug,
> which was that drivers would not know what to do with local FDB entries,
> because they were not told that they are local. The bug fix was to
> simply not notify them of those addresses.
> 
> Let us now add the 'is_local' bit to bridge FDB entries, and make all
> drivers ignore these entries by their own choice.
> 
> Co-developed-by: Tobias Waldekranz <tobias@waldekranz.com>
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>

One comment below

> diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
> index c390f84adea2..a5e601e41cb9 100644
> --- a/net/bridge/br_switchdev.c
> +++ b/net/bridge/br_switchdev.c
> @@ -114,13 +114,12 @@ br_switchdev_fdb_notify(const struct net_bridge_fdb_entry *fdb, int type)
>  		.addr = fdb->key.addr.addr,
>  		.vid = fdb->key.vlan_id,
>  		.added_by_user = test_bit(BR_FDB_ADDED_BY_USER, &fdb->flags),
> +		.is_local = test_bit(BR_FDB_LOCAL, &fdb->flags),
>  		.offloaded = test_bit(BR_FDB_OFFLOADED, &fdb->flags),
>  	};
>  
>  	if (!fdb->dst)
>  		return;

Do you plan to eventually remove this check so that entries pointing to
the bridge device itself will be notified? For example:

# bridge fdb add 00:01:02:03:04:05 dev br0 self local

> -	if (test_bit(BR_FDB_LOCAL, &fdb->flags))
> -		return;
>  
>  	switch (type) {
>  	case RTM_DELNEIGH:
