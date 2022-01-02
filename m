Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE359482C1F
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 17:44:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbiABQon (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 11:44:43 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:47338 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229450AbiABQon (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 Jan 2022 11:44:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=fnD2dhLxoIMRnhwXOVwb+QU/PmiAJJndrOMvghYo6yA=; b=KTE0Bn+UtkcO6cFbAWRG0STzQK
        h7JsFqMq/J9r1KQ82bKg+X+ANroDnLWBkNemhdsD0mdB9mEqVhbE4ry4cwVQvTkRT+Wjkx/WtsX0d
        xPNQtl2anV+BiNPhMcdHmhDujw+shyQc1uIcmuM5tMKoExXO3axmESqWX0E9j2o4Cqq0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n43yJ-000Jsy-5N; Sun, 02 Jan 2022 17:44:39 +0100
Date:   Sun, 2 Jan 2022 17:44:39 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     linux-mediatek@lists.infradead.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Michael Lee <igvtee@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH v10 2/3] net: mdio: add helpers to extract clause 45
 regad and devad fields
Message-ID: <YdHWd1kabzYee1Gp@lunn.ch>
References: <YdCNZh5PsBwbfMtp@lunn.ch>
 <YdHJYuO0rYAoWAfD@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YdHJYuO0rYAoWAfD@makrotopia.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 02, 2022 at 03:48:50PM +0000, Daniel Golle wrote:
> From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
> 
> Add a couple of helpers and definitions to extract the clause 45 regad
> and devad fields from the regnum passed into MDIO drivers.
> 
> Tested-by: Daniel Golle <daniel@makrotopia.org>
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
