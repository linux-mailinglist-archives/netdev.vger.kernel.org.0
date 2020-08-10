Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69D37240505
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 13:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbgHJLE1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 07:04:27 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:37782 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726146AbgHJLE1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Aug 2020 07:04:27 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 5BA3A2056D;
        Mon, 10 Aug 2020 13:04:25 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id iFtfZQW-AYnX; Mon, 10 Aug 2020 13:04:24 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id E95C7200AA;
        Mon, 10 Aug 2020 13:04:24 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Mon, 10 Aug 2020 13:04:24 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Mon, 10 Aug
 2020 13:04:24 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id ECB90318028B;
 Mon, 10 Aug 2020 13:04:23 +0200 (CEST)
Date:   Mon, 10 Aug 2020 13:04:23 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     YueHaibing <yuehaibing@huawei.com>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <kuznet@ms2.inr.ac.ru>, <yoshfuji@linux-ipv6.org>,
        <kuba@kernel.org>, <lucien.xin@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] ip_vti: Fix unused variable warning
Message-ID: <20200810110423.GO13121@gauss3.secunet.de>
References: <20200731064952.36900-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200731064952.36900-1-yuehaibing@huawei.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 31, 2020 at 02:49:52PM +0800, YueHaibing wrote:
> If CONFIG_INET_XFRM_TUNNEL is set but CONFIG_IPV6 is n,
> 
> net/ipv4/ip_vti.c:493:27: warning: 'vti_ipip6_handler' defined but not used [-Wunused-variable]
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Now applied to the ipsec tree, thanks!
