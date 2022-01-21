Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2F20495BE7
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 09:27:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379587AbiAUI1k convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 21 Jan 2022 03:27:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379573AbiAUI1Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 03:27:24 -0500
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9068C061574;
        Fri, 21 Jan 2022 00:27:23 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 2C03420008;
        Fri, 21 Jan 2022 08:27:17 +0000 (UTC)
Date:   Fri, 21 Jan 2022 09:27:15 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Xue Liu <liuxuenetmail@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Harry Morris <harrymorris12@gmail.com>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [wpan-next v2 0/9] ieee802154: A bunch of fixes
Message-ID: <20220121092715.3d1de2ed@xps13>
In-Reply-To: <CAB_54W5_dALTBdvXSRMpiEJBFTqVkzewHJcBjgLn79=Ku6cR9A@mail.gmail.com>
References: <20220120112115.448077-1-miquel.raynal@bootlin.com>
        <CAB_54W5_dALTBdvXSRMpiEJBFTqVkzewHJcBjgLn79=Ku6cR9A@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

alex.aring@gmail.com wrote on Thu, 20 Jan 2022 17:52:57 -0500:

> Hi,
> 
> On Thu, 20 Jan 2022 at 06:21, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> >
> > In preparation to a wider series, here are a number of small and random
> > fixes across the subsystem.
> >
> > Changes in v2:
> > * Fixed the build error reported by a robot. It ended up being something
> >   which I fixed in a commit from a following series. I've now sorted
> >   this out and the patch now works on its own.
> >  
> 
> This patch series should be reviewed first and have all current
> detected fixes, it also should be tagged "wpan" (no need to fix that
> now). Then there is a following up series for a new feature which you
> like to tackle, maybe the "more generic symbol duration handling"? It
> should be based on this "fixes" patch series, Stefan will then get
> things sorted out to queue them right for upstream.
> Stefan, please correct me if I'm wrong.

Yup sorry that's not what I meant: the kernel robot detected that a
patch broke the build. This patch was part of the current series. The
issue was that I messed a copy paste error. But I didn't ran a
per-patch build test and another patch, which had nothing to do with
this fix, actually addressed the build issue. I very likely failed
something during my rebase operation.

So yes, this series should come first. Then we'll tackle the symbol
duration series, the Kconfig cleanup and after that we can start thick
topics :)

> Also, please give me the weekend to review this patch series.

Yes of course, you've been very (very) reactive so far, I try to be
also more reactive on my side but that's of course not a race!

Thanks,
Miquèl
