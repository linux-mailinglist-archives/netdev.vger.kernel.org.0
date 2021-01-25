Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC34E302925
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 18:42:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731101AbhAYRlg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 12:41:36 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:59189 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730823AbhAYRl2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 12:41:28 -0500
Received: from compute7.internal (compute7.nyi.internal [10.202.2.47])
        by mailout.nyi.internal (Postfix) with ESMTP id 92EAF5C0117;
        Mon, 25 Jan 2021 12:40:37 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute7.internal (MEProxy); Mon, 25 Jan 2021 12:40:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=a/1Zdl8q3hrc9J13uyMUxKnwgql+l/+n6v4WGL5c3
        7I=; b=BvgBCr0wL2XfvptDg33jpQdkTVA28ZsheUyov/8+0QyMMw4ob4HiwJSqF
        zgaqju8N9jk3G4Z2bP461zNtPDRrrgkjJaNa9KCdIJrLogpdBb62PieETVbtIlY+
        luXTJeuxhJlNpOfQzPsoPSIY3N7g9PjeXKwBasR8zSy+KaYTdd8fWmLqm7O/flod
        k2XsDchEjyWABk1ceLcfXzlt/w0vi+xL+2eEkNZOuqdvly2Voehmjpu937PeBabW
        K6V5oQfKIwH7qppKbyRgzQzYN0wAZ1Jq8ofXNQcleXjhjvZc8hpltRrSc9CTeuV+
        dAYSu5p3xcfg/JRLEPw60kAyCJwRg==
X-ME-Sender: <xms:lAIPYDkFB5EGDVTQwdXFDORcQ_OVs70OAfYNZi8n-vUFKs4z4eypcQ>
    <xme:lAIPYGauWOsQHWzFpgPQkDjVSXnuHSukjZAHj6-5kkgB__-yHkn4za1S08Ime6WM_
    S8PMMIrvuM90Vo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdefgddutdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjgesthekredttddtudenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhepjeehtdevhfekgeefleffffeufedvhfegffejtefhkeehfefgkeevueekvdeu
    ffevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeegrddvvdelrdduhe
    efrdeggeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhm
    pehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:lAIPYN949f35eXPz85P6V_c-rv8CPxKnZa1Vj_KSHJiEKob50g6xcw>
    <xmx:lAIPYOFQkby8WZIaYb7-0CEfE9XOTiGo71yoVmbvPOjZVAPAhueMmA>
    <xmx:lAIPYPcmscg0e6ZvfDk958TystaM1ZeLGvbs-kAkES0y9U5vCOWw4g>
    <xmx:lQIPYOXlg-E_WAS2tYQ255jbY6oQE0i4ieC1NipzQKOpei1tQfAfjw>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id D59E81080059;
        Mon, 25 Jan 2021 12:40:35 -0500 (EST)
Date:   Mon, 25 Jan 2021 19:40:32 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jiri@nvidia.com" <jiri@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: core: devlink: add new trap action
 HARD_DROP
Message-ID: <20210125174032.GA2982684@shredder.lan>
References: <20210121112937.30989-1-oleksandr.mazur@plvision.eu>
 <20210121122152.GA2647590@shredder.lan>
 <20210121093605.49ba26ba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210125121234.GJ3565223@nanopsycho.orion>
 <AM0P190MB07387522928B6730DBE1BB77E4BD0@AM0P190MB0738.EURP190.PROD.OUTLOOK.COM>
 <20210125145614.GM3565223@nanopsycho.orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210125145614.GM3565223@nanopsycho.orion>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 25, 2021 at 03:56:14PM +0100, Jiri Pirko wrote:
> Mon, Jan 25, 2021 at 01:24:27PM CET, oleksandr.mazur@plvision.eu wrote:
> >Thu, Jan 21, 2021 at 06:36:05PM CET, kuba@kernel.org wrote:
> >>On Thu, 21 Jan 2021 14:21:52 +0200 Ido Schimmel wrote:
> >>> On Thu, Jan 21, 2021 at 01:29:37PM +0200, Oleksandr Mazur wrote:
> >>> > Add new trap action HARD_DROP, which can be used by the
> >>> > drivers to register traps, where it's impossible to get
> >>> > packet reported to the devlink subsystem by the device
> >>> > driver, because it's impossible to retrieve dropped packet
> >>> > from the device itself.
> >>> > In order to use this action, driver must also register
> >>> > additional devlink operation - callback that is used
> >>> > to retrieve number of packets that have been dropped by
> >>> > the device.  
> >>> 
> >>> Are these global statistics about number of packets the hardware dropped
> >>> for a specific reason or are these per-port statistics?
> >>> 
> >>> It's a creative use of devlink-trap interface, but I think it makes
> >>> sense. Better to re-use an existing interface than creating yet another
> >>> one.
> >>
> >>Not sure if I agree, if we can't trap why is it a trap?
> >>It's just a counter.
> >
> >>+1
> >Device might be unable to trap only the 'DROP' packets, and this information should be transparent for the user.
> >
> >I agree on the statement, that new action might be an overhead.
> >I could continue on with the solution Ido Schimmel proposed: since no new action would be needed and no UAPI changes are required, i could simply do the dropped statistics (additional field) output added upon trap stats queiring.
> >(In case if driver registerd callback, of course; and do so only for DROP actions)
> 
> It is not "a trap". You just need to count dropped packet. You don't
> trap anything. That is why I don't think this has anything to do with
> "trap" infra.

From [1] I understand that it is a trap and the action can be switched,
but when it is 'drop', the hardware can provide statistics about number
of packets that were discarded in hardware. If this is correct, then the
suggestion in [2] looks valid to me.

[1] https://lore.kernel.org/netdev/AM0P190MB073828252FFDA3215387765CE4A00@AM0P190MB0738.EURP190.PROD.OUTLOOK.COM/
[2] https://lore.kernel.org/netdev/20210123160348.GB2799851@shredder.lan/
