Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C0F149A8C
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 09:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726232AbfFRH1n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 03:27:43 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:33608 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725870AbfFRH1n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 03:27:43 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id D5928201DB;
        Tue, 18 Jun 2019 09:27:41 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id y-yzA7z73JUm; Tue, 18 Jun 2019 09:27:40 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 94011200BA;
        Tue, 18 Jun 2019 09:27:40 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Tue, 18 Jun 2019
 09:27:40 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 7611C31805F8;
 Tue, 18 Jun 2019 09:27:39 +0200 (CEST)
Date:   Tue, 18 Jun 2019 09:27:39 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     Nicolas Dichtel <nicolas.dichtel@6wind.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, Anirudh Gupta <anirudh.gupta@sophos.com>
Subject: Re: [PATCH ipsec] xfrm: fix sa selector validation
Message-ID: <20190618072739.GY17989@gauss3.secunet.de>
References: <20190614091355.18852-1-nicolas.dichtel@6wind.com>
 <20190614161148.vti6mhvnxfwweznc@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190614161148.vti6mhvnxfwweznc@gondor.apana.org.au>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 15, 2019 at 12:11:48AM +0800, Herbert Xu wrote:
> On Fri, Jun 14, 2019 at 11:13:55AM +0200, Nicolas Dichtel wrote:
> > After commit b38ff4075a80, the following command does not work anymore:
> > $ ip xfrm state add src 10.125.0.2 dst 10.125.0.1 proto esp spi 34 reqid 1 \
> >   mode tunnel enc 'cbc(aes)' 0xb0abdba8b782ad9d364ec81e3a7d82a1 auth-trunc \
> >   'hmac(sha1)' 0xe26609ebd00acb6a4d51fca13e49ea78a72c73e6 96 flag align4
> > 
> > In fact, the selector is not mandatory, allow the user to provide an empty
> > selector.
> > 
> > Fixes: b38ff4075a80 ("xfrm: Fix xfrm sel prefix length validation")
> > CC: Anirudh Gupta <anirudh.gupta@sophos.com>
> > Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> 
> Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Patch applied, thanks everyone!
