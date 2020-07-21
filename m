Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0599227890
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 08:05:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728159AbgGUGFe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 02:05:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:47158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726022AbgGUGFd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 02:05:33 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 708A020B1F;
        Tue, 21 Jul 2020 06:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595311533;
        bh=Ra92RBB3T38uwC1+6cbzwLA+6S/AMaal5zhfkxgir7E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jMdvwTi/DHOu6AYO8xa6iUDENtXODDjGitfqBLML4pZMtOispbr5XQAiVVct6+4C0
         L3VPP+EjTfz8diJgN6efReI+NnnF5kmAo1tB+AHWkmk7BPenwHwXLgALiyc0ftuMWa
         YTywA8Zv6ZOfNkOOkns10IBZqdUAA32Mm+SYfjm0=
Date:   Tue, 21 Jul 2020 09:05:29 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     "Alexander A. Klimov" <grandmaster@al2klimov.de>
Cc:     Jonathan Corbet <corbet@lwn.net>, santosh.shilimkar@oracle.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH for v5.9] RDS: Replace HTTP links with HTTPS ones
Message-ID: <20200721060529.GF1080481@unreal>
References: <20200719155845.59947-1-grandmaster@al2klimov.de>
 <20200720045626.GF127306@unreal>
 <20200720075848.26bc3dfe@lwn.net>
 <20200720140716.GB1080481@unreal>
 <20200720083635.3e7880ce@lwn.net>
 <20200720164827.GC1080481@unreal>
 <c78d0958-c4ef-9754-c189-ffc507ca1340@al2klimov.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c78d0958-c4ef-9754-c189-ffc507ca1340@al2klimov.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 20, 2020 at 11:34:00PM +0200, Alexander A. Klimov wrote:
>
>
> Am 20.07.20 um 18:48 schrieb Leon Romanovsky:
> > On Mon, Jul 20, 2020 at 08:36:35AM -0600, Jonathan Corbet wrote:
> > > On Mon, 20 Jul 2020 17:07:16 +0300
> > > Leon Romanovsky <leon@kernel.org> wrote:
> > >
> > > > > Do *you* want to review that megapatch?  The number of issues that have
> This question is... interesting.
> And no, I would not.

You are EXPECTED to review your work prior sending to the mailing list.

>
> > > > > come up make it clear that these patches do, indeed, need review...
> > > >
> > > > Can you point me to the issues?
> > > > What can go wrong with such a simple replacement?
> > >
> > > Some bits of the conversation:
> > >
> > >    https://lore.kernel.org/lkml/20200626110219.7ae21265@lwn.net/
> > >    https://lore.kernel.org/lkml/20200626110706.7b5d4a38@lwn.net/
> > >    https://lore.kernel.org/lkml/20200705142506.1f26a7e0@lwn.net/
> > >    https://lore.kernel.org/lkml/20200713114321.783f0ae6@lwn.net/
> > >    https://lore.kernel.org/lkml/202007081531.085533FC5@keescook/
> > >
> > > etc.
> >
> > After reading your links and especially this one.
> > https://lore.kernel.org/lkml/20200713114321.783f0ae6@lwn.net/
> > I don't understand why are we still seeing these patches?
> >
> > I gave to the author comments too, which were ignored.
> > https://patchwork.kernel.org/patch/11644683/#23466547
> I've added SPDXing (the automated way of course ;) ) to my todo list.

OMG, why don't you listen? We don't want your automatic patches.

Thanks

>
> >
> > Thanks
> >
> > >
> > > jon
