Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 585943B1F52
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 19:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbhFWRWN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 13:22:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:55248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229726AbhFWRWM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Jun 2021 13:22:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B18E611AC;
        Wed, 23 Jun 2021 17:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624468794;
        bh=jKyYAR836m83Pum8UbxthFZqnbIkz8NbuPp5frmUkn0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=T45psABiJrEhVhCqb/ImjGcszfmX9w0eT/d7Q3FDPdnROLpNDzU1UkMmmWaRZy9zt
         Dnt1TbJrrblELZToRz0uD/hQsrJ6BE3gMWzEjIMzVqiCuwWTuWdh7R6COLdC/O/NGo
         7hITBfKI54HEKuPawPDHOOxH4fmzoLRX8I94aQLU=
Date:   Wed, 23 Jun 2021 19:19:51 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Rocco Yue <rocco.yue@mediatek.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, bpf@vger.kernel.org,
        wsd_upstream@mediatek.com, chao.song@mediatek.com,
        zhuoliang.zhang@mediatek.com, kuohong.wang@mediatek.com
Subject: Re: [PATCH 1/4] net: if_arp: add ARPHRD_PUREIP type
Message-ID: <YNNtN3cdDL71SiNt@kroah.com>
References: <20210623113452.5671-1-rocco.yue@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210623113452.5671-1-rocco.yue@mediatek.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 23, 2021 at 07:34:49PM +0800, Rocco Yue wrote:
> This patch add the definition of ARPHRD_PUREIP which can for
> example be used by mobile ccmni device as device type.
> ARPHRD_PUREIP means that this device doesn't need kernel to
> generate ipv6 link-local address in any addr_gen_mode.
> 
> Signed-off-by: Rocco Yue <rocco.yue@mediatek.com>
> ---
>  include/uapi/linux/if_arp.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/uapi/linux/if_arp.h b/include/uapi/linux/if_arp.h
> index c3cc5a9e5eaf..4463c9e9e8b4 100644
> --- a/include/uapi/linux/if_arp.h
> +++ b/include/uapi/linux/if_arp.h
> @@ -61,6 +61,7 @@
>  #define ARPHRD_DDCMP    517		/* Digital's DDCMP protocol     */
>  #define ARPHRD_RAWHDLC	518		/* Raw HDLC			*/
>  #define ARPHRD_RAWIP    519		/* Raw IP                       */
> +#define ARPHRD_PUREIP	520		/* Pure IP			*/

In looking at the patches, what differs "PUREIP" from "RAWIP"?  It seems
to be the same to me.  If they are different, where is that documented?

thanks,

greg k-h
