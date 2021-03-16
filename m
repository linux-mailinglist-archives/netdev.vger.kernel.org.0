Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC2FF33D56B
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 15:05:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235866AbhCPOEc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 10:04:32 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:41563 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235879AbhCPOE3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 10:04:29 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 80B7D5C0121;
        Tue, 16 Mar 2021 10:04:28 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Tue, 16 Mar 2021 10:04:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=hDne/N
        iOBtu9tPE9RnLVvEXSSi4Z8k990R38CF4eGHA=; b=YNEm6igasmPgICsavL2kVY
        EKN96srwkNSBvSOGivn00+3x9vXuUVd8nKTlsDtbG6whd2BodQ9LUO0ogfh4KPKP
        SwASxnQwYqRV2zJtccnVIaY1bo1zyVtMCHBuhizlsSjzNxasxlMEvfJvrxHgMosV
        e0zGcMKrBfd9VxFcX6hWcufTZA7Ts9VgysWUEKoNYgiEbAagV/WKm9jqkW9DHCK3
        yRaiuL+HpVzGWdgDWXBCxawVnh19EWpHUDGiy9+oM6f55pRT7rSmjRl3laEs3tCF
        asuwaVLJO6iFbd7qXxhyOm2f0M+32b6kuQcY2KJyDgRWGQq8yjhO+koHYy3iwEWw
        ==
X-ME-Sender: <xms:6rpQYHiqpcOJKWKkqPO97zbBUyPXzlvu2HVVNfJ3njJkjvfYDBL-1Q>
    <xme:6rpQYM--TV9pGUIx3XtRRHBurZyTVOai50SlMsMJefOC8l9CmtGC19G4IuPThDa4Z
    YQT6FvbEBoLNoY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudefvddgheelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucfkphepkeegrddvvdelrdduheefrdeggeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:67pQYCqAlSxQxlJI2USx6OTt2yjL7f_RhmkTx61ISQjkH5tnJrEKHQ>
    <xmx:67pQYEWP9tadEOJNXfuS_uTSJntxeFF345514a9DeFKMUs_0rKKXMg>
    <xmx:67pQYBBZEj7XvWy0hsh-xBgpaw2FcVp9SOvvWhomKjv4Olm654ZXzA>
    <xmx:7LpQYJ6cP7rE-LX6xL85RcBxe1O0Y8M_RIA1-w1NyQVxoLMkBsgC7w>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7BF6D240065;
        Tue, 16 Mar 2021 10:04:26 -0400 (EDT)
Date:   Tue, 16 Mar 2021 16:04:22 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH v2 net-next 12/12] Documentation: networking: switchdev:
 fix command for static FDB entries
Message-ID: <YFC65sQVaJIM3dl0@shredder.lan>
References: <20210316112419.1304230-1-olteanv@gmail.com>
 <20210316112419.1304230-13-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316112419.1304230-13-olteanv@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 16, 2021 at 01:24:19PM +0200, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The "bridge fdb add" command provided in the switchdev documentation is
> junk now, not only because it is syntactically incorrect and rejected by
> the iproute2 bridge program, but also because it was not updated in
> light of Arkadi Sharshevsky's radical switchdev refactoring in commit
> 29ab586c3d83 ("net: switchdev: Remove bridge bypass support from
> switchdev"). Try to explain what the intended usage pattern is with the
> new kernel implementation.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
