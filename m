Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B574E11065F
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 22:16:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727526AbfLCVQC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 16:16:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:37264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727430AbfLCVQC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Dec 2019 16:16:02 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4CB76205ED;
        Tue,  3 Dec 2019 21:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575407761;
        bh=sGBbTu7U/gYR30IET5lOCi/48uXHnqjeO4lUnZ+CiHo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dHGpDKrGP6Xqh/JawioZUxDsJy5a4e6gDT8kZ5vtTp13f0GwRsL8j2qrOoRj4k4xH
         2CittRcsdXCrlugg0VdKu167JE13imGL9yj6Tx0PSFEgZvNaaeEgr5s2WqA4+TI1Za
         6whAAvX/DCO26CRGN7U/c6pPu0VOOx0G52LulNuo=
Date:   Tue, 3 Dec 2019 22:15:59 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH net] tcp: refactor tcp_retransmit_timer()
Message-ID: <20191203211559.GA3269042@kroah.com>
References: <20191203160552.31071-1-edumazet@google.com>
 <20191203.115311.1412019727224973630.davem@davemloft.net>
 <20191203202358.GB3183510@kroah.com>
 <CANn89iKP7EZZRBtdcvFZVWP5-zs6uUWTgvo_Az+W+PKyA=rvxw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iKP7EZZRBtdcvFZVWP5-zs6uUWTgvo_Az+W+PKyA=rvxw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 03, 2019 at 12:51:18PM -0800, Eric Dumazet wrote:
> On Tue, Dec 3, 2019, 12:24 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> 
> > On Tue, Dec 03, 2019 at 11:53:11AM -0800, David Miller wrote:
> > > From: Eric Dumazet <edumazet@google.com>
> > > Date: Tue,  3 Dec 2019 08:05:52 -0800
> > >
> > > > It appears linux-4.14 stable needs a backport of commit
> > > > 88f8598d0a30 ("tcp: exit if nothing to retransmit on RTO timeout")
> > > >
> > > > Since tcp_rtx_queue_empty() is not in pre 4.15 kernels,
> > > > let's refactor tcp_retransmit_timer() to only use tcp_rtx_queue_head()
> > > >
> > > > I will provide to stable teams the squashed patches.
> > > >
> > > > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > >
> > > Applied, thanks Eric.
> >
> > Applied where, do you have a 4.14-stable queue too?  :)
> >
> > I can just take this directly to my 4.14.y tree now if you don't object.
> >
> 
> Sure, please do, I will double-check it ;)

Ah, nevermind, I see now that your patch does apply to Dave's tree.  I
thought this was a 4.14-only thing here.

sorry for the confusion, I'll just ignore this for now then.

greg k-h
