Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCA1637424
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 14:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727200AbfFFMbg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 08:31:36 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:32846 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726717AbfFFMbg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 08:31:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Jo6Tmg4pvieILZHo8tyQ1s4OK99AtSkCw1lYnoB5rDs=; b=lnQQoAZVlOUD1c7zBTQJJsjINb
        Dinr/f9ju6LS0UFiumfi1NvEEy06YFBR76vKSSyycSrLpG74GgV8TLZkeN9Sk4blz4WqJf6Vux0qy
        aGzHFYkn1EDa5kKb4MamFwgq2bYAJC4cREZxoIZ13Gy+7j4UIKHTXiI04iJW7TZaBYxo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hYrYK-0005a2-N1; Thu, 06 Jun 2019 14:31:32 +0200
Date:   Thu, 6 Jun 2019 14:31:32 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     David Miller <davem@davemloft.net>, f.fainelli@gmail.com,
        hkallweit1@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH] net: phy: marvell10g: allow PHY to probe without firmware
Message-ID: <20190606123132.GC20899@lunn.ch>
References: <E1hYTO0-0000MZ-2d@rmk-PC.armlinux.org.uk>
 <20190605.184827.1552392791102735448.davem@davemloft.net>
 <20190606075919.ysofpcpnu2rp3bh4@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190606075919.ysofpcpnu2rp3bh4@shell.armlinux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> This link notifier change also screws up my long-standing patches
> to add support for SFP for the PHYs on Macchiatobin which I was
> going to post next.

Hi Russell

Is that with the SFP hanging off the Marvell 10G PHY? We are seeing
that sort of chain more often, so it is something i would like to see
supported. Lets try to figure this out, maybe revert part of Heiners
change.

	Andrew
