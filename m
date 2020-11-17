Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9D6D2B5EDF
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 13:11:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728222AbgKQMJC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 07:09:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:37590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725446AbgKQMJB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 07:09:01 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 37C632223C;
        Tue, 17 Nov 2020 12:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605614941;
        bh=u0txQvZKgwUDR0paMwBrrjn1YIL2hMbwIWCn1eLaN/I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vyMk5vYvqIfUwIYaYa3xmdLwAAAWO2zG+a+vxvyk3wAWHpUWbeg7dJmMH2bHxZPru
         NbOomYqBm1WJM6BlG2Bo3ZufuHdv8b6Y8QzSZY8imqeNdWPqcU8bYOWOoP4hpImsS9
         vEeEYwSUbQCVDAXO9cHG7hFYJRd+pOlZIs8Uhujs=
Date:   Tue, 17 Nov 2020 13:09:49 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     stable@vger.kernel.org, vpai@akamai.com,
        Joakim.Tjernlund@infinera.com, xiyou.wangcong@gmail.com,
        johunt@akamai.com, jhs@mojatatu.com, jiri@resnulli.us,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@huawei.com,
        john.fastabend@gmail.com, eric.dumazet@gmail.com, dsahern@gmail.com
Subject: Re: [PATCH stable] net: sch_generic: fix the missing new qdisc
 assignment bug
Message-ID: <X7O9jdlTgs7IbSGT@kroah.com>
References: <1604373938-211588-1-git-send-email-linyunsheng@huawei.com>
 <20201109124658.GC1834954@kroah.com>
 <3deb16a8-bdb1-3c31-2722-404f271f41d8@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3deb16a8-bdb1-3c31-2722-404f271f41d8@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 10, 2020 at 08:58:17AM +0800, Yunsheng Lin wrote:
> On 2020/11/9 20:46, Greg KH wrote:
> > On Tue, Nov 03, 2020 at 11:25:38AM +0800, Yunsheng Lin wrote:
> >> commit 2fb541c862c9 ("net: sch_generic: aviod concurrent reset and enqueue op for lockless qdisc")
> >>
> >> When the above upstream commit is backported to stable kernel,
> >> one assignment is missing, which causes two problems reported
> >> by Joakim and Vishwanath, see [1] and [2].
> >>
> >> So add the assignment back to fix it.
> >>
> >> 1. https://www.spinics.net/lists/netdev/msg693916.html
> >> 2. https://www.spinics.net/lists/netdev/msg695131.html
> >>
> >> Fixes: 749cc0b0c7f3 ("net: sch_generic: aviod concurrent reset and enqueue op for lockless qdisc")
> >> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> >> ---
> >>  net/sched/sch_generic.c | 3 +++
> >>  1 file changed, 3 insertions(+)
> > 
> > What kernel tree(s) does this need to be backported to?
> 
> 4.19.x and 5.4.x

Now queued up, thanks.

greg k-h
