Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD8621090AA
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 16:05:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728435AbfKYPFj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 10:05:39 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:55284 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727758AbfKYPFi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Nov 2019 10:05:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=kL/NxAwTIHrp6OepzLGhc/+r09raDM7wPdlEVc2W7qw=; b=LcY0QYdP6iIONr8NFw56no/jE3
        SxFUuWvqkDqCP5kczwp7c4V/jw/H47xamFxnnTegJlvD6XiC6MvmqydIMYzj26X/LGiobdQZpL6qm
        LQ+GFwYQWia4TUfv95yjQEIFvIHbIHoi2W9BwxfRxoro5ynk5I5oJdMhG6DV+DOUDseY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iZFvg-0007to-Tv; Mon, 25 Nov 2019 16:05:32 +0100
Date:   Mon, 25 Nov 2019 16:05:32 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     mkl@pengutronix.de, Vladimir Oltean <olteanv@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        david@protonic.nl
Subject: Re: [PATCH v1 1/2] net: dsa: sja1105: print info about probet chip
 only after every thing was done.
Message-ID: <20191125150532.GI6602@lunn.ch>
References: <20191125100259.5147-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191125100259.5147-1-o.rempel@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 25, 2019 at 11:02:58AM +0100, Oleksij Rempel wrote:
> Currently we will get "Probed switch chip" notification multiple times
> if first probe filed by some reason. To avoid this confusing notifications move
> dev_info to the end of probe.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

For net-next, this is O.K.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
