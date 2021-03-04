Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D82D032DD5D
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 23:50:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231903AbhCDWum (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 17:50:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:38034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229505AbhCDWul (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Mar 2021 17:50:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E909F65017;
        Thu,  4 Mar 2021 22:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614898241;
        bh=1iZ9TyYhSOsOAEvo+owEj3X/A/iYgQ6h90Ez4CDNoJU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KxyzA4mBdpOLXAVYipIuTCvYvOotR1rDSbFeFPkZPWPpPSJ2xHNBVoP6K30eVRftD
         00PbGFYSacfe9gIvJy4p+c+7kz1crn5sHOcf+8EymQn/1s+J73oryJJ1Nb6iWJ/wRw
         6HjtHx5iiRfsQiHEfjkjpfrSnJZILGuYbNvERt7xKLA3lRIBZTQ4gMJcrbP/6VOk45
         gnfAg/APLwlSwEiqtjI16JbPQSyowkyfeJ7/mV5KrFSmUUtfMWJGD0ItnlgxFF7WLW
         Bfc/OQURCzV69jf/qEeUVMEKhu0zhfLt5cUfInhsLufV2dZOO2GD6K1oxdw5UWJRfH
         wnDDwSHFkpGUA==
Date:   Thu, 4 Mar 2021 16:50:39 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH 042/141] net: 3c509: Fix fall-through warnings for Clang
Message-ID: <20210304225039.GA105908@embeddedor>
References: <cover.1605896059.git.gustavoars@kernel.org>
 <56f997b3e97326076d16930901a4089056e8b6c6.1605896059.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56f997b3e97326076d16930901a4089056e8b6c6.1605896059.git.gustavoars@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

It's been more than 3 months; who can take this, please? :)

Thanks
--
Gustavo

On Fri, Nov 20, 2020 at 12:30:56PM -0600, Gustavo A. R. Silva wrote:
> In preparation to enable -Wimplicit-fallthrough for Clang, fix a warning
> by explicitly adding a break statement instead of just letting the code
> fall through to the next case.
> 
> Link: https://github.com/KSPP/linux/issues/115
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>  drivers/net/ethernet/3com/3c509.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/3com/3c509.c b/drivers/net/ethernet/3com/3c509.c
> index 667f38c9e4c6..676cdc6900b5 100644
> --- a/drivers/net/ethernet/3com/3c509.c
> +++ b/drivers/net/ethernet/3com/3c509.c
> @@ -1052,6 +1052,7 @@ el3_netdev_get_ecmd(struct net_device *dev, struct ethtool_link_ksettings *cmd)
>  		break;
>  	case 3:
>  		cmd->base.port = PORT_BNC;
> +		break;
>  	default:
>  		break;
>  	}
> -- 
> 2.27.0
> 
