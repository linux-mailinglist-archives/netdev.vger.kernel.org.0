Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 559EB21F5EC
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 17:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728652AbgGNPNZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 11:13:25 -0400
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:59403 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbgGNPNZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 11:13:25 -0400
Received: from cwh (fob.gandi.net [217.70.181.1])
        (Authenticated sender: wxcafe@wxcafe.net)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id 29969FF806;
        Tue, 14 Jul 2020 15:13:21 +0000 (UTC)
Message-ID: <5c67c82b3988d6423317792e06a3127f97a51ba6.camel@wxcafe.net>
Subject: Re: [PATCH v3 1/4] Simplify usbnet_cdc_update_filter
From:   =?ISO-8859-1?Q?Wxcaf=E9?= <wxcafe@wxcafe.net>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Miguel =?ISO-8859-1?Q?Rodr=EDguez_P=E9rez?= 
        <miguel@det.uvigo.gal>, oliver@neukum.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org
Date:   Tue, 14 Jul 2020 11:13:18 -0400
In-Reply-To: <20200714060628.GC657428@kroah.com>
References: <20180701081550.GA7048@kroah.com>
         <20180701090553.7776-1-miguel@det.uvigo.gal>
         <20180701090553.7776-2-miguel@det.uvigo.gal>
         <b02575d7937188167ed711a403e6d9fa3f80e60d.camel@wxcafe.net>
         <20200714060628.GC657428@kroah.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Greg,

Thanks for your feedback! I'm not sure what you mean by "a format they
can be applied in", I'm guessing as three emails, with a single patch
each?

As for the issues that you mention, I'm guessing you mean applying v4
of Miguel's patches as found here (
https://patchwork.kernel.org/patch/10501163/, 
https://patchwork.kernel.org/patch/10507009/) rather than v3 as I did
here (I didn't notice there was a v4 fixing those issues, and reading
the previous messages in this thread I assumed they weren't considered
blocking. Or is there a problem left with v4 of the patches? There
doesn't seem to be any replies to the messages from 2 years ago)

Sorry for all my questions, I'm totally new to all this process...

Cheers

On Tue, 2020-07-14 at 08:06 +0200, Greg KH wrote:
> On Mon, Jul 13, 2020 at 04:43:11PM -0400, Wxcafé wrote:
> > Hey,
> > 
> > I've encountered that same problem a few days ago, found this
> > thread
> > and these (unmerged) patches, "ported" them to a more current
> > version
> > of the kernel (wasn't much work, let's be honest), and I was
> > wondering
> > if it would be possible to get them merged, because this is still a
> > problem with cdc_ncm.
> > 
> > Here's the three "up to date" patches (based on 5.8-rc5), they work
> > insofar as I'm running with them, the bug isn't there anymore (I
> > get
> > ethernet multicast packets correctly), and there's no obvious bug.
> > I'm
> > not a dev though, so I have no idea if these are formatted
> > correctly,
> > if the patch separation is correct, or anything like that, I just
> > think
> > it would be great if this could be merged into mainline!
> 
> You need to submit them in a format they can be applied in, as well
> as
> taking care of the issues that caused Oliver to not agree with them.
> 
> thanks,
> 
> greg k-h
-- 
Wxcafé <wxcafe@wxcafe.net>

