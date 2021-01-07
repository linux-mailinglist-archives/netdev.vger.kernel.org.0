Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F01E2EE719
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 21:42:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727344AbhAGUmK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 15:42:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:57178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726073AbhAGUmK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 15:42:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C70023443;
        Thu,  7 Jan 2021 20:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610052089;
        bh=a6CUG8PRsVym6Q5Cgj1W5JcGRb/ssqxZKkE6n5tl+t0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WQx4nJrW5FOPbpnb7BjCYYsUnOJlB5LAsbwi6vHWWf2P6+vbaAJSIaf6ttkHcqEfJ
         yu7oXaeI/HoPfhAdSrqD6juYi2l4dlb7rCs4oRjhMl23UNKDhMEzQLzSsnf++SH56g
         rRLYOuGtSnCtIGX05v7D6rsbmZKAOMoSQnwfXXACXuPn859ddWShzujjRDzJ3Zq4mH
         UJ8mqjeBNdY9qIxHJFHIDmuvaY3FSKUf5ynNG+z4y5dtilScU7PoQIU1WwReM7PwGh
         HCnyRO8HP1nXxxhyqhcNTLzxR53uBqEU13B2dhR1foLsweXZ+59VEpZuX5NzjCDQTL
         vXgmXDFe+pdKA==
Date:   Thu, 7 Jan 2021 12:41:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sieng Piaw Liew <liew.s.piaw@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 0/7] bcm63xx_enet: major makeover of driver
Message-ID: <20210107124128.3d989c45@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210106144208.1935-1-liew.s.piaw@gmail.com>
References: <20210106144208.1935-1-liew.s.piaw@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  6 Jan 2021 22:42:01 +0800 Sieng Piaw Liew wrote:
> This patch series aim to improve the bcm63xx_enet driver by integrating the
> latest networking features, i.e. batched rx processing, BQL, build_skb,
> etc.
> 
> The newer enetsw SoCs are found to be able to do unaligned rx DMA by adding
> NET_IP_ALIGN padding which, combined with these patches, improved packet
> processing performance by ~50% on BCM6328.
> 
> Older non-enetsw SoCs still benefit mainly from rx batching. Performance
> improvement of ~30% is observed on BCM6333.
> 
> The BCM63xx SoCs are designed for routers. As such, having BQL is
> beneficial as well as trivial to add.
> 
> v3:
> * Simplify xmit_more patch by not moving around the code needlessly.
> * Fix indentation in xmit_more patch.
> * Fix indentation in build_skb patch.
> * Split rx ring cleanup patch from build_skb patch and precede build_skb
>   patch for better understanding, as suggested by Florian Fainelli.
> 
> v2:
> * Add xmit_more support and rx loop improvisation patches.
> * Moved BQL netdev_reset_queue() to bcm_enet_stop()/bcm_enetsw_stop()
>   functions as suggested by Florian Fainelli.
> * Improved commit messages.

Applied, thanks!
