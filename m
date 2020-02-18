Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27EBE161E9D
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 02:44:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726237AbgBRBog (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 20:44:36 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:50808 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726107AbgBRBog (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Feb 2020 20:44:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=sqBDQVQONiQrLI8S+vVekTbJI6pGivG4VfUTGpXty3M=; b=PVozJ/sE9WMP3Z6xttyIztjmeA
        Lce5SYjqeJuDh5xxZvdXi6iEmncwIVKiu8EvHwLiQbfwi2FdPLeYx+AbKnAyar+cowNC/RrTykiiK
        X8CDefnpCtwiRW6Fy0M7YisC1M4fURQfSM8hlTVhrv1hFDPAADpgHjsJs0rnhmNqzNro=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j3rw8-0000ce-28; Tue, 18 Feb 2020 02:44:32 +0100
Date:   Tue, 18 Feb 2020 02:44:32 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 3/4] net: phy: add resolved pause support
Message-ID: <20200218014432.GC2171@lunn.ch>
References: <20200217155346.GW25745@shell.armlinux.org.uk>
 <E1j3ij8-0006Ee-Lk@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1j3ij8-0006Ee-Lk@rmk-PC.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 17, 2020 at 03:54:30PM +0000, Russell King wrote:
> Allow phylib drivers to pass the hardware-resolved pause state to MAC
> drivers, rather than using the software-based pause resolution code.

Hi Russell

What i find missing here is an explanation of why hardware resolved
pause is better than software. We know what the software based method
is, and it will be consistent across all hardware. Can we say that
about the hardware?

Thanks
	Andrew
