Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C07A5964DA
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 23:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237651AbiHPVo7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 17:44:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237303AbiHPVo6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 17:44:58 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FDAF6525D
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 14:44:57 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id DE12320613;
        Tue, 16 Aug 2022 23:44:54 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 2j3bERU-22Cw; Tue, 16 Aug 2022 23:44:54 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 592E6205E5;
        Tue, 16 Aug 2022 23:44:54 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 40A8D80004A;
        Tue, 16 Aug 2022 23:44:54 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 16 Aug 2022 23:44:54 +0200
Received: from moon.secunet.de (172.18.149.1) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 16 Aug
 2022 23:44:53 +0200
Date:   Tue, 16 Aug 2022 23:44:45 +0200
From:   Antony Antony <antony.antony@secunet.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>
CC:     Antony Antony <antony.antony@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        <netdev@vger.kernel.org>, Tobias Brunner <tobias@strongswan.org>
Subject: Re: [PATCH ipsec-next] xfrm: update x->lastused for every packet
Message-ID: <YvwPzdnyOCWR4UIx@moon.secunet.de>
Reply-To: <antony.antony@secunet.com>
References: <a24754505073ab8f832aa34cd38d3ee68d36bc5e.1659603877.git.antony.antony@secunet.com>
 <20220816092736.GE2950045@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220816092736.GE2950045@gauss3.secunet.de>
Organization: secunet
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

Hi Steffen,

On Tue, Aug 16, 2022 at 11:27:36 +0200, Steffen Klassert wrote:
> On Thu, Aug 04, 2022 at 11:17:31AM +0200, Antony Antony wrote:
> > x->lastused was only updated for outgoing mobile IPv6 packet.
> > With this fix update it for every, in and out, packet.
> > 
> > This is useful to check if the a SA is still in use, or when was
> > the last time an SA was used.  lastused time of in SA can used
> > to check IPsec path is functional.
> > 
> > Signed-off-by: Antony Antony <antony.antony@secunet.com>
> 
> Your patch does not apply to current ipsec-next, please
> rebase.
> 
> Thanks!

thanks for trying to apply this patch to ipsec-next.

I am happy to send a rebased patch, however I suspect ipsec is yet to be
merged into ipsec-next? Why didn't ipsec merge into to "net" before 6.0-rc1?

There is a related patch sitting in in ipsec:
717ada9f10f2 ("Revert "xfrm: update SA curlft.use_time""),

Once that is in ipsec-next this patch would apply.

Would you prefer a rebased patch?

regards,
-antony

