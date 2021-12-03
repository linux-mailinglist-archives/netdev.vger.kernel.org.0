Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23D424670BD
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 04:31:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348147AbhLCDey (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 22:34:54 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:44820 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344703AbhLCDex (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 22:34:53 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0UzER9Kn_1638502288;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0UzER9Kn_1638502288)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 03 Dec 2021 11:31:28 +0800
Date:   Fri, 3 Dec 2021 11:31:23 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH net] net/smc: Clear memory when release and reuse buffer
Message-ID: <YamPi+seNs4yhlaV@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <20211125122858.90726-1-tonylu@linux.alibaba.com>
 <20211126112855.37274cb7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YaWR6zXoYKrqtznt@TonyMac-Alibaba>
 <a98a49d9-a7e9-4dbc-8e3d-8ff4d917546b@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a98a49d9-a7e9-4dbc-8e3d-8ff4d917546b@linux.ibm.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 02, 2021 at 03:23:07PM +0100, Karsten Graul wrote:
> On 30/11/2021 03:52, Tony Lu wrote:
> > Sorry for the unclear tag. This patch introduces a performance
> > improvement. It should be with net-next.
> > 
> > I will fix it and send v2. Thank you.
> 
> Will you now send a v2 to net-next, or should I pick your v1 and 
> submit it via our tree?

Sorry about my unclear reply in the previous mail. It's nice to pick v1
to your tree. If v2 is needed, I will send it out soon. Thank you.

Thanks,
Tony Lu
