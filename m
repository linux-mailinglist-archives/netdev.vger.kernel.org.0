Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2813823B49D
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 07:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729813AbgHDFxP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 01:53:15 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:46504 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726398AbgHDFxP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Aug 2020 01:53:15 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 3BF3C20569;
        Tue,  4 Aug 2020 07:53:13 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id wUQIudoOJEBl; Tue,  4 Aug 2020 07:53:11 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 655A3201D5;
        Tue,  4 Aug 2020 07:53:11 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Tue, 4 Aug 2020 07:53:11 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Tue, 4 Aug 2020
 07:53:10 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 7E20831803A0;
 Tue,  4 Aug 2020 07:53:10 +0200 (CEST)
Date:   Tue, 4 Aug 2020 07:53:10 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     <yuehaibing@huawei.com>, <herbert@gondor.apana.org.au>,
        <kuznet@ms2.inr.ac.ru>, <yoshfuji@linux-ipv6.org>,
        <kuba@kernel.org>, <lucien.xin@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] ip_vti: Fix unused variable warning
Message-ID: <20200804055310.GK20687@gauss3.secunet.de>
References: <20200731064952.36900-1-yuehaibing@huawei.com>
 <20200803.151349.926022361234213749.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200803.151349.926022361234213749.davem@davemloft.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 03, 2020 at 03:13:49PM -0700, David Miller wrote:
> From: YueHaibing <yuehaibing@huawei.com>
> Date: Fri, 31 Jul 2020 14:49:52 +0800
> 
> > If CONFIG_INET_XFRM_TUNNEL is set but CONFIG_IPV6 is n,
> > 
> > net/ipv4/ip_vti.c:493:27: warning: 'vti_ipip6_handler' defined but not used [-Wunused-variable]
> > 
> > Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> 
> Steffen, please pick this up if you haven't already.

I still have this one in my queue, it came in after
I did the the ipsec-next pull request last week.
Now the 5.8 release was inbetween, so it should go
to the ipsec tree. I'm waiting until I can backmerge
the offending patch into the ipsec tree and apply it
then.

Alternatively to speed things up, you can take it
directly into net-next before you do the pull request
to Linus. In case you prefer that:

Acked-by: Steffen Klassert <steffen.klassert@secunet.com>
