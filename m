Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E28364B07B7
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 09:06:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236925AbiBJIFk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 03:05:40 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236922AbiBJIFh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 03:05:37 -0500
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB47A1089
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 00:05:39 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id E115C20491;
        Thu, 10 Feb 2022 09:05:37 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id pyxUBGio9QcI; Thu, 10 Feb 2022 09:05:37 +0100 (CET)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 50092201A1;
        Thu, 10 Feb 2022 09:05:37 +0100 (CET)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout1.secunet.com (Postfix) with ESMTP id 45DD880004A;
        Thu, 10 Feb 2022 09:05:37 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 10 Feb 2022 09:05:37 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Thu, 10 Feb
 2022 09:05:36 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 95178318038D; Thu, 10 Feb 2022 09:05:36 +0100 (CET)
Date:   Thu, 10 Feb 2022 09:05:36 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Leon Romanovsky <leonro@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH ipsec-rc] xfrm: enforce validity of offload input flags
Message-ID: <20220210080536.GC1223722@gauss3.secunet.de>
References: <8e526e4814f0c4da5a965567d3b8dce3a9ac2470.1644329331.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <8e526e4814f0c4da5a965567d3b8dce3a9ac2470.1644329331.git.leonro@nvidia.com>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 08, 2022 at 04:14:32PM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> struct xfrm_user_offload has flags variable that received user input,
> but kernel didn't check if valid bits were provided. It caused a situation
> where not sanitized input was forwarded directly to the drivers.
> 
> For example, XFRM_OFFLOAD_IPV6 define that was exposed, was used by
> strongswan, but not implemented in the kernel at all.
> 
> As a solution, check and sanitize input flags to forward
> XFRM_OFFLOAD_INBOUND to the drivers.
> 
> Fixes: d77e38e612a0 ("xfrm: Add an IPsec hardware offloading API")
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Applied, thanks Leon!
