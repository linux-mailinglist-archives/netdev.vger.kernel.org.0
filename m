Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 090C0338384
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 03:22:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231278AbhCLCWN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 21:22:13 -0500
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:52287 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230494AbhCLCWB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 21:22:01 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0URXf30A_1615515718;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0URXf30A_1615515718)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 12 Mar 2021 10:21:58 +0800
Date:   Fri, 12 Mar 2021 10:21:58 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     eric.dumazet@gmail.com, mingo@redhat.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] tracing: remove holes in events
Message-ID: <YErQRmAuRyVa0f2J@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <20210311094414.12774-1-tonylu@linux.alibaba.com>
 <20210311085619.3de5a62a@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210311085619.3de5a62a@gandalf.local.home>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 11, 2021 at 08:56:19AM -0500, Steven Rostedt wrote:
> On Thu, 11 Mar 2021 17:44:15 +0800
> Tony Lu <tonylu@linux.alibaba.com> wrote:
> 
> > ---
> >  include/trace/events/net.h    | 42 +++++++++++++++++------------------
> >  include/trace/events/qdisc.h  |  4 ++--
> >  include/trace/events/sunrpc.h |  4 ++--
> >  include/trace/events/tcp.h    |  2 +-
> >  4 files changed, 26 insertions(+), 26 deletions(-)
> 
> 
> If all the above are owned by networking, then this patch needs to go
> through the networking tree.

Thanks, I will resend it.


Cheers,
Tony Lu

> 
> -- Steve
