Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B21A778D1F
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 15:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728287AbfG2Np5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 09:45:57 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44786 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727632AbfG2Np5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 09:45:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=3Z/kfa9fM3G4V3a6xOuotsKa6lAoDW+2j1EfLl7AEuU=; b=Hy53qEOjo79ssYqLSRDTY4m1D+
        jAAhCFM/KVIVhnYg4OdMgJDqJMzmxs3bA6JZnlmlzw4U/A8LOduOw0jX6KtRmC7UHzLIetv8MB7Mp
        qz/Rt3WWfTMWcwWjpyqhKMI5luFT+cJLYh+TgXPLu4qiB1gQjyQyQIbhzh6aor9e8lBY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hs5yL-0001QT-BW; Mon, 29 Jul 2019 15:45:53 +0200
Date:   Mon, 29 Jul 2019 15:45:53 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jia-Ju Bai <baijiaju1990@gmail.com>
Cc:     f.fainelli@gmail.com, hkallweit1@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: phy_led_triggers: Fix a possible null-pointer
 dereference in phy_led_trigger_change_speed()
Message-ID: <20190729134553.GC4110@lunn.ch>
References: <20190729092424.30928-1-baijiaju1990@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190729092424.30928-1-baijiaju1990@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 29, 2019 at 05:24:24PM +0800, Jia-Ju Bai wrote:
> In phy_led_trigger_change_speed(), there is an if statement on line 48
> to check whether phy->last_triggered is NULL: 
>     if (!phy->last_triggered)
> 
> When phy->last_triggered is NULL, it is used on line 52:
>     led_trigger_event(&phy->last_triggered->trigger, LED_OFF);
> 
> Thus, a possible null-pointer dereference may occur.
> 
> To fix this bug, led_trigger_event(&phy->last_triggered->trigger,
> LED_OFF) is called when phy->last_triggered is not NULL.
> 
> This bug is found by a static analysis tool STCheck written by us.

Who is 'us'? 

Thanks
    Andrew
