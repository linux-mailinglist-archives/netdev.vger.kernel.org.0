Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC11C59820A
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 13:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244332AbiHRLNV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 07:13:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244325AbiHRLNT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 07:13:19 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 784FDC1B;
        Thu, 18 Aug 2022 04:13:15 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 2883F20538;
        Thu, 18 Aug 2022 13:13:14 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id lked6gCadlW7; Thu, 18 Aug 2022 13:13:13 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id A1C2820519;
        Thu, 18 Aug 2022 13:13:13 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 8ED5B80004A;
        Thu, 18 Aug 2022 13:13:13 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 18 Aug 2022 13:13:13 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 18 Aug
 2022 13:13:13 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id AB11A3182AA7; Thu, 18 Aug 2022 13:13:12 +0200 (CEST)
Date:   Thu, 18 Aug 2022 13:13:12 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Gautam Menghani <gautammenghani201@gmail.com>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <shuah@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-kernel-mentees@lists.linuxfoundation.org>
Subject: Re: [PATCH v3] selftests/net: Refactor xfrm_fill_key() to use array
 of structs
Message-ID: <20220818111312.GH566407@gauss3.secunet.de>
References: <55c8de7e-a6e8-fc79-794d-53536ad7a65d@collabora.com>
 <20220806163530.70182-1-gautammenghani201@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220806163530.70182-1-gautammenghani201@gmail.com>
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

On Sat, Aug 06, 2022 at 10:05:30PM +0530, Gautam Menghani wrote:
> A TODO in net/ipsec.c asks to refactor the code in xfrm_fill_key() to
> use set/map to avoid manually comparing each algorithm with the "name" 
> parameter passed to the function as an argument. This patch refactors 
> the code to create an array of structs where each struct contains the 
> algorithm name and its corresponding key length.
> 
> Signed-off-by: Gautam Menghani <gautammenghani201@gmail.com>

Applied to ipsec-next, thanks!
