Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82F2332C426
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:52:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358507AbhCDALd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:11:33 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:53606 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345477AbhCCLAA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Mar 2021 06:00:00 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 199D720491;
        Wed,  3 Mar 2021 09:30:46 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id sLWRq0ikUTMe; Wed,  3 Mar 2021 09:30:45 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 8F74C20068;
        Wed,  3 Mar 2021 09:30:45 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 3 Mar 2021 09:30:45 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Wed, 3 Mar 2021
 09:30:45 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id D660E3180177; Wed,  3 Mar 2021 09:30:44 +0100 (CET)
Date:   Wed, 3 Mar 2021 09:30:44 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Sabrina Dubroca <sd@queasysnail.net>
CC:     Eyal Birger <eyal.birger@gmail.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <bram-yvahk@mail.wizbit.be>
Subject: Re: [PATCH ipsec 0/2] vti(6): fix ipv4 pmtu check to honor ip header
 df
Message-ID: <20210303083044.GH2966489@gauss3.secunet.de>
References: <20210226213506.506799-1-eyal.birger@gmail.com>
 <YD4GHf4CZUIK6M2E@hog>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <YD4GHf4CZUIK6M2E@hog>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 02, 2021 at 10:32:13AM +0100, Sabrina Dubroca wrote:
> 2021-02-26, 23:35:04 +0200, Eyal Birger wrote:
> > This series aligns vti(6) handling of non-df IPv4 packets exceeding
> > the size of the tunnel MTU to avoid sending "Frag needed" and instead
> > fragment the packets after encapsulation.
> > 
> > Eyal Birger (2):
> >   vti: fix ipv4 pmtu check to honor ip header df
> >   vti6: fix ipv4 pmtu check to honor ip header df
> 
> Thanks Eyal.
> Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
> 
> Steffen, that's going to conflict with commit 4372339efc06 ("net:
> always use icmp{,v6}_ndo_send from ndo_start_xmit") from net.

Applied, thanks everyone!
