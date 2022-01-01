Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DFB8482803
	for <lists+netdev@lfdr.de>; Sat,  1 Jan 2022 18:20:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbiAARUo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jan 2022 12:20:44 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:46760 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229930AbiAARUo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 Jan 2022 12:20:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=nzZC+21A+9JGb98AGvNNwxugjcKYoFPrsOvnup449Qc=; b=bPdQrJFfaTxM9bn2AmvPQA5fMK
        Pte7rnrA+hEYhD1C20Ia4vpDn8rsXnker1jYTo49HNtRq0/fIPUH7bylBrv2D7IQbJfkB2om0DJDy
        EIXsNSYdp6x9WathgteWzYNTRE6WxeOSwwT9bPYb4JGeShXOt7aJfGX4xOgHl6XpUKd4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n3i3a-000H6J-1F; Sat, 01 Jan 2022 18:20:38 +0100
Date:   Sat, 1 Jan 2022 18:20:38 +0100
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
Subject: Re: [PATCH v9 1/3] net: mdio: add helpers to extract clause 45 regad
 and devad fields
Message-ID: <YdCNZh5PsBwbfMtp@lunn.ch>
References: <Ycr5Cna76eg2B0An@shell.armlinux.org.uk>
 <Yc9uphz7RGb63kzM@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yc9uphz7RGb63kzM@makrotopia.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 31, 2021 at 08:57:43PM +0000, Daniel Golle wrote:
> From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
> 
> Add a couple of helpers and definitions to extract the clause 45 regad
> and devad fields from the regnum passed into MDIO drivers.
> 
> Tested-by: Daniel Golle <daniel@makrotopia.org>
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Hi Daniel

Since you are submitted this, your Signed-off-by: needs to be last.

      Andrew
