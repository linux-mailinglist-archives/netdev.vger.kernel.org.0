Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 805E557FEE7
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 14:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234750AbiGYMXK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 08:23:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232415AbiGYMXJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 08:23:09 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACFA7167FA
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 05:23:07 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id DB8FD2050A;
        Mon, 25 Jul 2022 14:23:04 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id mvHdS4nP9LoN; Mon, 25 Jul 2022 14:23:03 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 6C4112052E;
        Mon, 25 Jul 2022 14:23:03 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 62EB280004A;
        Mon, 25 Jul 2022 14:23:03 +0200 (CEST)
Received: from mbx-essen-02.secunet.de (10.53.40.198) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 25 Jul 2022 14:23:03 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-02.secunet.de
 (10.53.40.198) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Mon, 25 Jul
 2022 14:23:02 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id A3BB83182FB8; Mon, 25 Jul 2022 14:23:02 +0200 (CEST)
Date:   Mon, 25 Jul 2022 14:23:02 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>, <netdev@vger.kernel.org>
Subject: Re: [PATCH 0/5] pull request (net-next): ipsec-next 2022-07-20
Message-ID: <20220725122302.GI678471@gauss3.secunet.de>
References: <20220720081746.1187382-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220720081746.1187382-1-steffen.klassert@secunet.com>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-02.secunet.de (10.53.40.198)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 20, 2022 at 10:17:41AM +0200, Steffen Klassert wrote:
> 1) Don't set DST_NOPOLICY in IPv4, a recent patch made this
>    superfluous. From Eyal Birger.
> 
> 2) Convert alg_key to flexible array member to avoid an iproute2
>    compile warning when built with gcc-12.
>    From Stephen Hemminger.
> 
> 3) xfrm_register_km and xfrm_unregister_km do always return 0
>    so change the type to void. From Zhengchao Shao.
> 
> 4) Fix spelling mistake in esp6.c
>    From Zhang Jiaming.
> 
> 5) Improve the wording of comment above XFRM_OFFLOAD flags.
>    From Petr Vaněk.
> 
> Please pull or let me know if there are problems.

Can anyone reconsider this pull request?

It is marked as Accepted in patchwork, but seems not to be included
in net-next.

Thanks!

