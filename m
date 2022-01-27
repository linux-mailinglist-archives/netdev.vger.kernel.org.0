Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4358249D918
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 04:19:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235666AbiA0DTS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 22:19:18 -0500
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:52547 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235576AbiA0DTQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 22:19:16 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V2yOM1Q_1643253553;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0V2yOM1Q_1643253553)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 27 Jan 2022 11:19:14 +0800
Date:   Thu, 27 Jan 2022 11:19:10 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     kgraul@linux.ibm.com, kuba@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] net/smc: Spread workload over multiple cores
Message-ID: <YfIPLn2AX774b6Wl@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <20220126130140.66316-1-tonylu@linux.alibaba.com>
 <20220126152916.GO8034@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220126152916.GO8034@ziepe.ca>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 26, 2022 at 11:29:16AM -0400, Jason Gunthorpe wrote:
> On Wed, Jan 26, 2022 at 09:01:39PM +0800, Tony Lu wrote:
> > Currently, SMC creates one CQ per IB device, and shares this cq among
> > all the QPs of links. Meanwhile, this CQ is always binded to the first
> > completion vector, the IRQ affinity of this vector binds to some CPU
> > core.
> 
> As we said in the RFC discussion this should be updated to use the
> proper core APIS, not re-implement them in a driver like this.

Thanks for your advice. As I replied in the RFC, I will start to do that
after a clear plan is determined.

Glad to hear your advice. 

Tony Lu
