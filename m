Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE79517AECD
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 20:12:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbgCETMj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 14:12:39 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:48096 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725938AbgCETMj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Mar 2020 14:12:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=h67053e3GQZcXg88CcYOhc4TnvgW/ENJz3X2b8uU9C8=; b=AyxO0YDnehh1AX8Vjly9u6kmyu
        XYVcSzPS/O7zlv6HRbzv+hzj3H8shcfDlRwuxmOoS67qlZ8f71Pj9eN69jsbajlQorW3AuaaxcJ/I
        ESZFGi9TAwTP/TMv0FCGPM08sr+ngVAXf+Dk/ovXrUNQ5v1GuXIDbbCeOIw7+HhretGo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j9vv8-0007am-U8; Thu, 05 Mar 2020 20:12:34 +0100
Date:   Thu, 5 Mar 2020 20:12:34 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Markus Moll <moll.markus@arcor.de>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 1/3] dt-bindings: net: Add dp83867 LED mode constants
Message-ID: <20200305191234.GB25183@lunn.ch>
References: <2045683506.315295.1583319126809@mail.vodafone.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2045683506.315295.1583319126809@mail.vodafone.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 04, 2020 at 11:52:06AM +0100, Markus Moll wrote:
> These values reflect the register settings of LEDCR1, which maps PHY
> status signals to LED pins.

Hi Markus

We just rejected a similar patchset, for the marvell 10G PHY.

https://www.spinics.net/lists/netdev/msg633789.html

We need to be consistent and also reject this :-(

	Andrew
