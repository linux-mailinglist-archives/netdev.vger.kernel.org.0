Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 399382CC2F1
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 18:03:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387462AbgLBRC3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 12:02:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:33392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727126AbgLBRC3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 12:02:29 -0500
Date:   Wed, 2 Dec 2020 09:01:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606928509;
        bh=kX2DaUOysx3Z1mz+SBekV3S5VhZNddgamT7eKKsCxQ4=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=LSjlEGMn+8QhdXFjgRDZc7Wj6GsicEnZS2U2bEFcf3zDer+otsyBGlDl21zKfzN/H
         Ke/KN1dY48HrZ2aPg47pHS+qPulkK13XPkUzZ9nWhBErO9HfCK06iVA1vyOmfr7lYf
         suB/LubeeRO7EXJzrxxuJsiPQSrs4H5ZKZlpsvDI=
From:   Jakub Kicinski <kuba@kernel.org>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Ido Schimmel <idosch@idosch.org>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [PATCH net-next] net: sfp: add debugfs support
Message-ID: <20201202090147.48af58fd@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201202085913.1eda0bba@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
References: <E1khJyS-0003UU-9O@rmk-PC.armlinux.org.uk>
        <20201124001431.GA2031446@lunn.ch>
        <20201124084151.GA722671@shredder.lan>
        <20201124094916.GD1551@shell.armlinux.org.uk>
        <20201124104640.GA738122@shredder.lan>
        <20201202130318.GD1551@shell.armlinux.org.uk>
        <20201202085913.1eda0bba@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2 Dec 2020 08:59:13 -0800 Jakub Kicinski wrote:
> On Wed, 2 Dec 2020 13:03:18 +0000 Russell King - ARM Linux admin wrote:
> > Jakub,
> > 
> > What's your opinion on this patch? It seems to have stalled...  
> 
> Sorry, I think I expected someone to do the obvious questioning..

Ah, no! I know what happened... Check out patchwork:

https://patchwork.kernel.org/project/netdevbpf/patch/E1khJyS-0003UU-9O@rmk-PC.armlinux.org.uk/

It says the patch did not apply cleanly to net-next ;)

Regardless let's hear what people thing about using ext_link (or
similar) for the SFP signals.
