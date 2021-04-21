Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B2D7366D0D
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 15:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242699AbhDUNnv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 09:43:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:53988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242670AbhDUNnY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 09:43:24 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C793611F2;
        Wed, 21 Apr 2021 13:42:43 +0000 (UTC)
Date:   Wed, 21 Apr 2021 09:42:41 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Trond Myklebust <trondmy@hammerspace.com>,
        "a.shelat@northeastern.edu" <a.shelat@northeastern.edu>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "chuck.lever@oracle.com" <chuck.lever@oracle.com>,
        "dwysocha@redhat.com" <dwysocha@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "sudipm.mukherjee@gmail.com" <sudipm.mukherjee@gmail.com>,
        "bfields@fieldses.org" <bfields@fieldses.org>,
        "anna.schumaker@netapp.com" <anna.schumaker@netapp.com>,
        "pakki001@umn.edu" <pakki001@umn.edu>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] SUNRPC: Add a check for gss_release_msg
Message-ID: <20210421094241.1bb65758@gandalf.local.home>
In-Reply-To: <YIAmrgZ4Bnqo/nmI@unreal>
References: <20210407001658.2208535-1-pakki001@umn.edu>
        <YH5/i7OvsjSmqADv@kroah.com>
        <20210420171008.GB4017@fieldses.org>
        <YH+zwQgBBGUJdiVK@unreal>
        <YH+7ZydHv4+Y1hlx@kroah.com>
        <CADVatmNgU7t-Co84tSS6VW=3NcPu=17qyVyEEtVMVR_g51Ma6Q@mail.gmail.com>
        <YH/8jcoC1ffuksrf@kroah.com>
        <3B9A54F7-6A61-4A34-9EAC-95332709BAE7@northeastern.edu>
        <YIAYThdIoAPu2h7b@unreal>
        <6530850bc6f0341d1f2d5043ba1dd04e242cff66.camel@hammerspace.com>
        <YIAmrgZ4Bnqo/nmI@unreal>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 21 Apr 2021 16:20:46 +0300
Leon Romanovsky <leon@kernel.org> wrote:

> > There really is no alternative for maintainers other than to always be
> > sceptical of patches submitted by people who are not known and trusted
> > members of the community, and to scrutinise those patches with more
> > care.  
> 

There's only a couple of contributors to my code that I will take without
looking deeply at what it does. And those are well respected developers
that many other people know.

> Right, my guess is that many maintainers failed in the trap when they
> saw respectful address @umn.edu together with commit message saying
> about "new static analyzer tool".
> 
> The mental bias here is to say that "oh, another academic group tries
> to reinvent the wheel, looks ok".

I'm skeptical of all static analyzers, as I've seen too many good ones
still produce crappy fixes. I look even more carefully if I see that it was
a tool that discovered the bug and not a human.

The one patch from Greg's reverts that affects my code was actually a
legitimate fix, and looking back at the thread of the submission, I even
asked if it was found via inspection or a tool.

https://lore.kernel.org/lkml/20190419223718.17fa8246@oasis.local.home/

-- Steve
