Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 245474DE6D8
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 08:49:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236790AbiCSHuh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 03:50:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236778AbiCSHug (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 03:50:36 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF93C15DA86
        for <netdev@vger.kernel.org>; Sat, 19 Mar 2022 00:49:14 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 5642C205FD;
        Sat, 19 Mar 2022 08:49:13 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ksct3NsoFQ-c; Sat, 19 Mar 2022 08:49:12 +0100 (CET)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id D89C8205FC;
        Sat, 19 Mar 2022 08:49:12 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id CF90880004A;
        Sat, 19 Mar 2022 08:49:12 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 19 Mar 2022 08:49:12 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Sat, 19 Mar
 2022 08:49:12 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id E35FE3182EB2; Sat, 19 Mar 2022 08:49:11 +0100 (CET)
Date:   Sat, 19 Mar 2022 08:49:11 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        <netdev@vger.kernel.org>
Subject: Re: pull request (net): ipsec 2022-03-16
Message-ID: <20220319074911.GB4161825@gauss3.secunet.de>
References: <20220316121142.3142336-1-steffen.klassert@secunet.com>
 <20220316114438.11955749@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220316114438.11955749@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
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

On Wed, Mar 16, 2022 at 11:44:38AM -0700, Jakub Kicinski wrote:
> On Wed, 16 Mar 2022 13:11:40 +0100 Steffen Klassert wrote:
> > Two last fixes for this release cycle:
> > 
> > 1) Fix a kernel-info-leak in pfkey.
> >    From Haimin Zhang.
> > 
> > 2) Fix an incorrect check of the return value of ipv6_skip_exthdr.
> >    From Sabrina Dubroca.
> 
> Excellent, thank you!
> 
> > Please pull or let me know if there are problems.
> 
> One minor improvement to appease patchwork would be to add / keep the
> [PATCH 0/n] prefix on the PR / cover letter when posting the patches
> under it.

I did that in the ipsec-next pull request, let me know if this is
OK as I did it.

> It seems that patchwork is hopeless in delineating the
> patches and the PR if that's not there. For whatever reason it grouped
> the PR and patch 2 as a series and patch 1 was left separate :S

I guess this is why I get always two mails from patchwork-bot for
each pull request. I already wondered why that happens :)
