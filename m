Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6950A5001A
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 05:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbfFXDQ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 23:16:27 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51392 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726307AbfFXDQ1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 Jun 2019 23:16:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=pN5JtKTBb/CdrguX3RdYOtOb5Dhbf4+HpOASRUddu6I=; b=O046KX5UZYv44mQBZkrZ4srWvP
        blJIJuzU5x9r/Ytwvg0gJBTHjgMqCE3POi2MU7nA6sQ2+TLpt0rImqWpgAM/2c4jXnzBhBtfJaWiM
        2Cg34VlWiCFfRTA/TxWALvqLGLECsRNdiOKtzsz174fCxUII+ObpxfMgA+IgV+wDTzh8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hfFT0-0002Ps-0p; Mon, 24 Jun 2019 05:16:26 +0200
Date:   Mon, 24 Jun 2019 05:16:26 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <Woojung.Huh@microchip.com>
Subject: Re: [PATCH V3 03/10] net: dsa: microchip: Inline ksz_spi.h
Message-ID: <20190624031626.GJ28942@lunn.ch>
References: <20190623223508.2713-1-marex@denx.de>
 <20190623223508.2713-4-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190623223508.2713-4-marex@denx.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 24, 2019 at 12:35:01AM +0200, Marek Vasut wrote:
> The functions in the header file are static, and the header file is
> included from single C file, just inline the code into the C file.
> The bonus is that it's easier to spot further content to clean up.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
