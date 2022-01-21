Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2633F49586C
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 03:47:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378483AbiAUCrk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 21:47:40 -0500
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:45321 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348500AbiAUCri (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 21:47:38 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0V2PNhOp_1642733255;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0V2PNhOp_1642733255)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 21 Jan 2022 10:47:36 +0800
Date:   Fri, 21 Jan 2022 10:47:34 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Stefan Raspl <raspl@linux.ibm.com>
Cc:     Karsten Graul <kgraul@linux.ibm.com>,
        "D. Wythe" <alibuda@linux.alibaba.com>, dust.li@linux.alibaba.com,
        kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next v2] net/smc: Reduce overflow of smc clcsock
 listen queue
Message-ID: <YeoexsVAgklvdu+x@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <8a60dabb-1799-316c-80b5-14c920fe98ab@linux.ibm.com>
 <20220105044049.GA107642@e02h04389.eu6sqa>
 <20220105085748.GD31579@linux.alibaba.com>
 <b98aefce-e425-9501-aacc-8e5a4a12953e@linux.ibm.com>
 <20220105150612.GA75522@e02h04389.eu6sqa>
 <d35569df-e0e0-5ea7-9aeb-7ffaeef04b14@linux.ibm.com>
 <YdaUuOq+SkhYTWU8@TonyMac-Alibaba>
 <5a5ba1b6-93d7-5c1e-aab2-23a52727fbd1@linux.ibm.com>
 <YelmFWn7ot0iQCYG@TonyMac-Alibaba>
 <591d2e47-edd9-453a-a888-c43ba5b76a1e@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <591d2e47-edd9-453a-a888-c43ba5b76a1e@linux.ibm.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 20, 2022 at 05:00:18PM +0100, Stefan Raspl wrote:
> I'd be definitely open to look into patches for smc-tools that extend it to
> configure SMC properties, and that provide the capability to read (and
> apply) a config from a file! We can discuss what you'd imagine as an
> interface before you implement it, too.

Thanks for your reply. I will complete my detailed proposal, and send it
out later.
