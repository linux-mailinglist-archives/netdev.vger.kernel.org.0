Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51DE232DD6D
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 23:54:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232689AbhCDWyv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 17:54:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:39534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229505AbhCDWyu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Mar 2021 17:54:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7617E64FF1;
        Thu,  4 Mar 2021 22:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614898490;
        bh=BsH7Rv59ABNnewO3nCz5tB4conpCHIF+Oo1vQDLbjus=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LgkOVyNP190SEF80ubQ1nnUovhU3UiNfn51EtugNSZp9c3WgSfEvNQozTHXwD3Fsd
         dwhIkmEeZ0lXpyKN/pjouV+Gu+O17KSnAekbT1D5l6uxv/SEq24AlBjBAujAPYzYrK
         V7YEj96GoOxPv/IjBnvbQy6xIlaPFd76BYyZUhw0xjc+Hpd2xqHPGCWRDCTl07dthf
         dnXYXxumfNRBXVaNrdymrbzq92MI6XVaEJemJxlwrJ7+BxGTUiD22L3JKZZRN3xrbj
         aC+ECblCZEgwIdJc1zW2hgq10qWxE8asmD+HfOmlqaXFiys7ekszpJ1Abj2IWaXvJV
         Tqk1pofAnqUAw==
Date:   Thu, 4 Mar 2021 16:54:47 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Joerg Reuter <jreuter@yaina.de>,
        Ralf Baechle <ralf@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH 105/141] net: ax25: Fix fall-through warnings for Clang
Message-ID: <20210304225447.GE105908@embeddedor>
References: <cover.1605896059.git.gustavoars@kernel.org>
 <37c8748f80572a08f33e4ce354f93d61ddfd175b.1605896060.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37c8748f80572a08f33e4ce354f93d61ddfd175b.1605896060.git.gustavoars@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

It's been more than 3 months; who can take this, please? :)

Thanks
--
Gustavo

On Fri, Nov 20, 2020 at 12:37:53PM -0600, Gustavo A. R. Silva wrote:
> In preparation to enable -Wimplicit-fallthrough for Clang, fix a warning
> by explicitly adding a break statement instead of letting the code fall
> through to the next case.
> 
> Link: https://github.com/KSPP/linux/issues/115
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>  net/ax25/af_ax25.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
> index 269ee89d2c2b..2631efc6e359 100644
> --- a/net/ax25/af_ax25.c
> +++ b/net/ax25/af_ax25.c
> @@ -850,6 +850,7 @@ static int ax25_create(struct net *net, struct socket *sock, int protocol,
>  		case AX25_P_ROSE:
>  			if (ax25_protocol_is_registered(AX25_P_ROSE))
>  				return -ESOCKTNOSUPPORT;
> +			break;
>  #endif
>  		default:
>  			break;
> -- 
> 2.27.0
> 
