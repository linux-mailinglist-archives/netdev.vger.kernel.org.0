Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12C1552B471
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 10:19:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232732AbiERINm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 04:13:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232680AbiERINl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 04:13:41 -0400
X-Greylist: delayed 60 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 18 May 2022 01:13:40 PDT
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 599668149F;
        Wed, 18 May 2022 01:13:40 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 17F0A20762;
        Wed, 18 May 2022 10:13:39 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id DbPrZfv7-ssw; Wed, 18 May 2022 10:13:38 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 9D6822075A;
        Wed, 18 May 2022 10:13:38 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 8F10680004A;
        Wed, 18 May 2022 10:13:38 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 18 May 2022 10:13:38 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 18 May
 2022 10:13:38 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 047B13182D02; Wed, 18 May 2022 10:13:38 +0200 (CEST)
Date:   Wed, 18 May 2022 10:13:37 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Thomas Bartschies <thomas.bartschies@cvk.de>
CC:     <davem@davemloft.net>, <herbert@gondor.apana.org.au>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Patch] net: af_key: check encryption module availability
 consistency
Message-ID: <20220518081337.GU680067@gauss3.secunet.de>
References: <20220518063218.5336B160CF38F@cvk027.cvk.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220518063218.5336B160CF38F@cvk027.cvk.de>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
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

On Wed, May 18, 2022 at 08:32:18AM +0200, Thomas Bartschies wrote:
> Since the recent introduction supporting the SM3 and SM4 hash algos for IPsec, the kernel 
> produces invalid pfkey acquire messages, when these encryption modules are disabled. This 
> happens because the availability of the algos wasn't checked in all necessary functions. 
> This patch adds these checks.
> 
> Signed-off-by: Thomas Bartschies <thomas.bartschies@cvk.de>

Applied, thanks!
