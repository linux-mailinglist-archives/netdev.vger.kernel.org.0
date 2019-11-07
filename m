Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1B4F24DA
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 03:04:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732732AbfKGCEk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 21:04:40 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:53114 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727328AbfKGCEk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Nov 2019 21:04:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=XsahgORl/nC9fQXSgVRroYjqg6suN/1vTL2xj6w2qsQ=; b=cSPzIBJDGna4Z7tnh9m1l3Adbf
        1ortmFg1/MKaNHHTvqEQ/ooaPQ8yfRu2OtCXOjcl4s2jICmOverdg87/KdWj3zLNILcwjaU+XVJ+T
        stBcu+x02pFH2OxvPrJThY1P8/EgTkyE5S3OaDjrofftUMecSYvGcmXaG5q/3QUb1DOM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iSXA4-0002l1-5k; Thu, 07 Nov 2019 03:04:36 +0100
Date:   Thu, 7 Nov 2019 03:04:36 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, Rob Herring <robh@kernel.org>,
        David Miller <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Simon Horman <simon.horman@netronome.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH v2 4/6] net: phy: at803x: mention AR8033 as same as AR8031
Message-ID: <20191107020436.GD8978@lunn.ch>
References: <20191106223617.1655-1-michael@walle.cc>
 <20191106223617.1655-5-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191106223617.1655-5-michael@walle.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 06, 2019 at 11:36:15PM +0100, Michael Walle wrote:
> The AR8033 is the AR8031 without PTP support. All other registers are
> the same. Unfortunately, they share the same PHY ID. Therefore, we
> cannot distinguish between the one with PTP support and the one without.

Not nice. I suppose there might be a PTP register you can read to
determine this, but that is not very helpful.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
