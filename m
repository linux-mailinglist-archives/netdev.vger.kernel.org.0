Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2AB1374A4
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 14:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727438AbfFFM6V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 08:58:21 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:32964 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726157AbfFFM6V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 08:58:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=SZ7deo/igterVT9awcivGmBBu1yyI/gcCsbHOXYSJyY=; b=lWBt6DwsboN3nJNI0r2uZS36zx
        q1UKESbOpuSKISJlTbwlCRv+hwsK8J472AVR8Yb76AKXzH9NWpUf9UDsR6z1ezQYHTIEg0EdYYqYD
        X6Ot9qsp1jVS9zPpjAZB/Su4CZ/GPVDX090mynJWxoSxaQmRmlxO6sjARIsQp8NKoRz0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hYryD-0005pn-7f; Thu, 06 Jun 2019 14:58:17 +0200
Date:   Thu, 6 Jun 2019 14:58:17 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Schmitz <schmitzmic@gmail.com>,
        Anders Roxell <anders.roxell@linaro.org>
Cc:     f.fainelli@gmail.com, hkallweit1@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH 6/8] drivers: net: phy: fix warning same module names
Message-ID: <20190606125817.GF20899@lunn.ch>
References: <20190606094727.23868-1-anders.roxell@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190606094727.23868-1-anders.roxell@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 06, 2019 at 11:47:26AM +0200, Anders Roxell wrote:
> When building with CONFIG_ASIX_PHY and CONFIG_USB_NET_AX8817X enabled as
> loadable modules, we see the following warning:
> 
> warning: same module names found:
>   drivers/net/phy/asix.ko
>   drivers/net/usb/asix.ko
> 
> Rework so media coda matches the config fragment. Leaving

No media coda here.

> CONFIG_USB_NET_AX8817X as is since thats a well known module.

Again, place base on net-next and submit to just netdev.

Please rename the PHY driver asix88796.

       Andrew
