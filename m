Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 123341D927F
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 10:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728277AbgESIus (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 04:50:48 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:57694 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726333AbgESIus (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 May 2020 04:50:48 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id A54A020523;
        Tue, 19 May 2020 10:50:46 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id yD1z8ml4n1-z; Tue, 19 May 2020 10:50:46 +0200 (CEST)
Received: from cas-essen-01.secunet.de (201.40.53.10.in-addr.arpa [10.53.40.201])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 43CEA200A3;
        Tue, 19 May 2020 10:50:46 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 19 May 2020 10:50:46 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Tue, 19 May
 2020 10:50:45 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 932753180167; Tue, 19 May 2020 10:50:45 +0200 (CEST)
Date:   Tue, 19 May 2020 10:50:45 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Xin Long <lucien.xin@gmail.com>
CC:     <netdev@vger.kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: Re: [PATCH ipsec] esp4: improve xfrm4_beet_gso_segment() to be more
 readable
Message-ID: <20200519085045.GD13121@gauss3.secunet.de>
References: <ad586dda50caf7a29cb1d8b760d38d550a662bc9.1589780119.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ad586dda50caf7a29cb1d8b760d38d550a662bc9.1589780119.git.lucien.xin@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 18, 2020 at 01:35:19PM +0800, Xin Long wrote:
> This patch is to improve the code to make xfrm4_beet_gso_segment()
> more readable, and keep consistent with xfrm6_beet_gso_segment().
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied, thanks Xin!
