Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7978F32DD74
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 23:56:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232774AbhCDW4y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 17:56:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:40510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232713AbhCDW4y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Mar 2021 17:56:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3E2316146D;
        Thu,  4 Mar 2021 22:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614898613;
        bh=wbloVjdBPW0Zf2F3+GVGWQUHoe6ueKmluN3Wp91lW08=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PZGEdj4Q33cfD8mRKgpD043d2bh+BLp9Yw7w0tjwvJQhH2Zpq3zU9s3uvexRKAYDq
         HZQjlfgz3Spd5SKjAZivJmcr3kIqnfQR+xNaH2AYqTSe45rd/K4EN/gFnPlo+ZOocr
         0y32MpfhBEG2vOphRhNsk9f0FvyweimCBybVh/b6RNGbWYuOAJj7T82vlvjRGfy4Dy
         RbmUYx09qcp4guVjWe9OMsx9FAKD3yGQ7JlTyZyDK89MXK9EGnhZpulu7dMfguZ1xe
         yUcoFZwcs67z/CF48Uf4IRIkSVSJjZL70hxDsR0xzxKZWGBZfTI20sCZ9DxyluaIe6
         Z1b8GjSoZOepw==
Date:   Thu, 4 Mar 2021 16:56:51 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH 107/141] net: core: Fix fall-through warnings for Clang
Message-ID: <20210304225651.GG105908@embeddedor>
References: <cover.1605896059.git.gustavoars@kernel.org>
 <8439b30a691bef3d486f825f07f4e73f81064ec3.1605896060.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8439b30a691bef3d486f825f07f4e73f81064ec3.1605896060.git.gustavoars@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

It's been more than 3 months; who can take this, please? :)

Thanks
--
Gustavo

On Fri, Nov 20, 2020 at 12:38:03PM -0600, Gustavo A. R. Silva wrote:
> In preparation to enable -Wimplicit-fallthrough for Clang, fix a warning
> by explicitly adding a break statement instead of letting the code fall
> through to the next case.
> 
> Link: https://github.com/KSPP/linux/issues/115
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>  net/core/dev.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 82dc6b48e45f..9efb03ce504d 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -5214,6 +5214,7 @@ static int __netif_receive_skb_core(struct sk_buff **pskb, bool pfmemalloc,
>  			goto another_round;
>  		case RX_HANDLER_EXACT:
>  			deliver_exact = true;
> +			break;
>  		case RX_HANDLER_PASS:
>  			break;
>  		default:
> -- 
> 2.27.0
> 
