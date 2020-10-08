Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7C802879C8
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 18:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725922AbgJHQOn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 12:14:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:47838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728859AbgJHQOm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Oct 2020 12:14:42 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF3A921D7D;
        Thu,  8 Oct 2020 16:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602173682;
        bh=bM5ahj/gZtgfxTO4eposlFzm3ykzO1VrYEGMdCeVYRo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=wf3lejOgfjnGnsAPppAmjMDRpgg4mrzVgyTL4Cy+D+0EqNyCp+qpZ1LQ7KPJDDaeG
         9bFqO5vZ4qd4BP23qUuogOMXKHaLs87uDWeSNOxOtCg/i+z0vfcnVTv3rTYGwaRm3a
         xgujHiK9uXxDS9AbH8Du7kEICyCNFEy+4ESTyQIA=
Date:   Thu, 8 Oct 2020 09:14:37 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Subject: Re: [net-next PATCH v3] net: dsa: rtl8366rb: Roof MTU for switch
Message-ID: <20201008091437.559e3d6c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201008091955.44692-1-linus.walleij@linaro.org>
References: <20201008091955.44692-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  8 Oct 2020 11:19:55 +0200 Linus Walleij wrote:
> diff --git a/drivers/net/dsa/rtl8366rb.c b/drivers/net/dsa/rtl8366rb.c
> index 053bf5041f8d..28f510a580be 100644
> --- a/drivers/net/dsa/rtl8366rb.c
> +++ b/drivers/net/dsa/rtl8366rb.c
> @@ -311,6 +311,13 @@
>  #define RTL8366RB_GREEN_FEATURE_TX	BIT(0)
>  #define RTL8366RB_GREEN_FEATURE_RX	BIT(2)
>  
> +/**
> + * struct rtl8366rb - RTL8366RB-specific data
> + */
> +struct rtl8366rb {
> +	unsigned int max_mtu[RTL8366RB_NUM_PORTS];
> +};

If you make the comment kdoc, you gotta describe all fields (or mark
'em private) otherwise:

drivers/net/dsa/rtl8366rb.c:319: warning: Function parameter or member 'max_mtu' not described in 'rtl8366rb'
