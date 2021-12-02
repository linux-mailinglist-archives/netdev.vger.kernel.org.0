Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E45894664E9
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 15:08:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358402AbhLBOLy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 09:11:54 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:57052 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1358401AbhLBOLx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Dec 2021 09:11:53 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id B604E20265;
        Thu,  2 Dec 2021 15:08:29 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id KK7yFgNVPXrX; Thu,  2 Dec 2021 15:08:29 +0100 (CET)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 1A9B72006F;
        Thu,  2 Dec 2021 15:08:29 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 0818480004A;
        Thu,  2 Dec 2021 15:08:29 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 2 Dec 2021 15:08:28 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.14; Thu, 2 Dec
 2021 15:08:28 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id AA0E33183D5D; Thu,  2 Dec 2021 15:08:27 +0100 (CET)
Date:   Thu, 2 Dec 2021 15:08:27 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Sabrina Dubroca <sd@queasysnail.net>
CC:     <netdev@vger.kernel.org>
Subject: Re: [RFC PATCH ipsec-next 0/6] xfrm: start adding netlink extack
 support
Message-ID: <20211202140827.GS427717@gauss3.secunet.de>
References: <cover.1636450303.git.sd@queasysnail.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1636450303.git.sd@queasysnail.net>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 11, 2021 at 01:02:41PM +0100, Sabrina Dubroca wrote:
> XFRM states and policies are complex objects, and there are many
> reasons why the kernel can reject userspace's request to create
> one. This series makes it a bit clearer by providing extended ack
> messages for policy creation.
> 
> A few other operations that reuse the same helper functions are also
> getting partial extack support in this series. More patches will
> follow to complete extack support, in particular for state creation.
> 
> Note: The policy->share attribute seems to be entirely ignored in the
> kernel outside of checking its value in verify_newpolicy_info(). There
> are some (very) old comments in copy_from_user_policy and
> copy_to_user_policy suggesting that it should at least be copied
> to/from userspace. I don't know what it was intended for.
> 
> Sabrina Dubroca (6):
>   xfrm: propagate extack to all netlink doit handlers
>   xfrm: add extack support to verify_newpolicy_info
>   xfrm: add extack to verify_policy_dir
>   xfrm: add extack to validate_tmpl
>   xfrm: add extack to verify_policy_type
>   xfrm: add extack to verify_sec_ctx_len
> 
>  net/xfrm/xfrm_user.c | 163 +++++++++++++++++++++++++++----------------
>  1 file changed, 103 insertions(+), 60 deletions(-)

Looks good to me, thanks!
