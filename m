Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC58216751
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 18:02:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726805AbfEGQCP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 12:02:15 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57453 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726558AbfEGQCP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 May 2019 12:02:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=hiATCeqL1Vk6UfJELBlityqgqtEBUTQWReY+Ns7XMlM=; b=hsUFxknEqKaevkLO6Hqg7M81E/
        hN++7uHs97bcenWytbOeVLJObTsUUX15WYbiPogBQV8t5esmIJfD/GxsYtbcqnTCPIFxBiyrVbWP1
        j3I9oPnIw0ZOrqriz0qwsf8SiN/ZzLyPux/kZpKiZyHoXQ5Kxop4MhxKh7AM9+h4DLww=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hO2Xg-0001YL-NA; Tue, 07 May 2019 18:02:08 +0200
Date:   Tue, 7 May 2019 18:02:08 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     davem@davemloft.net, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        thomas.petazzoni@bootlin.com, gregory.clement@bootlin.com
Subject: Re: [PATCH net] dt-bindings: net: Fix a typo in the phy-mode list
 for ethernet bindings
Message-ID: <20190507160208.GF25013@lunn.ch>
References: <20190507153555.18545-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190507153555.18545-1-maxime.chevallier@bootlin.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 07, 2019 at 05:35:55PM +0200, Maxime Chevallier wrote:
> The phy_mode "2000base-x" is actually supposed to be "1000base-x", even
> though the commit title of the original patch says otherwise.
> 
> Fixes: 55601a880690 ("net: phy: Add 2000base-x, 2500base-x and rxaui modes")
> Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
