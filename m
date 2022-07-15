Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 758A6575C68
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 09:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231901AbiGOHbq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 03:31:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231902AbiGOHbp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 03:31:45 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 914877B78E;
        Fri, 15 Jul 2022 00:31:41 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id AF88C209E1;
        Fri, 15 Jul 2022 09:31:28 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id mgWaDqviUQaR; Fri, 15 Jul 2022 09:30:53 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 213FB208A6;
        Fri, 15 Jul 2022 08:14:55 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 18E5C80004A;
        Fri, 15 Jul 2022 08:14:45 +0200 (CEST)
Received: from mbx-dresden-01.secunet.de (10.53.40.199) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 15 Jul 2022 08:14:34 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-dresden-01.secunet.de
 (10.53.40.199) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Fri, 15 Jul
 2022 08:14:34 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id CCB823180785; Fri, 15 Jul 2022 08:14:33 +0200 (CEST)
Date:   Fri, 15 Jul 2022 08:14:33 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     <iamwjia@163.com>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Hacash Robot <hacashRobot@santino.com>
Subject: Re: [PATCH -next] xfrm: Fix couple of spellings
Message-ID: <20220715061433.GS566407@gauss3.secunet.de>
References: <20220713154529.53031-1-iamwjia@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220713154529.53031-1-iamwjia@163.com>
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

On Wed, Jul 13, 2022 at 11:45:29PM +0800, iamwjia@163.com wrote:
> From: Wang Jia <iamwjia@163.com>
> 
> accomodate  ==> accommodate
> destionation  ==> destination
> execeeds  ==> exceeds
> informations  ==> information
> 
> Reported-by: Hacash Robot <hacashRobot@santino.com>
> Signed-off-by: Wang Jia <iamwjia@163.com>
> ---
>  net/ipv6/ah6.c     | 2 +-
>  net/ipv6/esp6.c    | 4 ++--

Your patch does not apply to ipsec-next, the fixes
for net/ipv6/esp6.c are already done there.

Please rebase your patch to ipsec-next, thanks!
