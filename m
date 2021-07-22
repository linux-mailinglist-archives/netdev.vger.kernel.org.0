Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CA643D2119
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 11:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231255AbhGVJCx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 05:02:53 -0400
Received: from mailout2.secunet.com ([62.96.220.49]:45040 "EHLO
        mailout2.secunet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230232AbhGVJCv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 05:02:51 -0400
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id CB04580005B;
        Thu, 22 Jul 2021 11:43:25 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 22 Jul 2021 11:43:25 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Thu, 22 Jul
 2021 11:43:25 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 04C893180B27; Thu, 22 Jul 2021 11:43:25 +0200 (CEST)
Date:   Thu, 22 Jul 2021 11:43:24 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Antony Antony <antony.antony@secunet.com>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Christian Langrock <christian.langrock@secunet.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 ipsec-next] xfrm: Add possibility to set the default
 to block if we have no policy
Message-ID: <20210722094324.GC893739@gauss3.secunet.de>
References: <20210331144843.GA25749@moon.secunet.de>
 <fc1364604051d6be5c4c14817817a004aba539eb.1626592022.git.antony.antony@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <fc1364604051d6be5c4c14817817a004aba539eb.1626592022.git.antony.antony@secunet.com>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 18, 2021 at 09:11:06AM +0200, Antony Antony wrote:
> From: Steffen Klassert <steffen.klassert@secunet.com>
> 
> As the default we assume the traffic to pass, if we have no
> matching IPsec policy. With this patch, we have a possibility to
> change this default from allow to block. It can be configured
> via netlink. Each direction (input/output/forward) can be
> configured separately. With the default to block configuered,
> we need allow policies for all packet flows we accept.
> We do not use default policy lookup for the loopback device.
> 
> v1->v2
>  - fix compiling when XFRM is disabled
>  - Reported-by: kernel test robot <lkp@intel.com>
> 
> Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
> Co-developed-by: Christian Langrock <christian.langrock@secunet.com>
> Signed-off-by: Christian Langrock <christian.langrock@secunet.com>
> Co-developed-by: Antony Antony <antony.antony@secunet.com>
> Signed-off-by: Antony Antony <antony.antony@secunet.com>

Applied, thanks for pushing this upstream Antony!
