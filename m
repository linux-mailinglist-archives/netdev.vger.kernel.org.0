Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBB0F37482
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 14:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727828AbfFFMue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 08:50:34 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:32912 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727460AbfFFMue (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 08:50:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=C9AhrpQQzf2srSX2hULA4Orak17VDtxBq6HDzH2Jjk4=; b=R0T66vDOIrQJclydq9hXYnOiwq
        YAumgGqzmJcLmP9aJNXd42LqTISLlbcWraZNMpkBqo9WtqfqJ3bIJ2u07rhsJn5X8mbg1b9hHJaRZ
        BKZaVNH4ldecMPzVoVatIxa5X7bwV3AOGHcNeQgAviCh/zV+GlWg85Ly1t/ZjlGSKBuY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hYrqa-0005jD-V0; Thu, 06 Jun 2019 14:50:24 +0200
Date:   Thu, 6 Jun 2019 14:50:24 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Anders Roxell <anders.roxell@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Cc:     vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, hkallweit1@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH 1/8] drivers: net: dsa: realtek: fix warning same module
 names
Message-ID: <20190606125024.GE20899@lunn.ch>
References: <20190606094707.23664-1-anders.roxell@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190606094707.23664-1-anders.roxell@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 06, 2019 at 11:47:07AM +0200, Anders Roxell wrote:
> When building with CONFIG_NET_DSA_REALTEK_SMI and CONFIG_REALTEK_PHY
> enabled as loadable modules, we see the following warning:
> 
> warning: same module names found:
>   drivers/net/phy/realtek.ko
>   drivers/net/dsa/realtek.ko
> 
> Rework so the names matches the config fragment.
> 
> Signed-off-by: Anders Roxell <anders.roxell@linaro.org>

[Removes most of the Cc:]

Hi Anders

Please base this patch on net-next and submit it to David
Miller/netdev.

It would also be nice to state the new name of the module in the
commit message.

Linus, would you prefer this module is called rtl8366?

       Andrew
