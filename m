Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AFB7E1F97
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 17:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406845AbfJWPk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 11:40:27 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59836 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406841AbfJWPk1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Oct 2019 11:40:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=15znUTheX3hlcNilQtbUhzbHXYgrjg4e2vdUTc1SahE=; b=olanxhdXsw5ZEvvZTD6ifaDlLv
        1yF/8BJLAJfHTbG4ccmRz2qgl0iuWPhwqavirOM3SPrXsDLuDMAFcn+lcwt0zhihspoZUzXAqga3e
        8GoQHiUSA00iXRYVqXsi0VdcpBxxLx2rW54991rGeqy+IwxgH1qtmKy4bxE+UFi0xSKY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iNIkK-0007OU-0f; Wed, 23 Oct 2019 17:40:24 +0200
Date:   Wed, 23 Oct 2019 17:40:24 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Martin Fuzzey <martin.fuzzey@flowbird.group>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] net: phy: smsc: LAN8740: add PHY_RST_AFTER_CLK_EN flag
Message-ID: <20191023154024.GC13748@lunn.ch>
References: <1571823889-16834-1-git-send-email-martin.fuzzey@flowbird.group>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1571823889-16834-1-git-send-email-martin.fuzzey@flowbird.group>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 23, 2019 at 11:44:24AM +0200, Martin Fuzzey wrote:
> The LAN8740, like the 8720, also requires a reset after enabling clock.
> The datasheet [1] 3.8.5.1 says:
> 	"During a Hardware reset, an external clock must be supplied
> 	to the XTAL1/CLKIN signal."
> 
> I have observed this issue on a custom i.MX6 based board with
> the LAN8740A.
> 
> [1] http://ww1.microchip.com/downloads/en/DeviceDoc/8740a.pdf
> 
> Signed-off-by: Martin Fuzzey <martin.fuzzey@flowbird.group>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
