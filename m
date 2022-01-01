Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 599F7482810
	for <lists+netdev@lfdr.de>; Sat,  1 Jan 2022 18:41:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232603AbiAARl2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jan 2022 12:41:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230259AbiAARl1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Jan 2022 12:41:27 -0500
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DD6CC061574;
        Sat,  1 Jan 2022 09:41:27 -0800 (PST)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.94.2)
        (envelope-from <daniel@makrotopia.org>)
        id 1n3iNV-0007Lq-3h; Sat, 01 Jan 2022 18:41:13 +0100
Date:   Sat, 1 Jan 2022 17:41:07 +0000
From:   Daniel Golle <daniel@makrotopia.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        linux-mediatek@lists.infradead.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Michael Lee <igvtee@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH v9 1/3] net: mdio: add helpers to extract clause 45 regad
 and devad fields
Message-ID: <YdCSM7DiJ+vvfmji@makrotopia.org>
References: <Ycr5Cna76eg2B0An@shell.armlinux.org.uk>
 <Yc9tk6IZ0ldqHx4Y@makrotopia.org>
 <YdCM/mbeT66asmj7@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YdCM/mbeT66asmj7@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 01, 2022 at 06:18:54PM +0100, Andrew Lunn wrote:
> On Fri, Dec 31, 2021 at 08:52:35PM +0000, Russell King (Oracle) wrote:
> > Add a couple of helpers and definitions to extract the clause 45 regad
> > and devad fields from the regnum passed into MDIO drivers.
> > 
> > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> 
> This email has me confused. It seems to be coming directly from
> Russell, but is part of a patchset? Then there is a second 1/3 later
> in the patchset?

That happened by accident when using git-send-email and hence the
first time it was sent with Russell's From: in the RFC822 headers it
was (rightly) rejected.
I noticed that shortly after and resend the patch with my sender
address set as From: in the RFC822 headers and Russell's From: in the
mail body for only git, and not mailservers, to care about.

Sorry for that additional noise.
