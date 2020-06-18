Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E041F1FF7EC
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 17:49:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731469AbgFRPrt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 11:47:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:53082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728171AbgFRPrt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 11:47:49 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8C43206FA;
        Thu, 18 Jun 2020 15:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592495269;
        bh=ZRnw59PmBNGqwnuvTGvDkE/vrDmc4J/JFLZmIkeoenI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ghi6G6IZX5gC1x7GvDLhbLEIM1eT19KQ19NbQAIidgu4ZMK/vuxI6oWnhwP3Kd7Ds
         nUH35nnJzvJNXpH4salqZHid5hHKAsc4FF+SCy/qzkKiKnLIIlISOLlOysRBoA4ZzY
         uPCqpq/cgbGM2/eIFbf06N2nlPG2d0mZc5pJxTAI=
Date:   Thu, 18 Jun 2020 08:47:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, michael@walle.cc, andrew@lunn.ch,
        linux@armlinux.org.uk, f.fainelli@gmail.com
Subject: Re: [PATCH net-next 4/5] net: phy: add Lynx PCS MDIO module
Message-ID: <20200618084747.7f8cc85b@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200618120837.27089-5-ioana.ciornei@nxp.com>
References: <20200618120837.27089-1-ioana.ciornei@nxp.com>
        <20200618120837.27089-5-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 18 Jun 2020 15:08:36 +0300 Ioana Ciornei wrote:
> +#if IS_ENABLED(CONFIG_MDIO_LYNX_PCS)
> +struct mdio_lynx_pcs *mdio_lynx_pcs_create(struct mdio_device *mdio_dev);
> +
> +void mdio_lynx_pcs_free(struct mdio_lynx_pcs *pcs);
> +#else
> +static struct mdio_lynx_pcs *mdio_lynx_pcs_create(struct mdio_device *mdio_dev)
> +{
> +	return NULL;
> +}
> +
> +static void mdio_lynx_pcs_free(struct mdio_lynx_pcs *pcs)
> +{
> +}
> +#endif

Do you want these to be static inline?
