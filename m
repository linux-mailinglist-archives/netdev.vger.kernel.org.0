Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0CFE49B0FA
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 11:02:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237162AbiAYJy6 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 25 Jan 2022 04:54:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235323AbiAYJwG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 04:52:06 -0500
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [IPv6:2001:4b98:dc4:8::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2B24C061763;
        Tue, 25 Jan 2022 01:51:40 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 24D64100002;
        Tue, 25 Jan 2022 09:51:36 +0000 (UTC)
Date:   Tue, 25 Jan 2022 10:51:35 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Stefan Schmidt <stefan@datenfreihafen.org>
Cc:     Alexander Aring <alex.aring@gmail.com>,
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
Message-ID: <20220125105135.2f6a18dc@xps13>
In-Reply-To: <e401539a-6a05-9982-72a6-ac360b0bdf97@datenfreihafen.org>
References: <20220120112115.448077-1-miquel.raynal@bootlin.com>
        <CAB_54W5_dALTBdvXSRMpiEJBFTqVkzewHJcBjgLn79=Ku6cR9A@mail.gmail.com>
        <20220121092715.3d1de2ed@xps13>
        <e401539a-6a05-9982-72a6-ac360b0bdf97@datenfreihafen.org>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stefan,

stefan@datenfreihafen.org wrote on Fri, 21 Jan 2022 13:48:14 +0100:

> Hello.
> 
> On 21.01.22 09:27, Miquel Raynal wrote:
> > Hi Alexander,
> > 
> > alex.aring@gmail.com wrote on Thu, 20 Jan 2022 17:52:57 -0500:
> >   
> >> Hi,
> >>
> >> On Thu, 20 Jan 2022 at 06:21, Miquel Raynal <miquel.raynal@bootlin.com> wrote:  
> >>>
> >>> In preparation to a wider series, here are a number of small and random
> >>> fixes across the subsystem.
> >>>
> >>> Changes in v2:
> >>> * Fixed the build error reported by a robot. It ended up being something
> >>>    which I fixed in a commit from a following series. I've now sorted
> >>>    this out and the patch now works on its own.  
> >>>   >>  
> >> This patch series should be reviewed first and have all current
> >> detected fixes, it also should be tagged "wpan" (no need to fix that
> >> now). Then there is a following up series for a new feature which you
> >> like to tackle, maybe the "more generic symbol duration handling"? It
> >> should be based on this "fixes" patch series, Stefan will then get
> >> things sorted out to queue them right for upstream.
> >> Stefan, please correct me if I'm wrong.  
> 
> Alex, agreed. I will take this series first and see if the patches apply cleanly against my wpan tree. Once in they can be feed back into net, net-next and finally wpan-next again.
> 
> > Yup sorry that's not what I meant: the kernel robot detected that a
> > patch broke the build. This patch was part of the current series. The
> > issue was that I messed a copy paste error. But I didn't ran a
> > per-patch build test and another patch, which had nothing to do with
> > this fix, actually addressed the build issue. I very likely failed
> > something during my rebase operation. >
> > So yes, this series should come first. Then we'll tackle the symbol
> > duration series, the Kconfig cleanup and after that we can start thick
> > topics :)  
> 
> That sounds like a great plan to me. I know splitting the huge amount of work you do up into digestible pieces is work not much liked, so I appreciate that you take this without much grumble. :-)

Yeah no problem, I also know what it is like to be on the reviewer
side, and while I like to have the full contribution to get the big
picture, I also find it much easier to review smaller series, so let's
got for it now that the main boundaries for the scan support have been
shared.

> I also finally started to start my review backlog on your work. Catched up on the big v3 patchset now. Will look over the newest sets over the weekend so we should be ready to process the fixes series and maybe more next week.
> 
> >> Also, please give me the weekend to review this patch series.  
> 
> Alex, whenever you are ready with them please add you ack and I will doe my review and testing in parallel.
> 
> > Yes of course, you've been very (very) reactive so far, I try to be
> > also more reactive on my side but that's of course not a race!  
> 
> And being so reactive is very much appreciated. We just need to throttle this a bit so we can keep up with reviewer resources. :-)

Yup! I'll soon send a v3 addressing your comments, this time I'll even
split the first series so that you have a series with only fixes for
the wpan branch, and another series with very small cleanups for
wpan-next. I'll send both because they are not very big.

Thanks,
Miquèl
