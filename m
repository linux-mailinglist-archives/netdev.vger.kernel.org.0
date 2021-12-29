Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED9F0481193
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 11:18:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239694AbhL2KSS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 05:18:18 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:51218 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235445AbhL2KSR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Dec 2021 05:18:17 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id E7123205A4;
        Wed, 29 Dec 2021 11:18:15 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Qm-DTGhXXo2j; Wed, 29 Dec 2021 11:18:15 +0100 (CET)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 77A94205E3;
        Wed, 29 Dec 2021 11:18:15 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 71DF180004A;
        Wed, 29 Dec 2021 11:18:15 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 29 Dec 2021 11:18:15 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Wed, 29 Dec
 2021 11:18:15 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id DD9C03182F8D; Wed, 29 Dec 2021 11:18:12 +0100 (CET)
Date:   Wed, 29 Dec 2021 11:18:12 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Xu Jia <xujia39@huawei.com>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <kuba@kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 0/2] xfrm: Add support for SM3 and SM4
Message-ID: <20211229101812.GP3272477@gauss3.secunet.de>
References: <1640164019-42341-1-git-send-email-xujia39@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1640164019-42341-1-git-send-email-xujia39@huawei.com>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 22, 2021 at 05:06:57PM +0800, Xu Jia wrote:
> These patches add xfrm support for SM3 and SM4 algorithms which are
> cryptographic standards published by China State Cryptography 
> Administration.
> 
> SM3 secure hash (OSCCA GM/T 0004-2012 SM3) is based on Merkle-Damgard 
> with a thuncation of 256 bits. It could be used for authentication 
> and random number generation.
> 
> SM4 symmetric ciper algorithm (OSCCA GB/T 32097-2016) has at least 128
> bits packet length which is similar to AES ciper algorithm. It is 
> suitable for the use of block ciphers in cryptographic applications.
> 
> As SM3 and SM4 have already been supported by Linux kernel,
> after these patches, we can use them with "ip xfrm" tools easily.
> 
> 
> Xu Jia (2):
>   xfrm: Add support for SM3 secure hash
>   xfrm: Add support for SM4 symmetric cipher algorithm
> 
>  include/uapi/linux/pfkeyv2.h |  2 ++
>  net/xfrm/xfrm_algo.c         | 41 +++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 43 insertions(+)

Series applied to ipsec-next, thanks a lot!
