Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8320F9D266
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 17:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732928AbfHZPNh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 11:13:37 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59958 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732908AbfHZPNh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Aug 2019 11:13:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=xjOV5S9SAyl37qb9P12m0i6tKRdc5ijmgkhnR7b5i4w=; b=xqk1PNSDJOOAfT7xBaJxFRiJbK
        aAOjlymmjM5RcU6cOTZZLnpHKgGZNWdKI8MEMe5+LkxTm9YQa8q3++1hfscIuklYVF4WLxh8AJQM4
        7+pcjt8SaGmhILdzECjkxZSjE0qplxOTv6MQraPHI+aqscBB591yKCnjjz6d51k/za98=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i2GgZ-0004Uz-D7; Mon, 26 Aug 2019 17:13:35 +0200
Date:   Mon, 26 Aug 2019 17:13:35 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next v4 1/6] net: dsa: mv88e6xxx: support 2500base-x
 in SGMII IRQ handler
Message-ID: <20190826151335.GA2168@lunn.ch>
References: <20190826122109.20660-1-marek.behun@nic.cz>
 <20190826122109.20660-2-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190826122109.20660-2-marek.behun@nic.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 26, 2019 at 02:21:04PM +0200, Marek Behún wrote:
> The mv88e6390_serdes_irq_link_sgmii IRQ handler reads the SERDES PHY
> status register to determine speed, among other things. If cmode of the
> port is set to 2500base-x, though, the PHY still reports 1000 Mbps (the
> PHY register itself does not differentiate between 1000 Mbps and 2500
> Mbps - it thinks it is running at 1000 Mbps, although clock is 2.5x
> faster).
> Look at the cmode and set SPEED_2500 if cmode is set to 2500base-x.
> Also tell mv88e6xxx_port_setup_mac the PHY interface mode corresponding
> to current cmode in terms of phy_interface_t.
> 
> Signed-off-by: Marek Behún <marek.behun@nic.cz>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
