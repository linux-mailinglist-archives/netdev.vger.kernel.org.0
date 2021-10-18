Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49E824329F5
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 01:06:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbhJRXI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 19:08:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:39552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229524AbhJRXI0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 19:08:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E684D61027;
        Mon, 18 Oct 2021 23:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634598375;
        bh=oJjYusAZZIbxfy2c0kkjkheSQqJ7qhypJ+gwZ6KVzVM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sIZTtn/ojJG1P+kVwYFJ/Djf4OTzuC4qN/1yIJdp8Uxjuzme8YFD2eXD5JgCc9NRG
         tTCTSvoMlGMSLOu+YYeQ7VWVREYtMOe6wLATI6yRaMH+FAk/PlWd6gweT497V+zUUM
         uZ+Q+fNp5SUwHoeHvMukQ/oOEhdfhu338gTqmy9tVln6e9dDxAbVh6yXeLLckHBvJj
         uqFivX7Z5gQRCIufOhchlUTAObw1Hg7+UGjUJsOjn1TiSLxB4bclLDvy+UjU1sPoU8
         bxf/ndaxrC8CMxSUa0xVSGFgIALf1XjHVZ8UBmMhO2Arh/arPyTNGKMiSafTGoAwyu
         RTdYRjN+nZ7bQ==
Date:   Mon, 18 Oct 2021 16:06:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [net-next RESEND PATCH 1/2] net: dsa: qca8k: tidy for loop in
 setup and add cpu port check
Message-ID: <20211018160614.4b24959c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CA+_ehUzHm1+7MNNHg7CDmMpW5nZhzsyvG_pKm8drmSa6Mx5tNQ@mail.gmail.com>
References: <20211017145646.56-1-ansuelsmth@gmail.com>
        <20211018154812.54dbc3ef@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CA+_ehUzHm1+7MNNHg7CDmMpW5nZhzsyvG_pKm8drmSa6Mx5tNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 Oct 2021 00:54:17 +0200 Ansuel Smith wrote:
> > > Tidy and organize qca8k setup function from multiple for loop.
> > > Change for loop in bridge leave/join to scan all port and skip cpu port.
> > > No functional change intended.
> > >
> > > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>  
> >
> > There's some confusion in patchwork. I think previous posting got
> > applied, but patch 1 of this series git marked as applied.. while
> > it was patch 2 that corresponds to previous posting..?
> >
> > Please make sure you mark new postings as v2 v3 etc. It's not a problem
> > to post a vN+1 and say "no changes" in the change log, while it may be
> > a problem if patchwork bot gets confused and doesn't mark series as
> > superseded appropriately.
> >
> > I'm dropping the remainder of this series from patchwork, please rebase
> > and resend what's missing in net-next.
> >
> > Thanks!  
> 
> Sorry for the mess. I think I got confused.
> I resent these 2 patch (in one go) as i didn't add the net-next tag
> and i thought they got ignored as the target was wrong.
> I didn't receive any review or ack so i thought it was a good idea to
> resend them in one go with the correct tag.
> Hope it's not a stupid question but can you point me where should
> i check to prevent this kind of error?

You can check in patchwork if your submission was indeed ignored.

All the "active" patches are here:

https://patchwork.kernel.org/project/netdevbpf/list/

You can also look up particular patch by using it's message ID:

https://patchwork.kernel.org/project/netdevbpf/patch/<msg-id>/

E.g.

https://patchwork.kernel.org/project/netdevbpf/patch/20211017145646.56-1-ansuelsmth@gmail.com/

If the patch is in New, Under review or Needs ACK state then there's 
no need to resend.

> So anyway i both send these 2 patch as a dedicated patch with the
> absent tag.

Ah! I see the first posting of both now, looks like patchwork realized
it's a repost of patch 1 so it marked that as superseded.
