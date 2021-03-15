Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABD0133C56E
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 19:21:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231559AbhCOSUl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 14:20:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:50740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231482AbhCOSUW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 14:20:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DEC6D64F3F;
        Mon, 15 Mar 2021 18:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615832422;
        bh=GYYv+MsheeXWjs0+8ccatBH06Jins/lXZch2vvJxfDc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nlP01otv8chY6yQnAiYzsKkjEp7SjIcJdLFSf68T3YHedu61/ntLE8BuQHcWdA4Xb
         KFnBgfGSYttVY015OFKatx9Zy2XovB2KMnwUw+Dj93r4COslZ7WL6RorQ9CT3MM7oC
         9VkfyWFtuPYwJPgdWi46c77dmJIfKVokn38xcSNBMtQBg7MIu6F5D8d1dlM4P045O1
         hmck8MfuBt2wKE+8q6qJ9o7fQa5Jq9HEC7eHfMcanhUOO5LWbmirSBV3OmfiXDcpqx
         jc2x8SGSCNPKgrc0cwWI6HG74cqcyJzAm39DAY2CkaY/HVINEbG2zzEK9JQp+gyxXF
         1PY1yZoH072kQ==
Date:   Mon, 15 Mar 2021 11:20:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Chinmayi Shetty <chinmayishetty359@gmail.com>
Cc:     pablo@netfilter.org, laforge@gnumonks.org, davem@davemloft.net,
        osmocom-net-gprs@lists.osmocom.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bkkarthik@pesu.pes.edu
Subject: Re: [PATCH] Net: gtp: Fixed missing blank line after declaration
Message-ID: <20210315112021.0278875d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210313165128.jc2u2pnpm3enbx2h@client-VirtualBox>
References: <20210313165128.jc2u2pnpm3enbx2h@client-VirtualBox>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 13 Mar 2021 22:21:28 +0530 Chinmayi Shetty wrote:
> Signed-off-by: Chinmayi Shetty <chinmayishetty359@gmail.com>
> ---
>  drivers/net/gtp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
> index efe5247d8c42..79998f4394e5 100644
> --- a/drivers/net/gtp.c
> +++ b/drivers/net/gtp.c
> @@ -437,7 +437,7 @@ static inline void gtp1_push_header(struct sk_buff *skb, struct pdp_ctx *pctx)
>  	gtp1->length	= htons(payload_len);
>  	gtp1->tid	= htonl(pctx->u.v1.o_tei);
>  
> -	/* TODO: Suppport for extension header, sequence number and N-PDU.
> +	/* TODO: Support for extension header, sequence number and N-PDU.
>  	 *	 Update the length field if any of them is available.
>  	 */
>  }

Subject does not match the patch.
