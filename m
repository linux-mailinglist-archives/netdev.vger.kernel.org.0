Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54CA556D76C
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 10:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbiGKIKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 04:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiGKIKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 04:10:21 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D27F1BEB6;
        Mon, 11 Jul 2022 01:10:21 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id D89C1201E5;
        Mon, 11 Jul 2022 10:10:19 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id EWYLcTSgrQeG; Mon, 11 Jul 2022 10:10:09 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 2B839201A1;
        Mon, 11 Jul 2022 10:10:08 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 2036E80004A;
        Mon, 11 Jul 2022 10:10:08 +0200 (CEST)
Received: from mbx-dresden-01.secunet.de (10.53.40.199) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 11 Jul 2022 10:10:07 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-dresden-01.secunet.de
 (10.53.40.199) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Mon, 11 Jul
 2022 10:10:07 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id D6E3F3182E41; Mon, 11 Jul 2022 10:10:06 +0200 (CEST)
Date:   Mon, 11 Jul 2022 10:10:06 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Petr =?utf-8?B?VmFuxJtr?= <arkamar@atlas.cz>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] xfrm: improve wording of comment above XFRM_OFFLOAD flags
Message-ID: <20220711081006.GL566407@gauss3.secunet.de>
References: <20220630142720.19137-1-arkamar@atlas.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220630142720.19137-1-arkamar@atlas.cz>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-dresden-01.secunet.de (10.53.40.199)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 30, 2022 at 04:27:20PM +0200, Petr Vaněk wrote:
> I have noticed a few minor wording issues in a comment recently added
> above XFRM_OFFLOAD flags in 7c76ecd9c99b ("xfrm: enforce validity of
> offload input flags").
> 
> Signed-off-by: Petr Vaněk <arkamar@atlas.cz>

Applied to ipsec-next, thanks!
