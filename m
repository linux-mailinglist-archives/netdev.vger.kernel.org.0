Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 053AC5A8E2C
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 08:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231898AbiIAGRD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 02:17:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233297AbiIAGRB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 02:17:01 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F25D1195D7
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 23:17:00 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 2ED25205B4;
        Thu,  1 Sep 2022 08:16:58 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id cb08Xu9zlYBp; Thu,  1 Sep 2022 08:16:57 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id B1254205A4;
        Thu,  1 Sep 2022 08:16:57 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id A300980004A;
        Thu,  1 Sep 2022 08:16:57 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 1 Sep 2022 08:16:57 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 1 Sep
 2022 08:16:57 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 0FD263182A9E; Thu,  1 Sep 2022 08:16:57 +0200 (CEST)
Date:   Thu, 1 Sep 2022 08:16:56 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Sabrina Dubroca <sd@queasysnail.net>
CC:     <netdev@vger.kernel.org>
Subject: Re: [PATCH ipsec-next 0/6] xfrm: start adding netlink extack support
Message-ID: <20220901061656.GR566407@gauss3.secunet.de>
References: <cover.1661162395.git.sd@queasysnail.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1661162395.git.sd@queasysnail.net>
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

On Tue, Aug 30, 2022 at 04:23:06PM +0200, Sabrina Dubroca wrote:
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
>   xfrm: add extack to verify_policy_type
>   xfrm: add extack to validate_tmpl
>   xfrm: add extack to verify_sec_ctx_len

Series applied, thanks a lot Sabrina!
