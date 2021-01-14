Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 943602F5AEA
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 07:48:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726501AbhANGrj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 01:47:39 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:42184 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725989AbhANGrj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 01:47:39 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kzwPA-00087n-LW; Thu, 14 Jan 2021 17:46:49 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 14 Jan 2021 17:46:48 +1100
Date:   Thu, 14 Jan 2021 17:46:48 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-crypto@vger.kernel.org,
        Qais Yousef <qais.yousef@arm.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH] crypto: Rename struct device_private to
 bcm_device_private
Message-ID: <20210114064648.GE12584@gondor.apana.org.au>
References: <20210104230237.916064-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210104230237.916064-1-jolsa@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 05, 2021 at 12:02:37AM +0100, Jiri Olsa wrote:
> Renaming 'struct device_private' to 'struct bcm_device_private',
> because it clashes with 'struct device_private' from
> 'drivers/base/base.h'.
> 
> While it's not a functional problem, it's causing two distinct
> type hierarchies in BTF data. It also breaks build with options:
>   CONFIG_DEBUG_INFO_BTF=y
>   CONFIG_CRYPTO_DEV_BCM_SPU=y
> 
> as reported by Qais Yousef [1].
> 
> [1] https://lore.kernel.org/lkml/20201229151352.6hzmjvu3qh6p2qgg@e107158-lin/
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  drivers/crypto/bcm/cipher.c | 2 +-
>  drivers/crypto/bcm/cipher.h | 4 ++--
>  drivers/crypto/bcm/util.c   | 2 +-
>  3 files changed, 4 insertions(+), 4 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
