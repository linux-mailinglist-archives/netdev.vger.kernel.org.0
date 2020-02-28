Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01CBA1742D8
	for <lists+netdev@lfdr.de>; Sat, 29 Feb 2020 00:14:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbgB1XOq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 18:14:46 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:34064 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbgB1XOp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 18:14:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=8pDsHz6RetCNui6JYWKr66Fx8NY1FuyyASaCfvg/lxg=; b=XvmPksJeCDRXQQ5cf5W6h+Oyq
        07ckpCnqKtXSeEZHq0eDZjLkdffizLd1S1gB8DyrRI+E7yTcx29QP5VTQqjOhsXngaXGCncZj7FCU
        GV9Uj6UZvOljifCkTCmiGkq5WEKu+tQcukwSjaT6xeJVNwyIGSS3zGpwYwAZzWZ9y7MjlkRYkKC+x
        NT19YcagLlX7y/IukSvsABe8EeZr3xuT3uNFWvFDi+CXmQR0dS65zJ6i5vCq4JO8KZwRnNhSLCvIc
        F+9VR5aYhdF3Wpe7F2kuCzk6ZsSbhkSIVYZamt0gFxkagG/n1sNUSJs2o6kZ3fNP+/sbqhjGNdahW
        Ez8iyOR+g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58244)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1j7oq3-0006ca-Vk; Fri, 28 Feb 2020 23:14:36 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1j7oq1-0002N1-7N; Fri, 28 Feb 2020 23:14:33 +0000
Date:   Fri, 28 Feb 2020 23:14:33 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Chris Snook <chris.snook@gmail.com>,
        Jay Cliburn <jcliburn@gmail.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH v9] net: ag71xx: port to phylink
Message-ID: <20200228231433.GW25745@shell.armlinux.org.uk>
References: <20200228145049.17602-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200228145049.17602-1-o.rempel@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 28, 2020 at 03:50:49PM +0100, Oleksij Rempel wrote:
> The port to phylink was done as close as possible to initial
> functionality.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Looks fine from a phylink point of view now, thanks.

Acked-by: Russell King <rmk+kernel@armlinux.org.uk>

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
