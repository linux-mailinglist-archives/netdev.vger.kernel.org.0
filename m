Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8A1A366B2E
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 14:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239922AbhDUMvy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 08:51:54 -0400
Received: from mail-ej1-f46.google.com ([209.85.218.46]:41774 "EHLO
        mail-ej1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239900AbhDUMvw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 08:51:52 -0400
Received: by mail-ej1-f46.google.com with SMTP id mh2so41786208ejb.8;
        Wed, 21 Apr 2021 05:51:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ndLA2M+eu6ciNQZvp40gevyZgJ40JW6t1jKr4dHYt6E=;
        b=GVdv/pJdcsjPikrL0rJn2eBqfJt+ttlaOoszt/i8xMxbLxWU1DwABVBEOvIC+7pp6l
         8Xrh4z9/hd1wq19k8nV93STQgdWfBi+RywOdatZ8kXJYuiDQt0eT9nAwDo1iAX98jpKq
         gzqqdH+JOqBdMJwzeISeR4YKTotK3GKUp9rYx4fs4I7IvXgj6qXdAJTgTh8BsBEOzRX7
         E9xwIQqJzIofUOWIyYePnSBDR1sPRzIQ7P9hoOJHvJNY06DpUNTsN9RtADQDpmFCnNwA
         w8ZZjmZTtY+hcRV2dcI7nuomNqNVaDonA83mzRXZxUvxSMvdrCV/gWmCK6B59aCD0VD4
         qeaw==
X-Gm-Message-State: AOAM532tvWOaWdGJrGnywK0G1QbjrNTRnCJ+yN1iwj3EZDjz8mQrSkp6
        V1GiLA0dvG+csLcHPKfmBUrMA5U0ZYGtFb16k6mBHk56
X-Google-Smtp-Source: ABdhPJyhc+VdqYvLWXX86cSr/y6wBO3PWkQALkB7GRQlIZpNdpHoZaohjcxYkO3CuXF0/U2VCBTxpqs72mkC/7/CnM4=
X-Received: by 2002:a17:907:72cc:: with SMTP id du12mr20167788ejc.436.1619009478136;
 Wed, 21 Apr 2021 05:51:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210407001658.2208535-1-pakki001@umn.edu> <YH5/i7OvsjSmqADv@kroah.com>
 <20210420171008.GB4017@fieldses.org> <YH+zwQgBBGUJdiVK@unreal>
In-Reply-To: <YH+zwQgBBGUJdiVK@unreal>
From:   Anna Schumaker <anna.schumaker@netapp.com>
Date:   Wed, 21 Apr 2021 08:51:02 -0400
Message-ID: <CAFX2JfnGCbanTaGurArBw-5F2MynPD=GpwkfU6wVoNKr9ffzRg@mail.gmail.com>
Subject: Re: [PATCH] SUNRPC: Add a check for gss_release_msg
To:     Leon Romanovsky <leon@kernel.org>
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
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 21, 2021 at 2:07 AM Leon Romanovsky <leon@kernel.org> wrote:
>
> On Tue, Apr 20, 2021 at 01:10:08PM -0400, J. Bruce Fields wrote:
> > On Tue, Apr 20, 2021 at 09:15:23AM +0200, Greg KH wrote:
> > > If you look at the code, this is impossible to have happen.
> > >
> > > Please stop submitting known-invalid patches.  Your professor is playing
> > > around with the review process in order to achieve a paper in some
> > > strange and bizarre way.
> > >
> > > This is not ok, it is wasting our time, and we will have to report this,
> > > AGAIN, to your university...
> >
> > What's the story here?
>
> Those commits are part of the following research:
> https://github.com/QiushiWu/QiushiWu.github.io/blob/main/papers/OpenSourceInsecurity.pdf

This thread is the first I'm hearing about this. I wonder if there is
a good way of alerting the entire kernel community (including those
only subscribed to subsystem mailing lists) about what's going on? It
seems like useful information to have to push back against these
patches.

Anna

>
> They introduce kernel bugs on purpose. Yesterday, I took a look on 4
> accepted patches from Aditya and 3 of them added various severity security
> "holes".
>
> Thanks
>
> >
> > --b.
