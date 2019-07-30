Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F5297AA99
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 16:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730298AbfG3OJd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 10:09:33 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47866 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728769AbfG3OJd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jul 2019 10:09:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=lTtE/XJYw6H32/RhxGsmURhaXVkUR39iM2/kEC+BNiA=; b=wMLq/RzuiKa/yz4+tFl8J1cywl
        BWLMefAow1MDAwfsCqwJefskIwzP90lTewHhinOKKBTWy9tGii1XL6ULTC7WFJrW6DmH9AT6qEWnR
        qskAG2gz+pGwcfo1CxpzflJi6eP/pVHoJNtA8asDlcTAZ+IPRoGboEbVo+zx08+mcWXc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hsSok-0008AC-4c; Tue, 30 Jul 2019 16:09:30 +0200
Date:   Tue, 30 Jul 2019 16:09:30 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Hubert Feurstein <h.feurstein@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 1/2] net: dsa: mv88e6xxx: add support to setup
 led-control register through device-tree
Message-ID: <20190730140930.GM28552@lunn.ch>
References: <20190730101451.845-1-h.feurstein@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190730101451.845-1-h.feurstein@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 30, 2019 at 12:14:50PM +0200, Hubert Feurstein wrote:
> So it is possible to change the default behaviour of the switch LEDs.

Sorry, but this is not going to be accepted. There is an ongoing
discussion about PHY LEDs and how they should be configured. Switch
LEDs are no different from PHY LEDs. So they should use the same basic
concept.

Please take a look at the discussion around:

[RFC] dt-bindings: net: phy: Add subnode for LED configuration

Marvell designers have made this more difficult than it should be by
moving the registers out of the PHY address space and into the switch
address space. So we are going to have to implement this code twice
:-(

	Andrew
