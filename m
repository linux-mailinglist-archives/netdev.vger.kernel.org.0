Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E51E33D595
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 15:14:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236173AbhCPOOM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 10:14:12 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:49289 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232147AbhCPONo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 10:13:44 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id CE8545C00CB;
        Tue, 16 Mar 2021 10:13:43 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 16 Mar 2021 10:13:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=2SZu4+
        I8Q5L1G4Dmze9bYfnoETl1oqKBGrnnaZox2pA=; b=QB5C6OH7IsG5Wkv4CBWx9q
        4h/90/1eTyBIl5m1rbBKoL804Edzxk06z0yCOOwXCqX5FMLDhnNbWG2pN7xC03aE
        duEvbIhTtBvZ2sPCFhMzL9f2EZJe6rV2Ttu739t+zKA743HcTOdyHjUDnxt8JIID
        ZmdSeJcf1jZsoVOvQ6/mgZCJ4MQTQxEPJpJEkUsXWJetQXy890VG9rf1r3psE8TB
        4/koi+2d7ApTx9SQzglFgGCFK+wWch8E4A7iBwFSoKJ6DB9MS+nsT56j509aT4rX
        ZeJd27QjzG13eBAUrksxzYqITREX5pwtdvZnkmDODKw5TLolE8O8/cDN9v3T2dLw
        ==
X-ME-Sender: <xms:Fr1QYIhm2_8VM4_qLIwsQ7ICFZuzM4HMiyCCgO0VPcPQkak8D51Gbw>
    <xme:Fr1QYBD03st_CvYW2fuq3q9PmiPUR27yEKvuVu-pbDN5det-MxMAIJfLBBjX5Pni5
    b6nMKpG-L104eQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudefvddgiedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucfkphepkeegrddvvdelrdduheefrdeggeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:Fr1QYAGjVPM7Ltr-TcdbhKUuEVOcj22jcrgg8SWhVJdE3p_MH5FChg>
    <xmx:Fr1QYJS5Sw3uUJHaTBCrfC_zU-8OfGRG4vZIur-yneGAn1TdfEhzpw>
    <xmx:Fr1QYFzArFrMjspXxPn9bJc8OSlokHlQBDE5hHNVDI39OtZHUtq1vQ>
    <xmx:F71QYHty3g_dwuLtWVwAguxeuEFip4_Tm7oDvUpbldS08V1Ek6-8Pg>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id EEB8B24005D;
        Tue, 16 Mar 2021 10:13:41 -0400 (EDT)
Date:   Tue, 16 Mar 2021 16:13:39 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH v2 net-next 11/12] Documentation: networking: switchdev:
 clarify device driver behavior
Message-ID: <YFC9E44+pB9ZglNt@shredder.lan>
References: <20210316112419.1304230-1-olteanv@gmail.com>
 <20210316112419.1304230-12-olteanv@gmail.com>
 <YFC6KV5OSVyCHmG2@shredder.lan>
 <20210316140431.d62yq63snjf7a3jq@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316140431.d62yq63snjf7a3jq@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 16, 2021 at 04:04:31PM +0200, Vladimir Oltean wrote:
> On Tue, Mar 16, 2021 at 04:01:13PM +0200, Ido Schimmel wrote:
> > On Tue, Mar 16, 2021 at 01:24:18PM +0200, Vladimir Oltean wrote:
> > > +When the bridge has VLAN filtering enabled and a PVID is not configured on the
> > > +ingress port, untagged 802.1p tagged packets must be dropped. When the bridge
> > 
> > I think you meant "untagged and 802.1p tagged packets" ?
> 
> You're right, I'm missing the "and".
> 
> > Looks good otherwise
> 
> Thanks. I wonder, should I resend the 12 patches, or can I fix up afterwards?

Up to Dave/Jakub. I'm fine with a follow-up.

Reviewed-by: Ido Schimmel <idosch@nvidia.com>

Thanks!
