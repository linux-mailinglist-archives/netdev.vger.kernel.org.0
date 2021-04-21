Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC5E366DE2
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 16:15:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239765AbhDUOQE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 10:16:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:46570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235339AbhDUOQD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 10:16:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D5A06144D;
        Wed, 21 Apr 2021 14:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619014530;
        bh=GMG3YoNBTM4O0A7DlywWeHR/mJ0BmCq+hm5gz760GSY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=k0OaXKxpVMrtZQW4e4wc5Cbgzi+0TOZhcmpT4yt/slkbhZOnl7X4EwRmIVeAOq6EM
         32tmQsZAL/rLcp/T+WMDgRbCIFJRbCqxcYwDYt7q2+XcBVwYEJXOTm4kCCUGfSAw9c
         rC+KOkN0JVnt9QabDnU84dvWuw52X7yL3Wx86GzEOklZZhEeD1ZINmQUS12DB2SvvY
         c+bdbM7y4q02EuRXjunEVujq+FbCUvrmUPu6lfZ8oVRhZJPQFBPAEVBL88Xkro6ptC
         Sos8IKG43KEwcpzjEYA9gfD92iAtIJltB8iT+PpmoTx7rD6rYr1/kAcfgJ5KcHjWrS
         Iq5QYqeSoElUg==
Date:   Wed, 21 Apr 2021 17:15:26 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Anna Schumaker <anna.schumaker@netapp.com>
Cc:     "J. Bruce Fields" <bfields@fieldses.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Aditya Pakki <pakki001@umn.edu>,
        Chuck Lever <chuck.lever@oracle.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dave Wysochanski <dwysocha@redhat.com>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] SUNRPC: Add a check for gss_release_msg
Message-ID: <YIAzfsMx6bn5Twu8@unreal>
References: <20210407001658.2208535-1-pakki001@umn.edu>
 <YH5/i7OvsjSmqADv@kroah.com>
 <20210420171008.GB4017@fieldses.org>
 <YH+zwQgBBGUJdiVK@unreal>
 <CAFX2JfnGCbanTaGurArBw-5F2MynPD=GpwkfU6wVoNKr9ffzRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFX2JfnGCbanTaGurArBw-5F2MynPD=GpwkfU6wVoNKr9ffzRg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 21, 2021 at 08:51:02AM -0400, Anna Schumaker wrote:
> On Wed, Apr 21, 2021 at 2:07 AM Leon Romanovsky <leon@kernel.org> wrote:
> >
> > On Tue, Apr 20, 2021 at 01:10:08PM -0400, J. Bruce Fields wrote:
> > > On Tue, Apr 20, 2021 at 09:15:23AM +0200, Greg KH wrote:
> > > > If you look at the code, this is impossible to have happen.
> > > >
> > > > Please stop submitting known-invalid patches.  Your professor is playing
> > > > around with the review process in order to achieve a paper in some
> > > > strange and bizarre way.
> > > >
> > > > This is not ok, it is wasting our time, and we will have to report this,
> > > > AGAIN, to your university...
> > >
> > > What's the story here?
> >
> > Those commits are part of the following research:
> > https://github.com/QiushiWu/QiushiWu.github.io/blob/main/papers/OpenSourceInsecurity.pdf
> 
> This thread is the first I'm hearing about this. I wonder if there is
> a good way of alerting the entire kernel community (including those
> only subscribed to subsystem mailing lists) about what's going on? It
> seems like useful information to have to push back against these
> patches.

IMHO, kernel users ML is good enough for that.
