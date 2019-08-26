Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2829D2BD
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 17:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732309AbfHZP2Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 11:28:16 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60008 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731140AbfHZP2Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Aug 2019 11:28:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ekdmEqrUVEuT4oxGG7je8cfbO8K1QZsH1d2p5q9f9Ek=; b=wnWCkWRy22A93Br12ApntCuGM4
        dD+9jPLCV4J4LHDJo7wwLy+InH8bcpgYJvs4Z39NdHIZjcWyF2O4NCd1JuThobRRcUQCewrYQY7LZ
        +Zztmapveh4Kz7147sHmyypulbmUBtvsRvevlbT8GkyX5X5sYvXzwaoOHFt238twVF/s=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i2Guk-0004aI-B7; Mon, 26 Aug 2019 17:28:14 +0200
Date:   Mon, 26 Aug 2019 17:28:14 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next v4 3/6] net: dsa: mv88e6xxx: create
 serdes_get_lane chip operation
Message-ID: <20190826152814.GC2168@lunn.ch>
References: <20190826122109.20660-1-marek.behun@nic.cz>
 <20190826122109.20660-4-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190826122109.20660-4-marek.behun@nic.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -int mv88e6390x_serdes_get_lane(struct mv88e6xxx_chip *chip, int port)
> +int mv88e6390x_serdes_get_lane(struct mv88e6xxx_chip *chip, int port, s8 *lane)
>  {
>  	u8 cmode_port9, cmode_port10, cmode_port;
>  
> @@ -323,76 +320,80 @@ int mv88e6390x_serdes_get_lane(struct mv88e6xxx_chip *chip, int port)
>  	cmode_port10 = chip->ports[10].cmode;
>  	cmode_port = chip->ports[port].cmode;
>  
> +	*lane = -1;
> +

You could move that into mv88e8xxx_serdes_get_lane().

Otherwise

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
