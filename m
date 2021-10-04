Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF93842198F
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 00:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234348AbhJDWDo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 18:03:44 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48490 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230517AbhJDWDn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 18:03:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Xo3ZwWiBT5AwUKnrSDAPovlmuNXZ4kITs98/NT/c3XI=; b=nchJAHa76h7RKFo1Gh89oZcoQH
        arCmiQwspY3GEudOaTVR0kSezyxDHA0zM4VrBrMgdB65v6UKsqQvICjvt6l+EscwHUw8IHczzcsum
        /6U1L0L5+w3ShKhUNHZM3Y8ClGucbLrHbKmt+fk9kpqKSVxiAnjjTTi26PvYK/ZCD59U=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mXW1r-009blq-OS; Tue, 05 Oct 2021 00:01:47 +0200
Date:   Tue, 5 Oct 2021 00:01:47 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Bauer <mail@david-bauer.net>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net: phy: at803x: add QCA9561 support
Message-ID: <YVt5yyHaqvkk+AUT@lunn.ch>
References: <20211004193633.730203-1-mail@david-bauer.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211004193633.730203-1-mail@david-bauer.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 04, 2021 at 09:36:33PM +0200, David Bauer wrote:
> Add support for the embedded fast-ethernet PHY found on the QCA9561
> WiSoC platform. It supports the usual Atheros PHY featureset including
> the cable tester.
> 
> Tested on a Xiaomi MiRouter 4Q (QCA9561)
> 
> Signed-off-by: David Bauer <mail@david-bauer.net>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
