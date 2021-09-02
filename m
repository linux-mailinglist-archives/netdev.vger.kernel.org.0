Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60DD33FEEBF
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 15:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234646AbhIBNgw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 09:36:52 -0400
Received: from mx20.baidu.com ([111.202.115.85]:53226 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234350AbhIBNgu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Sep 2021 09:36:50 -0400
Received: from Bc-Mail-Ex13.internal.baidu.com (unknown [172.31.51.53])
        by Forcepoint Email with ESMTPS id 7AFDD116EDC554C40873;
        Thu,  2 Sep 2021 21:35:30 +0800 (CST)
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
 Bc-Mail-Ex13.internal.baidu.com (172.31.51.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2242.12; Thu, 2 Sep 2021 21:35:30 +0800
Received: from localhost (172.31.63.8) by BJHW-MAIL-EX27.internal.baidu.com
 (10.127.64.42) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Thu, 2
 Sep 2021 21:35:30 +0800
Date:   Thu, 2 Sep 2021 21:35:29 +0800
From:   Cai Huoqing <caihuoqing@baidu.com>
To:     Steve Grubb <sgrubb@redhat.com>
CC:     <linux-audit@redhat.com>,
        strace development discussions <strace-devel@lists.strace.io>,
        <linux-api@vger.kernel.org>, <davem@davemloft.net>,
        <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>, <kuba@kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <ldv@strace.io>
Subject: Re: [PATCH 1/2] net: Remove net/ipx.h and uapi/linux/ipx.h header
 files
Message-ID: <20210902133529.GA32500@LAPTOP-UKSR4ENP.internal.baidu.com>
Reply-To: q@vger.kernel.org
References: <20210813120803.101-1-caihuoqing@baidu.com>
 <20210901160244.GA5957@asgard.redhat.com>
 <20210901165202.GA4518@asgard.redhat.com>
 <1797920.tdWV9SEqCh@x2>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1797920.tdWV9SEqCh@x2>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: BJHW-Mail-Ex16.internal.baidu.com (10.127.64.39) To
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01 Sep 21 13:36:54, Steve Grubb wrote:
> Hello,
> 
> Thanks for the heads up.
> 
> On Wednesday, September 1, 2021 12:52:02 PM EDT Eugene Syromiatnikov wrote:
> > Adding linux-audit, strace-devel, and linux-api to CC:.
> > 
> > On Wed, Sep 01, 2021 at 06:02:44PM +0200, Eugene Syromiatnikov wrote:
> > > On Fri, Aug 13, 2021 at 08:08:02PM +0800, Cai Huoqing wrote:
> > > > commit <47595e32869f> ("<MAINTAINERS: Mark some staging directories>")
> > > > indicated the ipx network layer as obsolete in Jan 2018,
> > > > updated in the MAINTAINERS file
> > > > 
> > > > now, after being exposed for 3 years to refactoring, so to
> > > > delete uapi/linux/ipx.h and net/ipx.h header files for good.
> > > > additionally, there is no module that depends on ipx.h except
> > > > a broken staging driver(r8188eu)
> > > > 
> > > > Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
> > > 
> > > This removal breaks audit[1] and potentially breaks strace[2][3], at
> > > least.
> 
> I wouldn't say breaks so much as needs coordination with. :-)   If ipx is 
> being dropped in its entirety, I can just make that part of the code 
> conditional to the header existing.
> 
> -Steve
IPX is marked obsolete for serveral years. so remove it and the
dependency in linux tree.
I'm sorry to not thinking about linux-audit and strace.
Might you remove the dependency or make the part of the code.
Many thanks.

-Cai
> 
> > > [1]
> > > https://github.com/linux-audit/audit-userspace/blob/ce58837d44b7d9fcb4e1
> > > 40c23f68e0c94d95ab6e/auparse/interpret.c#L48 [2]
> > > https://gitlab.com/strace/strace/-/blob/9fe63f42df8badd22fb7eef9c12fc07e
> > > d7106d6b/src/net.c#L34 [3]
> > > https://gitlab.com/strace/strace/-/blob/9fe63f42df8badd22fb7eef9c12fc07e
> > > d7106d6b/src/sockaddr.c#L30
> 
> 
> 
> 
