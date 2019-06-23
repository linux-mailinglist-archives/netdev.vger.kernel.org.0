Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D99A24FC1A
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 17:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726688AbfFWPKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 11:10:11 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50418 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726429AbfFWPKL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 Jun 2019 11:10:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=IO5tmHeadorcE+P35N8tcKL7t7IKeZsUryZrWBq54N4=; b=jBIBDwZacBhgUqZNfDptNAN8b7
        9dPmt62+CiBjSByUpemi42jOKFFb1CCP9s9F8blNhYAxBAvFsLjhFF6H3t6uYh8U6eQjIQsJxbRY+
        Kveia+A/YSaw76qveJuCmwtGYpuQpYa8j43Jw8oGlEn/Jw4GaiyflscAyhnEJbL4Vqk4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hf47z-0007ti-EI; Sun, 23 Jun 2019 17:09:59 +0200
Date:   Sun, 23 Jun 2019 17:09:59 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <Woojung.Huh@microchip.com>
Subject: Re: [PATCH] net: dsa: microchip: Use gpiod_set_value_cansleep()
Message-ID: <20190623150959.GC28942@lunn.ch>
References: <20190623121036.3430-1-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190623121036.3430-1-marex@denx.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 23, 2019 at 02:10:36PM +0200, Marek Vasut wrote:
> Replace gpiod_set_value() with gpiod_set_value_cansleep(), as the switch
> reset GPIO can be connected to e.g. I2C GPIO expander and it is perfectly
> fine for the kernel to sleep for a bit in ksz_switch_register().
> 
> Signed-off-by: Marek Vasut <marex@denx.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
