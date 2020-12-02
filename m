Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 712512CC58D
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 19:44:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731025AbgLBSmz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 13:42:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:39962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730984AbgLBSmu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 13:42:50 -0500
Date:   Wed, 2 Dec 2020 10:42:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1606934529;
        bh=TUhxmjNvPAHZb7ZkOEBJWUIjDFgH0P8rv9sT0BwbcyU=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=N0RwhivJOvhcmcWMr0ee+jK9gSGV0JhVGh4nRTZmardGcVBmAP7wqDKmGeqnIroYf
         pgfEuSv2iQAY2jkzNuSXODN6SmdqIpwAPP0Za6WAYIY5SpgVBcKVcUof9DTXmUCjHV
         S9C/MXRc/lpGbjqbDf5fqoIvl8O87V4gvYRXahShF2oqHy3mpRULqpul0aluAjuGyp
         zov4zHYl0rt3FiR6Wj8EZCRlFjNCqrvU2QyClm4Q1Q6apmKJfD/TnInTv4rffik2IV
         pnjrUrZllX5vJKaqxQohpI2JRFIZnSW0s0eggKB8ZocAehhMEBT9oju0Fkx6LIqdSE
         9DOLjF7uZkt+Q==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH v3 net-next 2/2] net: dsa: qca: ar9331: export stats64
Message-ID: <20201202104207.697cfdbb@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201202140904.24748-3-o.rempel@pengutronix.de>
References: <20201202140904.24748-1-o.rempel@pengutronix.de>
        <20201202140904.24748-3-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  2 Dec 2020 15:09:04 +0100 Oleksij Rempel wrote:
> Add stats support for the ar9331 switch.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Ah, I missed the v3 (like most reviewers it seems :)).
The sleeping in ndo_get_stats64 question applies.
