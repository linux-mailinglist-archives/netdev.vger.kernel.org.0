Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BADB36E1B0
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 01:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232874AbhD1WZ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 18:25:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:53030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232200AbhD1WZ5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Apr 2021 18:25:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D6A9D61423;
        Wed, 28 Apr 2021 22:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619648711;
        bh=Ciu+vjnyzbb1KvMv65Y/6x0VqiGQoi9pYjTaF0fu8Rs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FrehbleRxVg/7CDlRANT7vHjIeCGAe1y3DlmOPy6z7Q4Pj05TISlsVEyltrESPl32
         Paa/lh6n3eNVzFaBDg8o6fzO6XnZDWcU72Q9VAFyNvoshvhmmlkMx6mOU3vqNqTJoh
         +IbmOGc9k0IC6HLB7w2T3QQpd0cTuqc4x64wjh6qht4R2QaDLIKGwOm0GV2Ja4UEhF
         JyjRPtY+Cekc1BbLaszH5cwCZyN3/5/UDiBzJdAOibYZ+njsZ0KkhqSuFnAZeTUvYI
         AKSrg7UAswA/jOvF+7SmLjNv2u1k3AmnPIoXXnN+wOYnydHpOhwIj0c2jDMmlMScIm
         8XmYaWU4sUK3g==
Date:   Wed, 28 Apr 2021 15:25:09 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>,
        Randy Dunlap <rdunlap@infradead.org>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com,
        Fabio Estevam <festevam@gmail.com>,
        David Jander <david@protonic.nl>,
        Russell King <linux@armlinux.org.uk>,
        Philippe Schenker <philippe.schenker@toradex.com>
Subject: Re: [PATCH net-next v1 1/1] net: selftest: fix build issue if INET
 is disabled
Message-ID: <20210428152509.61dc25e7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210428130947.29649-1-o.rempel@pengutronix.de>
References: <20210428130947.29649-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Apr 2021 15:09:46 +0200 Oleksij Rempel wrote:
> In case ethernet driver is enabled and INET is disabled, selftest will
> fail to build.
> 
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Fixes: 3e1e58d64c3d ("net: add generic selftest support")
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Applied (after fixing a checkpatch warning), thanks.
