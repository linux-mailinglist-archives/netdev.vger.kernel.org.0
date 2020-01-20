Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA621433CD
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 23:17:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbgATWRT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 17:17:19 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:47378 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726607AbgATWRS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jan 2020 17:17:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=k3r5so1+FvX6syvDt82yhglyIZGT07NIcVpB9vyX6so=; b=jLW1I1HI4A/IkBmJ+bGa7BawhN
        Laing4q+DJtlsGU0w5mtdq5RUxjD0GRkGVf19PEqAIidtmczlaVC8rYjn41Y0M0h3Iqk2E03h9fWq
        fCxwpX6Mu6WPREw+bawQkpE/FcH/JTaCL9v21wxvYSJgqjNKfbaAYpYJySOQZ1+KjrAU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1itfMC-0001dK-Ln; Mon, 20 Jan 2020 23:17:16 +0100
Date:   Mon, 20 Jan 2020 23:17:16 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        Mark Einon <mark.einon@gmail.com>,
        Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 2/3] net: phy: add new version of phy_do_ioctl
Message-ID: <20200120221716.GE1466@lunn.ch>
References: <a7a6dc1f-b4d4-e36f-7408-31e4715d947f@gmail.com>
 <9ed8f7eb-c2b7-ae14-c3b3-83b0aee655c4@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9ed8f7eb-c2b7-ae14-c3b3-83b0aee655c4@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 20, 2020 at 10:17:11PM +0100, Heiner Kallweit wrote:
> Add a new version of phy_do_ioctl that doesn't check whether net_device
> is running. It will typically be used if suitable drivers attach the
> PHY in probe already.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
