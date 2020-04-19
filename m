Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD29C1AFBB1
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 17:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbgDSPX6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 11:23:58 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48370 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725927AbgDSPX6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Apr 2020 11:23:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=lsLELrwaofLip2XAWAfI9ySowP/arKMXLpa6WEGNA6A=; b=yHaLJ9v+G+2B6ARnZtlNr8lixn
        lxOyiTpIQ5sfXl5h8OJnjy+kNdW8KklHDcmKfDlHsUzKv2nedEteZhelqyoC9Y1Hnd/7AEjDPyLIs
        C8HMPfllSdWVJ47eYs6A2FvHVzSs9rYqbVRGmKvxYwCgc0DQ/geCJFLnNrGAv1NBQ8j4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jQBnW-003eOq-I7; Sun, 19 Apr 2020 17:23:54 +0200
Date:   Sun, 19 Apr 2020 17:23:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next] net: phy: mscc: use mdiobus_get_phy()
Message-ID: <20200419152354.GI836632@lunn.ch>
References: <20200419082757.5650-1-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200419082757.5650-1-michael@walle.cc>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 19, 2020 at 10:27:57AM +0200, Michael Walle wrote:
> Don't use internal knowledge of the mdio bus core, instead use
> mdiobus_get_phy() which does the same thing.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>

Thanks Michael

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
