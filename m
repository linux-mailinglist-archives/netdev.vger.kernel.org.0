Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78D6F291842
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 18:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbgJRQLc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 12:11:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:39550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbgJRQLc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Oct 2020 12:11:32 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9DBC20773;
        Sun, 18 Oct 2020 16:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603037492;
        bh=oU1edjV/quS1YjT8qrMt+knM1jdO9njZhtpU/LUSGbc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=t49xRc4hm0tC3Hbvz5K2Tqkr2+WWVFkQvsoZgZqVREpwW71qrf8JPkgt8N1UBa9DQ
         +xPsA7XLMhKoGAQ2cnM5YnzFtrqm08qPn00YFQ/LkjDaf5N7gih0HnZ0y2uoZZ5Xx4
         CvJTn6mrnWqUVmG3t7/tgLoA8i1XmHIOPQyxsEyc=
Date:   Sun, 18 Oct 2020 09:11:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     sundeep subbaraya <sundeep.lkml@gmail.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        rsaladi2@marvell.com, Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: Re: [net-next PATCH 06/10] octeontx2-af: Add NIX1 interfaces to NPC
Message-ID: <20201018091130.016f651f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CALHRZupNF-k-iAY2jO3JOWvdAMUQG_EAkgBWicYkutsWR3f-3Q@mail.gmail.com>
References: <1602584792-22274-1-git-send-email-sundeep.lkml@gmail.com>
        <1602584792-22274-7-git-send-email-sundeep.lkml@gmail.com>
        <20201014194804.1e3b57ae@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CALHRZupwJOZssMhE6Q_0VSCZ06WB2Sgo_BMpf2n=o7MALe+V6g@mail.gmail.com>
        <20201015083251.10bc1aaf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CALHRZurSx8JJj0cQ3dghXO0wesfNm0cS5tmzn_JrpM3wm9W3sQ@mail.gmail.com>
        <20201016104851.01ac62f4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CALHRZupNF-k-iAY2jO3JOWvdAMUQG_EAkgBWicYkutsWR3f-3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 17 Oct 2020 10:22:26 +0530 sundeep subbaraya wrote:
> > Let me rephrase the question - can the AF driver only run on the SoC
> > or are there configurations in which host can control the AF?
> >
> > I see that Kconfig depends on ARM64 but is that what you choose
> > to support or a HW limitation?  
> 
> AF driver only run on SoC and SoC is ARM64 based. Host cannot control the AF.
> Depends on ARM64 is HW limitation.

Okay, modifying the global data is probably acceptable then.

Nothing else caught my eye here, please repost when net-next reopens.

Thanks!
