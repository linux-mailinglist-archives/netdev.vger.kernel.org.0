Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED1A5639561
	for <lists+netdev@lfdr.de>; Sat, 26 Nov 2022 11:35:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbiKZKf5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Nov 2022 05:35:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiKZKf4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Nov 2022 05:35:56 -0500
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA20B26AE6
        for <netdev@vger.kernel.org>; Sat, 26 Nov 2022 02:35:54 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 379392049B;
        Sat, 26 Nov 2022 11:35:52 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 9EIzgpKHwdCT; Sat, 26 Nov 2022 11:35:51 +0100 (CET)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id B234D20422;
        Sat, 26 Nov 2022 11:35:51 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id A7A4580004A;
        Sat, 26 Nov 2022 11:35:51 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 26 Nov 2022 11:35:51 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sat, 26 Nov
 2022 11:35:51 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id C73333183C31; Sat, 26 Nov 2022 11:35:50 +0100 (CET)
Date:   Sat, 26 Nov 2022 11:35:50 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Sabrina Dubroca <sd@queasysnail.net>
CC:     <netdev@vger.kernel.org>
Subject: Re: [PATCH ipsec-next 0/7] xfrm: add extack support to some more
 message types
Message-ID: <20221126103550.GO665047@gauss3.secunet.de>
References: <cover.1668507420.git.sd@queasysnail.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1668507420.git.sd@queasysnail.net>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 24, 2022 at 03:43:37PM +0100, Sabrina Dubroca wrote:
> This is the last part of my extack work for xfrm, adding extack
> messages to the last remaining operations: NEWSPDINFO, ALLOCSPI,
> MIGRATE, NEWAE, DELSA, EXPIRE.
> 
> The first patch does a few clean ups on code that will be changed
> later on it the series.
> 
> Sabrina Dubroca (7):
>   xfrm: a few coding style clean ups
>   xfrm: add extack to xfrm_add_sa_expire
>   xfrm: add extack to xfrm_del_sa
>   xfrm: add extack to xfrm_new_ae and xfrm_replay_verify_len
>   xfrm: add extack to xfrm_do_migrate
>   xfrm: add extack to xfrm_alloc_userspi
>   xfrm: add extack to xfrm_set_spdinfo

Series applied, thanks Sabrina!
