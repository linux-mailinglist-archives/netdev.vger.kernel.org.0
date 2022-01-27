Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50C8F49DC30
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 09:05:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237639AbiA0IFY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 03:05:24 -0500
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:36929 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237624AbiA0IFY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 03:05:24 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R221e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0V2zNhQM_1643270721;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0V2zNhQM_1643270721)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 27 Jan 2022 16:05:21 +0800
Date:   Thu, 27 Jan 2022 16:05:20 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, kgraul@linux.ibm.com,
        kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] net/smc: Spread workload over multiple cores
Message-ID: <YfJSQKnREYkia1R0@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <20220126130140.66316-1-tonylu@linux.alibaba.com>
 <20220126152916.GO8034@ziepe.ca>
 <YfIPLn2AX774b6Wl@TonyMac-Alibaba>
 <YfI5SE4P+NPZVkaE@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YfI5SE4P+NPZVkaE@unreal>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 27, 2022 at 08:18:48AM +0200, Leon Romanovsky wrote:
> On Thu, Jan 27, 2022 at 11:19:10AM +0800, Tony Lu wrote:
> > On Wed, Jan 26, 2022 at 11:29:16AM -0400, Jason Gunthorpe wrote:
> > > On Wed, Jan 26, 2022 at 09:01:39PM +0800, Tony Lu wrote:
> > > > Currently, SMC creates one CQ per IB device, and shares this cq among
> > > > all the QPs of links. Meanwhile, this CQ is always binded to the first
> > > > completion vector, the IRQ affinity of this vector binds to some CPU
> > > > core.
> > > 
> > > As we said in the RFC discussion this should be updated to use the
> > > proper core APIS, not re-implement them in a driver like this.
> > 
> > Thanks for your advice. As I replied in the RFC, I will start to do that
> > after a clear plan is determined.
> > 
> > Glad to hear your advice. 
> 
> Please do right thing from the beginning.
> 
> You are improving code from 2017 to be aligned with core code that
> exists from 2020.

Thanks for your reply. The implement of this patch set isn't a brand-new
feature, just existed codes and logics adjustment and recombination,
aims to solve an existed issue in real world. So I fixes it now.

The other thing is to align code to now with new API. I will do it
before a full discussion with Karsten.

Thank you,
Tony Lu
