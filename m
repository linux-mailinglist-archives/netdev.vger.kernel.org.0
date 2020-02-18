Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF40163228
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 21:06:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbgBRUGP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 15:06:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:39978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728117AbgBRUAi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 15:00:38 -0500
Received: from kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A12032465D;
        Tue, 18 Feb 2020 20:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582056038;
        bh=/0wc+gVibFCwi9Uhey6CJBXYspWcUlheQVbd9zQZ+u8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aiB7NbJJLE9ZWIjvfR0ZRMklqm7SWHSWMptNgG9V1x6db0MlAQZLNv80nz2gMkTXt
         4SIPW0nNcRE0bQrDozEKhOy5o9N7ISGLe08rEVyxsH2Q6mRhTFLOdJMrsSJ3NiBevp
         9zY5ce5GzkxylW8OF7tf1NEQloPNO1rUh73NcrhU=
Date:   Tue, 18 Feb 2020 12:00:36 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH] MAINTAINERS: remove Felix Fietkau for the Mediatek
 ethernet driver
Message-ID: <20200218120036.380a5a16@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20200218103959.GA9487@e0022681537dd.dyn.armlinux.org.uk>
References: <20200218103959.GA9487@e0022681537dd.dyn.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Feb 2020 10:40:01 +0000 Russell King wrote:
> Felix's address has been failing for a while now with the following
> non-delivery report:
> 
> This message was created automatically by mail delivery software.
> 
> A message that you sent could not be delivered to one or more of its
> recipients. This is a permanent error. The following address(es) failed:
> 
>   nbd@openwrt.org
>     host util-01.infra.openwrt.org [2a03:b0c0:3:d0::175a:2001]
>     SMTP error from remote mail server after RCPT TO:<nbd@openwrt.org>:
>     550 Unrouteable address
> 
> Let's remove his address from MAINTAINERS.  If a different resolution
> is desired, please submit an alternative patch.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> ---
>  MAINTAINERS | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index a0d86490c2c6..82dccd29b24f 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -10528,7 +10528,6 @@ F:	drivers/leds/leds-mt6323.c
>  F:	Documentation/devicetree/bindings/leds/leds-mt6323.txt
>  
>  MEDIATEK ETHERNET DRIVER
> -M:	Felix Fietkau <nbd@openwrt.org>
>  M:	John Crispin <john@phrozen.org>
>  M:	Sean Wang <sean.wang@mediatek.com>
>  M:	Mark Lee <Mark-MC.Lee@mediatek.com>

Let's CC Felix, I think he's using nbd@nbd.name these days.
