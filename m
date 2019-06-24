Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F9845045E
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 10:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727333AbfFXIUn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 04:20:43 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:48992 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727014AbfFXIUm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jun 2019 04:20:42 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 4F8AB200BD;
        Mon, 24 Jun 2019 10:20:41 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id xyz5bWeoWHXe; Mon, 24 Jun 2019 10:20:40 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id D90AC200B9;
        Mon, 24 Jun 2019 10:20:40 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Mon, 24 Jun 2019
 10:20:39 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 7E87431805E9;
 Mon, 24 Jun 2019 10:20:40 +0200 (CEST)
Date:   Mon, 24 Jun 2019 10:20:40 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Arnd Bergmann <arnd@arndb.de>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [v2] ipsec: select crypto ciphers for xfrm_algo
Message-ID: <20190624082040.GN14601@gauss3.secunet.de>
References: <20190618112227.3322313-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190618112227.3322313-1-arnd@arndb.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 18, 2019 at 01:22:13PM +0200, Arnd Bergmann wrote:
> kernelci.org reports failed builds on arc because of what looks
> like an old missed 'select' statement:
> 
> net/xfrm/xfrm_algo.o: In function `xfrm_probe_algs':
> xfrm_algo.c:(.text+0x1e8): undefined reference to `crypto_has_ahash'
> 
> I don't see this in randconfig builds on other architectures, but
> it's fairly clear we want to select the hash code for it, like we
> do for all its other users. As Herbert points out, CRYPTO_BLKCIPHER
> is also required even though it has not popped up in build tests.
> 
> Fixes: 17bc19702221 ("ipsec: Use skcipher and ahash when probing algorithms")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Applied, thanks a lot!
