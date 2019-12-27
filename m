Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8EFD12B401
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 11:38:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727122AbfL0Kiw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 05:38:52 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:60270 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726365AbfL0Kiw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Dec 2019 05:38:52 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1ikn17-0007P3-TG; Fri, 27 Dec 2019 18:38:49 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1ikn17-0005ns-Iv; Fri, 27 Dec 2019 18:38:49 +0800
Date:   Fri, 27 Dec 2019 18:38:49 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] chelsio/chtls
Message-ID: <20191227103849.3qcbcgknqp5viyn6@gondor.apana.org.au>
References: <20191219105148.32456-1-vinay.yadav@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191219105148.32456-1-vinay.yadav@chelsio.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 19, 2019 at 04:21:46PM +0530, Vinay Kumar Yadav wrote:
> This series of patches address two issues in chtls.
> patch 1 add support for AES256-GCM based ciphers.
> patch 2 fixes memory leak issues.
> 
> Thanks,
> Vinay
> 
> Vinay Kumar Yadav (2):
>   chtls: Add support for AES256-GCM based ciphers
>   chtls: Fixed memory leak
> 
>  drivers/crypto/chelsio/chtls/chtls.h      |  7 ++-
>  drivers/crypto/chelsio/chtls/chtls_cm.c   | 27 +++++-----
>  drivers/crypto/chelsio/chtls/chtls_cm.h   | 21 ++++++++
>  drivers/crypto/chelsio/chtls/chtls_hw.c   | 65 ++++++++++++++++-------
>  drivers/crypto/chelsio/chtls/chtls_main.c | 23 +++++++-
>  5 files changed, 109 insertions(+), 34 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
