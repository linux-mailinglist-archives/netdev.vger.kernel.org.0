Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E540EC5D
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 23:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729566AbfD2V5z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 17:57:55 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49154 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729542AbfD2V5z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 17:57:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=8zklwnrrCxlV6imkBjgMMGQN1ayXPJGlDBsi4KdrCXA=; b=zxPOEY4ROf7kWkKHX8rXdPiLQL
        HOGH8gnh70hcBI5obBZNqiyRn/R7QHSozcJQrOZ9vpU5l5VHp1H2aixjoehjJosjjYgiBfuATyWxs
        7B4/Qtk4BaR1ER5xRkDMYI3H6ledmregvTnfQmWSTnbICjA3QsDNA8hz1lrKlbJ4Kej4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hLEHZ-00075M-Kr; Mon, 29 Apr 2019 23:57:53 +0200
Date:   Mon, 29 Apr 2019 23:57:53 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 11/13] net: dsa: b53: Let DSA call
 .port_vlan_filtering only when necessary
Message-ID: <20190429215753.GJ12333@lunn.ch>
References: <20190428184554.9968-1-olteanv@gmail.com>
 <20190428184554.9968-12-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190428184554.9968-12-olteanv@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 28, 2019 at 09:45:52PM +0300, Vladimir Oltean wrote:
> Since DSA has recently learned to treat better with drivers that set
> vlan_filtering_is_global, doing this is no longer required.
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
