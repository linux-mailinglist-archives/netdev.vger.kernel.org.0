Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09B5626A91
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 21:09:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729662AbfEVTJ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 15:09:29 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43679 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728761AbfEVTJ3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 15:09:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=7zIjDb7T7T6xkFJh7EgUs0BE9C37GDXhMMWbFqF9e2M=; b=0wHDQANylj2A8sv+nAvbtBeejX
        ffcX/6Tv5rhjhA4Dd7KBEDThTEW1bLqk7B84NGLIIlCHqlTdY8BAXHnDPPSmhxlPjWLoOGzAp3doE
        bMiSXC1XeTSDDiz0ZWuSRj4IYeE4kM/CTOTmm47uCEVYU/oxYgSRiQv81dskUcy4a/ao=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hTWcC-0002Rq-2o; Wed, 22 May 2019 21:09:28 +0200
Date:   Wed, 22 May 2019 21:09:28 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Trent Piepho <tpiepho@impinj.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next v2 8/8] net: phy: dp83867: Allocate state struct
 in probe
Message-ID: <20190522190928.GF7281@lunn.ch>
References: <20190522184255.16323-1-tpiepho@impinj.com>
 <20190522184255.16323-8-tpiepho@impinj.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190522184255.16323-8-tpiepho@impinj.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 22, 2019 at 06:43:27PM +0000, Trent Piepho wrote:
> This was being done in config the first time the phy was configured.
> Should be in the probe method.
> 
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: Heiner Kallweit <hkallweit1@gmail.com>
> Signed-off-by: Trent Piepho <tpiepho@impinj.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
