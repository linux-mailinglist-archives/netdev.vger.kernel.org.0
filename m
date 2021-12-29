Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4102481191
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 11:17:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239693AbhL2KRR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 05:17:17 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:51166 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239692AbhL2KRP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Dec 2021 05:17:15 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id B3BC9205E3;
        Wed, 29 Dec 2021 11:17:13 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 6v1DTLxWpQ-e; Wed, 29 Dec 2021 11:17:13 +0100 (CET)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 4BC9C205A4;
        Wed, 29 Dec 2021 11:17:13 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 3ADAB80004A;
        Wed, 29 Dec 2021 11:17:13 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 29 Dec 2021 11:17:13 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Wed, 29 Dec
 2021 11:17:12 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 37F2A3182F8D; Wed, 29 Dec 2021 11:17:10 +0100 (CET)
Date:   Wed, 29 Dec 2021 11:17:10 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Antony Antony <antony.antony@secunet.com>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH ipsec-next] xfrm: update SA curlft.use_time
Message-ID: <20211229101710.GO3272477@gauss3.secunet.de>
References: <YanYgmJwrC3REnKc@AntonyAntony.local>
 <ca83656a3e2cf3900635fa5497638f755fad158c.1639760443.git.antony.antony@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ca83656a3e2cf3900635fa5497638f755fad158c.1639760443.git.antony.antony@secunet.com>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 17, 2021 at 06:02:09PM +0100, Antony Antony wrote:
> SA use_time was only updated once, for the first packet.
> with this fix update the use_time for every packet.
> 
> Signed-off-by: Antony Antony <antony.antony@secunet.com>

Applied, thanks Antony!
