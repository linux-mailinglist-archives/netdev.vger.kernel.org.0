Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B858148DF4F
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 22:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbiAMVAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 16:00:36 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:36808 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229543AbiAMVAf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jan 2022 16:00:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=taszK2/KBSsEBav3Xn8T0GVXCuTYigYWHsUS6Bf7Qng=; b=1XQSD+DdatRMep3V0Skuj7aguO
        fLEiGe1uoQkCfCpA8LOxVH6Cbjm1n2M54oqI+neTFi8vA6VPANP8KcDARDKuBoHDIu2v5E3KtsJp4
        XVexEjymjy2gjqhAE+TNQfAySq+1wsTl6t1jk0uqryDutiOggiMyLPs6IUT7V7LPIQQY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n87Cq-001L1h-6I; Thu, 13 Jan 2022 22:00:24 +0100
Date:   Thu, 13 Jan 2022 22:00:24 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>
Cc:     Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com
Subject: Re: [PATCH] bcmgenet: add WOL IRQ check
Message-ID: <YeCS6Ld93zCK6aWh@lunn.ch>
References: <2b49e965-850c-9f71-cd54-6ca9b7571cc3@omp.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2b49e965-850c-9f71-cd54-6ca9b7571cc3@omp.ru>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 13, 2022 at 10:46:07PM +0300, Sergey Shtylyov wrote:
> The driver neglects to check the result of platform_get_irq_optional()'s
> call and blithely passes the negative error codes to devm_request_irq()
> (which takes *unsigned* IRQ #), causing it to fail with -EINVAL.
> Stop calling devm_request_irq() with the invalid IRQ #s.
> 
> Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
> 
> ---
> This patch is against DaveM's 'net.git' repo.

Since this is for net, it needs a Fixes: tag.

Fixes: 8562056f267d ("net: bcmgenet: request Wake-on-LAN interrupt")

       Andrew
