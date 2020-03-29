Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1343E196E1A
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 17:11:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728267AbgC2PLE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 11:11:04 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37500 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728080AbgC2PLE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 29 Mar 2020 11:11:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=vQbObUe3VlY0H+Dq+CGZFCMyrsyP08QLn+rjVDv/ThQ=; b=mW0Vxjnx4EvmqiXVvo45OIILEL
        96NTbizyiDcynk99DsWhVQryTRvlvwl81ZJQEPDkur3vf4uVS30YX1aEL/n0/u4KVfru4r5xnhhPs
        gWqtbyu7DtHpFG82wXA5IQKiCfCYmDKlO+kQOpGV4lQB2R08vsu+ZhJKjuHkP6FVxAD0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jIZaV-0004PD-CP; Sun, 29 Mar 2020 17:10:59 +0200
Date:   Sun, 29 Mar 2020 17:10:59 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 2/2] net: phylink: add separate pcs operations
 structure
Message-ID: <20200329151059.GB31812@lunn.ch>
References: <20200326151458.GC25745@shell.armlinux.org.uk>
 <E1jHUEd-0007UX-Pm@rmk-PC.armlinux.org.uk>
 <DB8PR04MB6828E4768064062D959BF4EDE0CF0@DB8PR04MB6828.eurprd04.prod.outlook.com>
 <20200329114741.GZ25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200329114741.GZ25745@shell.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The pcs_config() method should set the PCS according to the interface
> mode (state->interface) and the advertisement (state->advertising).
> Nothing else should be used. I suppose I should pass those explicitly
> rather than the whole state structure to prevent any mis-use.

Hi Russell

I think that has been a learning from phylink so far. Only pass what
you are supposed to act on, nothing more.

    Andrew
