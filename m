Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF1D21105E7
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 21:24:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727209AbfLCUYJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 15:24:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:50506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726079AbfLCUYJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Dec 2019 15:24:09 -0500
Received: from localhost (unknown [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2BFE4206DF;
        Tue,  3 Dec 2019 20:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575404648;
        bh=7sUEA55Mho0sib7MhkZmJWHjHzSqgY8JXTJ1Ir6UGMo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=V3rTxc90QSjMXAnW4LAaULT6Q1bZZ3Z7MPoiV1u3wfQNgERB69rsbkiWx5YEDGSOA
         B7MFnGLew785VfmgkvJ2I3svxS2xfi8uPoeI3323QBpt5vw3ZLuz2F3PxRisO75l8i
         JaNT//tJdfmgFeG4cEGKrUy+sDimkHQedVPW4mvo=
Date:   Tue, 3 Dec 2019 21:23:58 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     David Miller <davem@davemloft.net>
Cc:     edumazet@google.com, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, soheil@google.com, ncardwell@google.com,
        ycheng@google.com, willemb@google.com
Subject: Re: [PATCH net] tcp: refactor tcp_retransmit_timer()
Message-ID: <20191203202358.GB3183510@kroah.com>
References: <20191203160552.31071-1-edumazet@google.com>
 <20191203.115311.1412019727224973630.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191203.115311.1412019727224973630.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 03, 2019 at 11:53:11AM -0800, David Miller wrote:
> From: Eric Dumazet <edumazet@google.com>
> Date: Tue,  3 Dec 2019 08:05:52 -0800
> 
> > It appears linux-4.14 stable needs a backport of commit
> > 88f8598d0a30 ("tcp: exit if nothing to retransmit on RTO timeout")
> > 
> > Since tcp_rtx_queue_empty() is not in pre 4.15 kernels,
> > let's refactor tcp_retransmit_timer() to only use tcp_rtx_queue_head()
> > 
> > I will provide to stable teams the squashed patches.
> > 
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> 
> Applied, thanks Eric.

Applied where, do you have a 4.14-stable queue too?  :)

I can just take this directly to my 4.14.y tree now if you don't object.

thanks,

greg k-h
