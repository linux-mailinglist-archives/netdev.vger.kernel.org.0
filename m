Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1332161E97
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 02:38:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726261AbgBRBi0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 20:38:26 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:50798 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726097AbgBRBi0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Feb 2020 20:38:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=paBA7kzoTSIKBomoCdE1yqgtn2WgsM4wURyW9X2uTbI=; b=Xs7rRUjXyQgTQkIMXufj5yXeZF
        Kq2wfl69jA2cDpRMCWLQ2W1qMmzfgZZKWGcbojCTwCIftGc+FRZXNYPc7p2pXSq/mt4hYvvnEUS4r
        MQTNKko/FjyMNAIJHxcNdBecInPu3VXmydOxF/XLA5nqbBpxoLujuqs5bID9dvcommks=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j3rqA-0000az-JT; Tue, 18 Feb 2020 02:38:22 +0100
Date:   Tue, 18 Feb 2020 02:38:22 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/4] net: phy: marvell: don't interpret PHY
 status unless resolved
Message-ID: <20200218013822.GB2171@lunn.ch>
References: <20200217155346.GW25745@shell.armlinux.org.uk>
 <E1j3ij3-0006ET-E3@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1j3ij3-0006ET-E3@rmk-PC.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 17, 2020 at 03:54:25PM +0000, Russell King wrote:
> Don't attempt to interpret the PHY specific status register unless
> the PHY is indicating that the resolution is valid.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
