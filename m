Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CA99332D7
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 16:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729186AbfFCO5t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 10:57:49 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50710 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728882AbfFCO5t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jun 2019 10:57:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=nMmMLyY2wEe5mWxFYfJb9I4vcVoHvhNf68CYZFM42uk=; b=CPjDhy34HoELRaZtg04tonm0u6
        EY75gQhD1ZpN35ePf3FdkH0uzZruwLmIZRDl/rBTKB2H900ruQFUEI3/0HJCG0Ghy1AOgOVP0iA2c
        w5S9Wn5g0fgFgI3l9+GellAYunm6QvJ433kfRXYyQ7p/Aq7mF9lsr0p1c5Kdsi+O6ps0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hXoP9-0005uz-EO; Mon, 03 Jun 2019 16:57:43 +0200
Date:   Mon, 3 Jun 2019 16:57:43 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rasmus Villemoes <Rasmus.Villemoes@prevas.se>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v3 01/10] net: dsa: mv88e6xxx: add
 mv88e6250_g1_ieee_pri_map
Message-ID: <20190603145743.GD19627@lunn.ch>
References: <20190603144112.27713-1-rasmus.villemoes@prevas.dk>
 <20190603144112.27713-2-rasmus.villemoes@prevas.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190603144112.27713-2-rasmus.villemoes@prevas.dk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 03, 2019 at 02:42:12PM +0000, Rasmus Villemoes wrote:
> diff --git a/drivers/net/dsa/mv88e6xxx/global1.h b/drivers/net/dsa/mv88e6xxx/global1.h
> index bb92a130cbef..2bcbe7c8b279 100644
> --- a/drivers/net/dsa/mv88e6xxx/global1.h
> +++ b/drivers/net/dsa/mv88e6xxx/global1.h
> @@ -279,6 +279,8 @@ int mv88e6390_g1_mgmt_rsvd2cpu(struct mv88e6xxx_chip *chip);
>  int mv88e6085_g1_ip_pri_map(struct mv88e6xxx_chip *chip);
>  int mv88e6085_g1_ieee_pri_map(struct mv88e6xxx_chip *chip);
>  
> +int mv88e6250_g1_ieee_pri_map(struct mv88e6xxx_chip *chip);
> +

Hi Rasmus

We are not 100% consistent, but we try to put all variants of a method
together, and then put a blank line afterwards. So could you make
this:

int mv88e6085_g1_ip_pri_map(struct mv88e6xxx_chip *chip);

int mv88e6085_g1_ieee_pri_map(struct mv88e6xxx_chip *chip);
int mv88e6250_g1_ieee_pri_map(struct mv88e6xxx_chip *chip);

int mv88e6185_g1_set_cascade_port(struct mv88e6xxx_chip *chip, int port);

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

