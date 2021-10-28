Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D908343DB8F
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 08:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbhJ1Gyk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 02:54:40 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:44355 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229846AbhJ1Gyj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 02:54:39 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0Utz5DTP_1635403929;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0Utz5DTP_1635403929)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 28 Oct 2021 14:52:10 +0800
Date:   Thu, 28 Oct 2021 14:52:09 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     davem@davemloft.net, kuba@kernel.org, ubraun@linux.ibm.com,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org, jacob.qi@linux.alibaba.com,
        xuanzhuo@linux.alibaba.com, guwen@linux.alibaba.com,
        dust.li@linux.alibaba.com
Subject: Re: [PATCH net 2/4] net/smc: Fix smc_link->llc_testlink_time overflow
Message-ID: <YXpImWvmdMkK2wd0@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <20211027085208.16048-1-tonylu@linux.alibaba.com>
 <20211027085208.16048-3-tonylu@linux.alibaba.com>
 <c1d3d584-4a96-a34b-ed25-a376b17b36c7@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c1d3d584-4a96-a34b-ed25-a376b17b36c7@linux.ibm.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 27, 2021 at 12:24:18PM +0200, Karsten Graul wrote:
> On 27/10/2021 10:52, Tony Lu wrote:
> > From: Tony Lu <tony.ly@linux.alibaba.com>
> > 
> > The value of llc_testlink_time is set to the value stored in
> > net->ipv4.sysctl_tcp_keepalive_time when linkgroup init. The value of
> > sysctl_tcp_keepalive_time is already jiffies, so we don't need to
> > multiply by HZ, which would cause smc_link->llc_testlink_time overflow,
> > and test_link send flood.
> 
> Thanks for fixing this, we will include your patch in our next submission
> to the netdev tree.

Thanks for your reply. There is a little mistake for my email address,
the wrong email address (tony.ly@linux.alibaba.com) should be corrected
to tonylu@linux.alibaba.com. I will send these two patches with the next
one in v2.

Cheers,
Tony Lu
