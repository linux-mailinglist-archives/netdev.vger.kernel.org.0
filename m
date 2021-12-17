Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7D374784EE
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 07:32:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232146AbhLQGcx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 01:32:53 -0500
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:44040 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232073AbhLQGcw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 01:32:52 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0V-tDLVp_1639722770;
Received: from localhost(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0V-tDLVp_1639722770)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 17 Dec 2021 14:32:50 +0800
Date:   Fri, 17 Dec 2021 14:32:50 +0800
From:   "D. Wythe" <alibuda@linux.alibaba.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Karsten Graul <kgraul@linux.ibm.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH net] net/smc: Prevent smc_release() from long blocking
Message-ID: <20211217063249.GA116421@e02h04389.eu6sqa>
Reply-To: "D. Wythe" <alibuda@linux.alibaba.com>
References: <1639571361-101128-1-git-send-email-alibuda@linux.alibaba.com>
 <2c8f208f-9b14-1c79-ae6a-0ef64010b70a@linux.ibm.com>
 <20211216081331.4983d048@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211216081331.4983d048@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Sorry for this mistake, I'll pay more attention next time.

Thanks.

On Thu, Dec 16, 2021 at 08:13:31AM -0800, Jakub Kicinski wrote:
> On Thu, 16 Dec 2021 11:08:13 +0100 Karsten Graul wrote:
> > On 15/12/2021 13:29, D. Wythe wrote:
> > > From: "D. Wythe" <alibuda@linux.alibaba.com>
> > > 
> > > In nginx/wrk benchmark, there's a hung problem with high probability
> > > on case likes that: (client will last several minutes to exit)
> > > 
> > > server: smc_run nginx
> > > 
> > > client: smc_run wrk -c 10000 -t 1 http://server
> > > 
> > > Client hangs with the following backtrace:  
> 
> In the future please make sure to leave the commit title in the Fixes
> tag exactly as is (you seem to have removed a "net/" prefix).
> 
> > Good finding, thank you!
> > 
> > Acked-by: Karsten Graul <kgraul@linux.ibm.com>
> 
> Applied, thanks.
