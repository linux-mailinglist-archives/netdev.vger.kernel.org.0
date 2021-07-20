Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7079F3D00FD
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 19:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230497AbhGTRKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 13:10:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:36836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232324AbhGTRJr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 13:09:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B18D60FF1;
        Tue, 20 Jul 2021 17:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626803425;
        bh=qUc0a5K2dRY0y17AD5Qvrg3Ms/P3hq9j5h7rfyTVtrw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fDbCWXpU7/8Y5oEO4entCLR4EKvsOwdOnKVGtDFE1qV1DWGOqeFPy1YpOxT6X7LB+
         IEpED7nSBih4co+DJPowhTA+A9a3SxCBGSoZWzyfDhvGHMv+TXR97XWJKoHGbrcao4
         hv9srI9PgrmzF2s9L6Qfb+HqgTGMyv1OJDi7Hd8U2sISc/Ai2sTcQY7uINT0/w/1lV
         V4Uc1mKKZx2ZCUycAl4BZcVJxd4ySHVaTK674VqVGV1/gJV1MnTbBhL0SH73UAUyYv
         Q2p/A/U4BZQXfYVDgv+0A628mXU7hByXmibjo6crVqdCytKo9Mqb8+oxLm9L6ON+OG
         GYQTn8Z1LrM+Q==
Date:   Tue, 20 Jul 2021 19:50:21 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH RFC net-next] net: phy: marvell10g: add downshift
 tunable support
Message-ID: <20210720195021.62feacb4@dellmb>
In-Reply-To: <20210720173941.GX22278@shell.armlinux.org.uk>
References: <E1m5pwy-0003uX-Pf@rmk-PC.armlinux.org.uk>
        <20210720170424.07cba755@dellmb>
        <20210720171401.GV22278@shell.armlinux.org.uk>
        <20210720193223.194cb79e@dellmb>
        <20210720173941.GX22278@shell.armlinux.org.uk>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Jul 2021 18:39:41 +0100
"Russell King (Oracle)" <linux@armlinux.org.uk> wrote:

> I was intending to leave the firmware version check where it was and
> just add a flag to say "this has downshift". The older firmwares on
> 3310 are basically buggy - they do downshift but only from 1G to 100M,
> they fail to go to 10M.

So we have two options

* do the firmware version comparison at the position where the given
  feature is being configured

* do the firmware version comparison in probe method and set specific
  flags for all features

The second option is better if different PHYs have differnet system of
versioning, but this can potentially lead to many different flags.

I'll leave this decision to you.

> > BTW would you agree with a patch renaming the mv3310_ prefixes to
> > mv10g_ for all functions that are generic to both mv3310_ and
> > mv2110_?
> > I was thinking about such a thing because it has become rather
> > confusing.  
> 
> I've been thinking the same thing actually.

OK I will send a patch then once your downshift patch is applied.

Marek
