Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBDC5482801
	for <lists+netdev@lfdr.de>; Sat,  1 Jan 2022 18:19:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231718AbiAARTA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jan 2022 12:19:00 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:46736 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230063AbiAARTA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 Jan 2022 12:19:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Glzfb7MgntJxbNhtUxxxU3aIqwDb8w14BI96IUbcxeM=; b=zvXZRWQ358/bOf3v5c2rlUuPjb
        NGBpgZyjS9YV7Dh2gF7ZZPyhp607/H4QssBixqnRgqmS6NeA70z4LOeI8euZcNcJTcQkZMJgrfmTn
        LxtI95n8A+4EAiSDsVEqm6SBaIfCI7B/Xha+VSLJWUoogEHBjhtb0xe0is/E4R2kYx5o=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n3i1u-000H5Z-Cp; Sat, 01 Jan 2022 18:18:54 +0100
Date:   Sat, 1 Jan 2022 18:18:54 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
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
Message-ID: <YdCM/mbeT66asmj7@lunn.ch>
References: <Ycr5Cna76eg2B0An@shell.armlinux.org.uk>
 <Yc9tk6IZ0ldqHx4Y@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yc9tk6IZ0ldqHx4Y@makrotopia.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 31, 2021 at 08:52:35PM +0000, Russell King (Oracle) wrote:
> Add a couple of helpers and definitions to extract the clause 45 regad
> and devad fields from the regnum passed into MDIO drivers.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

This email has me confused. It seems to be coming directly from
Russell, but is part of a patchset? Then there is a second 1/3 later
in the patchset?

	 Andrew
