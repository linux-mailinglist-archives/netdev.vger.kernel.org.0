Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7FA343DB95
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 08:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbhJ1Gzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 02:55:44 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:40789 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229671AbhJ1Gzo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 02:55:44 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0Utz2BJI_1635403995;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0Utz2BJI_1635403995)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 28 Oct 2021 14:53:15 +0800
Date:   Thu, 28 Oct 2021 14:53:15 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        jacob.qi@linux.alibaba.com, xuanzhuo@linux.alibaba.com,
        guwen@linux.alibaba.com, dust.li@linux.alibaba.com
Subject: Re: [PATCH net 3/4] net/smc: Correct spelling mistake to
 TCPF_SYN_RECV
Message-ID: <YXpI231vPrDIK/Gm@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <20211027085208.16048-1-tonylu@linux.alibaba.com>
 <20211027085208.16048-4-tonylu@linux.alibaba.com>
 <64ccbcfb-f360-ed6f-3f64-e4c2fadf91d2@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64ccbcfb-f360-ed6f-3f64-e4c2fadf91d2@linux.ibm.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 27, 2021 at 12:23:34PM +0200, Karsten Graul wrote:
> On 27/10/2021 10:52, Tony Lu wrote:
> > From: Wen Gu <guwen@linux.alibaba.com>
> > 
> > There should use TCPF_SYN_RECV instead of TCP_SYN_RECV.
> 
> Thanks for fixing this, we will include your patch in our next submission
> to the netdev tree.

I will resend it in v2 patch to fix my wrong email address
(tony.ly@linux.alibaba.com) to tonylu@linux.alibaba.com.

Cheers,
Tony Lu
