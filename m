Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06BE04B8660
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 12:03:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231262AbiBPLDJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 06:03:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbiBPLDJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 06:03:09 -0500
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 194B916E7E3
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 03:02:56 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 9BD8F205FC;
        Wed, 16 Feb 2022 12:02:54 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id t3BnLERVqsbf; Wed, 16 Feb 2022 12:02:54 +0100 (CET)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 308A2205CF;
        Wed, 16 Feb 2022 12:02:54 +0100 (CET)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout2.secunet.com (Postfix) with ESMTP id 2A64C80004A;
        Wed, 16 Feb 2022 12:02:54 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.18; Wed, 16 Feb 2022 12:02:53 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Wed, 16 Feb
 2022 12:02:53 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 2A2D73180EF6; Wed, 16 Feb 2022 12:02:53 +0100 (CET)
Date:   Wed, 16 Feb 2022 12:02:52 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Thorsten Leemhuis <regressions@leemhuis.info>
CC:     Jiri Bohac <jbohac@suse.cz>, Sabrina Dubroca <sd@queasysnail.net>,
        "Herbert Xu" <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Mike Maloney <maloneykernel@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        <netdev@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>
Subject: Re: [PATCH] Revert "xfrm: xfrm_state_mtu should return at least 1280
 for ipv6"
Message-ID: <20220216110252.GJ17351@gauss3.secunet.de>
References: <20220114173133.tzmdm2hy4flhblo3@dwarf.suse.cz>
 <20220114174058.rqhtuwpfhq6czldn@dwarf.suse.cz>
 <20220119073519.GJ1223722@gauss3.secunet.de>
 <20220119091233.pzqdlzpcyicjavk5@dwarf.suse.cz>
 <20220124154531.GM1223722@gauss3.secunet.de>
 <20220125094102.ju7bhuplcxnkyv4x@dwarf.suse.cz>
 <20220126064214.GO1223722@gauss3.secunet.de>
 <20220126150018.7cdfxtkq2nfkqj4j@dwarf.suse.cz>
 <20220201064639.GS1223722@gauss3.secunet.de>
 <6da289bf-86a5-44ce-cd19-85529ec1bfe5@leemhuis.info>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <6da289bf-86a5-44ce-cd19-85529ec1bfe5@leemhuis.info>
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

On Tue, Feb 15, 2022 at 03:59:38PM +0100, Thorsten Leemhuis wrote:
> Hi, this is your Linux kernel regression tracker speaking.
> 
> The patch discussed below is now in linux-next for about 11 days, but
> not yet in the net tree afaics. Will it be merged this week? And

It will be merged with the next pull request for the ipsec tree
that will happen likely next week.
