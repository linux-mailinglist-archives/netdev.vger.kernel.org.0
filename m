Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB5336109E
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 18:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234346AbhDOQ7X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 12:59:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:48426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234221AbhDOQ7V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 12:59:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CED8961184;
        Thu, 15 Apr 2021 16:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618505938;
        bh=vbt7Bh4llsX+BuVJHZocXLCH9HOG15xDfCC3KadXGPs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pCYHR+Q1Wne+k9x1R1IUhhuRZSdWBmChXM2DqchXN8qWOEaJYpHZD4yAY+2hPOuD8
         7oqxJ7Sp2g3l3fflHzkZkFR6MGfljRIDAWhfCUSpZwgEUI64sdSDN8AlZU8AFcjY3t
         kTzctP1xCkKLis3BACzzXmf4OJzv3t14hViFbCzc3VCyR+fkIOAEojakIIthgrq2DN
         p3O8hh5kh80yWlcmZo2AW/8EXwk1bjF6Drc+3M9TF0VHhb/1GiPBwMH5qth/6oV19n
         6Uh+Ccd7in5anFdhTJ60R8BbLS7fgR7RZTXeJRFS1F/GU5rMsIdG0PodAepaACOOpA
         Isn8WEsA6yNFQ==
Date:   Thu, 15 Apr 2021 09:58:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com,
        Fabio Estevam <festevam@gmail.com>,
        David Jander <david@protonic.nl>,
        Russell King <linux@armlinux.org.uk>,
        Philippe Schenker <philippe.schenker@toradex.com>
Subject: Re: [PATCH v2 5/7] net: fec: make use of generic NET_SELFTESTS
 library
Message-ID: <20210415095856.2966dd7c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210415130738.19603-6-o.rempel@pengutronix.de>
References: <20210415130738.19603-1-o.rempel@pengutronix.de>
        <20210415130738.19603-6-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 15 Apr 2021 15:07:36 +0200 Oleksij Rempel wrote:
> With this patch FEC on iMX will able to run generic net selftests
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

allmodconfig build fails starting from this patch and still fails 
after patch 7:

net/core/selftests.o: In function `net_selftest':
selftests.c:(.text+0x75c): undefined reference to `phy_loopback'
selftests.c:(.text+0x7c2): undefined reference to `phy_loopback'
