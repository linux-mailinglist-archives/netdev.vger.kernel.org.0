Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 693BA139250
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 14:38:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728759AbgAMNiw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 08:38:52 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:34492 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726943AbgAMNiw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jan 2020 08:38:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=+Z0pz3KfeMyLH+UTXt/OUZ5kMoKnctYdxB0u0qFC/2U=; b=eXv14xc20fryNmPk21QEcO9gvt
        I7GK3ybBYmUrG6XEk6tOFs35ifRI9TjqpHgKcU0Q+Mnkm7BOcyllboN+KDxdMZXjyB4UA8uv5pXaM
        C0RoIQ4PRiQS6MIci3hRsJucMwMzD0uFGwZj3BrBZ58S2rTUf4MGpD8bpj8VHYFZeHqg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1iqzvZ-00041c-68; Mon, 13 Jan 2020 14:38:45 +0100
Date:   Mon, 13 Jan 2020 14:38:45 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     netdev@vger.kernel.org, Joao Pinto <Joao.Pinto@synopsys.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [RFC net-next] net: phy: Add basic support for Synopsys XPCS
 using a PHY driver
Message-ID: <20200113133845.GD11788@lunn.ch>
References: <4953fc69a26bee930bccdeb612f1ce740a4294df.1578921062.git.Jose.Abreu@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4953fc69a26bee930bccdeb612f1ce740a4294df.1578921062.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 13, 2020 at 02:11:08PM +0100, Jose Abreu wrote:
> Adds the basic support for XPCS including support for USXGMII.

Hi Jose

Please could you describe the 'big picture'. What comes after the
XPCS? An SFP? A copper PHY? How in Linux do you combine this PHY and
whatever comes next using PHYLINK?

Or do only support backplane with this, and the next thing in the line
is the peers XPCS?

Thanks
	Andrew
