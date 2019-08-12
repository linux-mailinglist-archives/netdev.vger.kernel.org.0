Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F83B8A983
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 23:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbfHLVkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 17:40:23 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54578 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726890AbfHLVkX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Aug 2019 17:40:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=073T1j9SbEOQe7TzVYcOHVU8aBKmZL4n2h+IQS3Ibo0=; b=HlfrKdVXTiFlwT+ynx14FOM/1h
        az/RPgudDHY+YGjz7GgTd0P52upRw6NxIvYkpLwJyPqeGE6lLJIzL39L8wlLP2vC/4CxCh5eEeKOw
        n3iwdzMRzByHI5HmJtIMIkNl/sfCiOBybRk8NwfupcxrVk6D+LQY8yhC9kZZHo83EZ/Q=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hxI38-0004Za-JL; Mon, 12 Aug 2019 23:40:18 +0200
Date:   Mon, 12 Aug 2019 23:40:18 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 3/3] net: phy: let phy_speed_down/up support
 speeds >1Gbps
Message-ID: <20190812214018.GD15047@lunn.ch>
References: <0799ec1f-307c-25ab-0259-b8239e4e04ba@gmail.com>
 <e6f96369-aa6e-19f3-76af-5e9d6df03aab@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e6f96369-aa6e-19f3-76af-5e9d6df03aab@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 12, 2019 at 11:20:51PM +0200, Heiner Kallweit wrote:
> So far phy_speed_down/up can be used up to 1Gbps only. Remove this
> restriction by using new helper __phy_speed_down. New member adv_old
> in struct phy_device is used by phy_speed_up to restore the advertised
> modes before calling phy_speed_down. Don't simply advertise what is
> supported because a user may have intentionally removed modes from
> advertisement.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
