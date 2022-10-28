Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 275B7610FD1
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 13:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbiJ1Lfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 07:35:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbiJ1Lff (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 07:35:35 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E81E147D12
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 04:35:34 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id DB01F20573;
        Fri, 28 Oct 2022 13:35:32 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id M-MGKLpdnr_e; Fri, 28 Oct 2022 13:35:32 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 6FDCF204E0;
        Fri, 28 Oct 2022 13:35:32 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 6744D80004A;
        Fri, 28 Oct 2022 13:35:32 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 28 Oct 2022 13:35:32 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 28 Oct
 2022 13:35:32 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id C9CE73182D7B; Fri, 28 Oct 2022 13:35:31 +0200 (CEST)
Date:   Fri, 28 Oct 2022 13:35:31 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Antony Antony <antony.antony@secunet.com>
CC:     Herbert Xu <herbert@gondor.apana.org.au>, <netdev@vger.kernel.org>,
        "Tobias Brunner" <tobias@strongswan.org>,
        Antony Antony <antony@phenome.org>
Subject: Re: [PATCH ipsec-next v2] xfrm: update x->lastused for every packet
Message-ID: <20221028113531.GL2602992@gauss3.secunet.de>
References: <3e201e1156639286e1874ebc29233741b8b2ac54.1657260947.git.antony.antony@secunet.com>
 <1c3bdbd480bd3018175525a23ba623911fec74e1.1666359531.git.antony.antony@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1c3bdbd480bd3018175525a23ba623911fec74e1.1666359531.git.antony.antony@secunet.com>
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

On Fri, Oct 21, 2022 at 03:42:01PM +0200, Antony Antony wrote:
> x->lastused was only updated for outgoing mobile IPv6 packet.
> With this fix update it for every, in and out, packet.
> 
> This is useful to check if the a SA is still in use, or when was
> the last time an SA was used. lastused time of in SA can used
> to check IPsec path is functional.
> 
> Signed-off-by: Antony Antony <antony.antony@secunet.com>

Applied, thanks a lot Antony!
