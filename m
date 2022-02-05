Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47C564AA677
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 05:30:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379343AbiBEEat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 23:30:49 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:34022 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1379333AbiBEEar (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Feb 2022 23:30:47 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1nGCia-00020D-0M; Sat, 05 Feb 2022 15:30:37 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Sat, 05 Feb 2022 15:30:35 +1100
Date:   Sat, 5 Feb 2022 15:30:35 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Shijith Thotton <sthotton@marvell.com>
Cc:     Arnaud Ebalard <arno@natisbad.org>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Srujana Challa <schalla@marvell.com>,
        linux-crypto@vger.kernel.org, jerinj@marvell.com,
        sgoutham@marvell.com, "David S. Miller" <davem@davemloft.net>,
        Linu Cherian <lcherian@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:MARVELL OCTEONTX2 RVU ADMIN FUNCTION DRIVER" 
        <netdev@vger.kernel.org>
Subject: Re: [PATCH] crypto: octeontx2: disable DMA black hole on an DMA fault
Message-ID: <Yf39a4NJglaf0eDy@gondor.apana.org.au>
References: <ab2269cb3ef3049ed0ab73f28be29f6669a06e36.1643134480.git.sthotton@marvell.com>
 <2ece169a85504c8a185070055db2f6f8ea3c7d11.1643134449.git.sthotton@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2ece169a85504c8a185070055db2f6f8ea3c7d11.1643134449.git.sthotton@marvell.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 25, 2022 at 11:56:23PM +0530, Shijith Thotton wrote:
> From: Srujana Challa <schalla@marvell.com>
> 
> When CPT_AF_DIAG[FLT_DIS] = 0 and a CPT engine access to
> LLC/DRAM encounters a fault/poison, a rare case may result
> in unpredictable data being delivered to a CPT engine.
> So, this patch adds code to set FLT_DIS as a workaround.
> 
> Signed-off-by: Srujana Challa <schalla@marvell.com>
> Signed-off-by: Shijith Thotton <sthotton@marvell.com>
> ---
>  drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c | 13 +++++++++++++
>  drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c |  1 +
>  2 files changed, 14 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
