Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC5E01D3782
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 19:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbgENRGR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 13:06:17 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60656 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726038AbgENRGR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 May 2020 13:06:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=I2i8OSobiwsG3jLNtOop/2XBg2yXj5Met80Vd6NpExk=; b=YO9bKux4ywjUTzlbzIa0sVM6Qq
        HMHmHMGOWCUNIosE5WOPCryq68cs1NnjIydwTJfKwD5SZzOnwcTH5JK8KcqyPLxEpteAv8HB+p2fD
        I8ngCPS1dcRKNzvGhtgZVpmXD4g0fDMtq41ExbeCoa40MSuoDjvug5/veF47F2RBmulg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jZHJA-002J0N-Bq; Thu, 14 May 2020 19:06:08 +0200
Date:   Thu, 14 May 2020 19:06:08 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Bartosz Golaszewski <brgl@bgdev.pl>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: Re: [PATCH] net: phy: mdio-moxart: remove unneeded include
Message-ID: <20200514170608.GV499265@lunn.ch>
References: <20200514165938.21725-1-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200514165938.21725-1-brgl@bgdev.pl>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 14, 2020 at 06:59:38PM +0200, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> 
> mdio-moxart doesn't use regulators in the driver code. We can remove
> the regulator include.
> 
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
