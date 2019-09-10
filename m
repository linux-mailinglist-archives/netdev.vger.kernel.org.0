Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2382CAF10C
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 20:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727579AbfIJSbD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 14:31:03 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38760 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725875AbfIJSbD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Sep 2019 14:31:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=uWImonlZTirG53m0bJiDqQCpCDjtF16S/XlrxleM03M=; b=S9XVl9ZN6salg75A1Im7RrPWNX
        0aVe7Yto2lZ8YUWgZsq6aKvh6FrEr/f2zwwGHI+eaPb26T8r5BHjaPMgWTLHu3rvAwpaRG5MqfI64
        ufDr4+Gfm7JSAsegiaxpfyDfp5UHabGZ07VGqpi5cOFpatKEBIGUguS6XEdA73xi1WHc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i7kul-0002wi-RJ; Tue, 10 Sep 2019 20:30:55 +0200
Date:   Tue, 10 Sep 2019 20:30:55 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     George McCollister <george.mccollister@gmail.com>
Cc:     netdev@vger.kernel.org, Woojung Huh <woojung.huh@microchip.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Marek Vasut <marex@denx.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 2/3] net: dsa: microchip: add ksz9567 to
 ksz9477 driver
Message-ID: <20190910183055.GB9761@lunn.ch>
References: <20190910131836.114058-1-george.mccollister@gmail.com>
 <20190910131836.114058-3-george.mccollister@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190910131836.114058-3-george.mccollister@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 10, 2019 at 08:18:35AM -0500, George McCollister wrote:
> Add support for the KSZ9567 7-Port Gigabit Ethernet Switch to the
> ksz9477 driver. The KSZ9567 supports both SPI and I2C. Oddly the
> ksz9567 is already in the device tree binding documentation.
> 
> Signed-off-by: George McCollister <george.mccollister@gmail.com>
> Reviewed-by: Marek Vasut <marex@denx.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
