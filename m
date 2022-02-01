Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB9F74A5766
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 07:58:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232657AbiBAG6k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 01:58:40 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:37438 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231231AbiBAG6j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Feb 2022 01:58:39 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id BB63F20536;
        Tue,  1 Feb 2022 07:58:37 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id S05fe4wkJHs4; Tue,  1 Feb 2022 07:58:37 +0100 (CET)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 4A214201D3;
        Tue,  1 Feb 2022 07:58:37 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 445F080004A;
        Tue,  1 Feb 2022 07:58:37 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 1 Feb 2022 07:58:37 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Tue, 1 Feb
 2022 07:58:36 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 6B1B6318303F; Tue,  1 Feb 2022 07:58:36 +0100 (CET)
Date:   Tue, 1 Feb 2022 07:58:36 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Leon Romanovsky <leonro@nvidia.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH ipsec-next] xfrm: delete not-used XFRM_OFFLOAD_IPV6 define
Message-ID: <20220201065836.GT1223722@gauss3.secunet.de>
References: <31811e3cf276ae2af01574f4fbcb127b88d9c6b5.1643307803.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <31811e3cf276ae2af01574f4fbcb127b88d9c6b5.1643307803.git.leonro@nvidia.com>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 27, 2022 at 08:24:58PM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> XFRM_OFFLOAD_IPV6 define was exposed in the commit mentioned in the
> fixes line, but it is never been used both in the kernel and in the
> user space. So delete it.

How can you be sure that is is not used in userspace? At least some
versions of strongswan set that flag. So even if it is meaningless
in the kernel, we can't remove it.

> 
> Fixes: d77e38e612a0 ("xfrm: Add an IPsec hardware offloading API")
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  include/uapi/linux/xfrm.h | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/include/uapi/linux/xfrm.h b/include/uapi/linux/xfrm.h
> index 4e29d7851890..2c822671cc32 100644
> --- a/include/uapi/linux/xfrm.h
> +++ b/include/uapi/linux/xfrm.h
> @@ -511,7 +511,6 @@ struct xfrm_user_offload {
>  	int				ifindex;
>  	__u8				flags;
>  };
> -#define XFRM_OFFLOAD_IPV6	1
>  #define XFRM_OFFLOAD_INBOUND	2
>  
>  struct xfrm_userpolicy_default {
> -- 
> 2.34.1
