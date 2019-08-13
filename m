Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE81E8C203
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 22:16:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbfHMUQn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 16:16:43 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58218 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725944AbfHMUQm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 16:16:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=UI6tMJpgEbq+gOgrpocJOsbqLUm7faizOZvfBoBgtZE=; b=FeSjjDYfiUTyS13m9LbRU3cCsN
        37Zbkng9V4MIGYsuKTjjKAVXkeloQMEDne6pDMldjVyXfIWGAgxR95kqQ3N+2puwUZ3ng8h9Ud9i8
        yUOFMcYCgphAbUdaOOoYKLu2udHOHuXxcH0O5j/k9YxoGwfy6JN0YLPrJ8fcV8vIwrC4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hxdDj-0004N8-FT; Tue, 13 Aug 2019 22:16:39 +0200
Date:   Tue, 13 Aug 2019 22:16:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2 2/3] net: phy: add phy_speed_down_core and
 phy_resolve_min_speed
Message-ID: <20190813201639.GN15047@lunn.ch>
References: <dca82a0e-e936-b60a-3a1c-9fdb1714d1d3@gmail.com>
 <d0c44f84-d441-9d4e-96e1-d8abb7c0e508@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d0c44f84-d441-9d4e-96e1-d8abb7c0e508@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 12, 2019 at 11:51:27PM +0200, Heiner Kallweit wrote:
> phy_speed_down_core provides most of the functionality for
> phy_speed_down. It makes use of new helper phy_resolve_min_speed that is
> based on the sorting of the settings[] array. In certain cases it may be
> helpful to be able to exclude legacy half duplex modes, therefore
> prepare phy_resolve_min_speed() for it.
> 
> v2:
> - rename __phy_speed_down to phy_speed_down_core
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
