Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85721145236
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 11:12:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729074AbgAVKM4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 05:12:56 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:39058 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725911AbgAVKM4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jan 2020 05:12:56 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1iuD0H-0000SH-Lh; Wed, 22 Jan 2020 18:12:53 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1iuD0G-00040u-TY; Wed, 22 Jan 2020 18:12:52 +0800
Date:   Wed, 22 Jan 2020 18:12:52 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 0/3] Crypto/chtls bug fixes
Message-ID: <20200122101252.t2ciizio6r6hrcso@gondor.apana.org.au>
References: <20200114122849.133085-1-vinay.yadav@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200114122849.133085-1-vinay.yadav@chelsio.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 14, 2020 at 05:58:46PM +0530, Vinay Kumar Yadav wrote:
> These patches fix followings
> patch 1: Corrected function call context
> patch 2: TCP listen fail bug fix
> patch 3: Added stats counter for tls
> 
> Vinay Kumar Yadav (3):
>   Crypto/chtls: Corrected function call context
>   crypto/chtls: Fixed listen fail when max stid range reached
>   chelsio/cxgb4: Added tls stats prints
> 
>  drivers/crypto/chelsio/chtls/chtls_cm.c       | 30 +++++++++----------
>  drivers/crypto/chelsio/chtls/chtls_main.c     |  5 ++--
>  .../ethernet/chelsio/cxgb4/cxgb4_debugfs.c    |  7 +++++
>  3 files changed, 24 insertions(+), 18 deletions(-)

Patches 1-2 applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
