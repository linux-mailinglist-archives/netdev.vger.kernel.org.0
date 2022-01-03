Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D9F74837FA
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 21:17:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbiACURb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 15:17:31 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:48926 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229796AbiACURa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jan 2022 15:17:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=0oZv60GKcHzqITnRG34XTD85FFqqcUJPJ/Bagrlxjjw=; b=BW8U1rjPNdi/NiTdS7HTGe69pd
        O/op/Xkq9+ZhlwW1Ip1PB4MJk2HvjIyumM4fdsIYGDZw9o8AMai1XZF3A82+6I//OPw2Oe/ST56JH
        i3kXJ4yA8WLw9KrDezO7L+ycyJONi1sEsex2rFpbaCNaFUPSxrxSVhFsECrjUH7FvnJM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n4Tlm-000P9l-D9; Mon, 03 Jan 2022 21:17:26 +0100
Date:   Mon, 3 Jan 2022 21:17:26 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Maxime Bizon <mbizon@freebox.fr>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: mdio: Demote probed message to debug print
Message-ID: <YdNZ1rusFT1OJFgh@lunn.ch>
References: <20220103194024.2620-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220103194024.2620-1-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 03, 2022 at 11:40:24AM -0800, Florian Fainelli wrote:
> On systems with large numbers of MDIO bus/muxes the message indicating
> that a given MDIO bus has been successfully probed is repeated for as
> many buses we have, which can eat up substantial boot time for no
> reason, demote to a debug print.
> 
> Reported-by: Maxime Bizon <mbizon@freebox.fr>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
