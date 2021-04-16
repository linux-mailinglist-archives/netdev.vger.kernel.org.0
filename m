Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D2D53623C8
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 17:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343541AbhDPPVy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 11:21:54 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:48687 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245502AbhDPPU0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 11:20:26 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 951815807AD;
        Fri, 16 Apr 2021 11:19:59 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 16 Apr 2021 11:19:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=toiCW1
        I5/vRVU8T5TulYjoFeHwpLgWzOP/S3J2c6LmE=; b=YXgqGzWJUKCwXGCK5nWt9A
        lbpnmt7cpv4UYbbOZjZhDY/z1nk9UIVDFSMxcJP2cy4OctdVBPqEy89keDsEuRjm
        Kv5DSApYLROY+PkOOIVc2YVVEdvSaaSlgkXxq3vUCiNLlxDX3vmZQeDc4oLTI2JG
        XdD2PP2JNlQmhDdtJZ58CZzFb3p87SOaOch4EjdLpTzcisPLzYJJ8irwcuQHI7tM
        GtWd1GxXPoyLnkezi+Kqu3KOg42p9TeG/6b/Jvs0AxNgkbSMoACCczSXVk0nT8b9
        duR/r29t80lJrT9HZ6lZd9bb20ESOAzCeVJkF3KOfle4hvSrs3aUk3nKeZuJhEFw
        ==
X-ME-Sender: <xms:Hqt5YKPRB9jgJv_wDUxZihQnRKQnkLvXXKe_ub_I8cg7drGtr1GzYw>
    <xme:Hqt5YNSfiDsorQ4GBk-711wd6DMJMvNhJL_ILS1KFAkh3k6UUr2ssBL4yyfZTMpnP
    6YRN_SLrw4ZKEw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudelhedgkeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucfkphepkeegrddvvdelrdduheefrddukeejnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:Hqt5YAY4ySPESyKjgS48oBddtrvPywjHLADjUijabN25o3ga8yzn_A>
    <xmx:Hqt5YC02XJBgitmiiNM5_ybe4KPzkOCpPiILXwun9hO4WmDNaB_6Jw>
    <xmx:Hqt5YIWH6XtivkLr2tx1J1PGszR34Jm2S96HEKlJH9IdQqzNxiJC9A>
    <xmx:H6t5YAcHPyvklCu-Mh_9lO6E89aqCmdmV8zzR1ZAJfyEq1Nx8owK_g>
Received: from localhost (igld-84-229-153-187.inter.net.il [84.229.153.187])
        by mail.messagingengine.com (Postfix) with ESMTPA id D6C6D1080067;
        Fri, 16 Apr 2021 11:19:57 -0400 (EDT)
Date:   Fri, 16 Apr 2021 18:19:53 +0300
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
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH resend net-next 1/2] net: bridge: switchdev: refactor
 br_switchdev_fdb_notify
Message-ID: <YHmrGWUv4cHvP800@shredder.lan>
References: <20210414165256.1837753-1-olteanv@gmail.com>
 <20210414165256.1837753-2-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210414165256.1837753-2-olteanv@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 14, 2021 at 07:52:55PM +0300, Vladimir Oltean wrote:
> From: Tobias Waldekranz <tobias@waldekranz.com>
> 
> Instead of having to add more and more arguments to
> br_switchdev_fdb_call_notifiers, get rid of it and build the info
> struct directly in br_switchdev_fdb_notify.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
