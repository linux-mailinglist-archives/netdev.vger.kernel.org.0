Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D99BF2489
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 02:50:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732577AbfKGBuG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 20:50:06 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:53076 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727328AbfKGBuG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Nov 2019 20:50:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=GYjQWq1yeWTOVFMX0wEXq/giClGs21U1rCBf6jNgeO0=; b=W00jCUASnPQjug9QpB/SnJ/Hsm
        J1utV3yhfatlW/Nuo2/PSDorRwnV4UWJp7bJVxU++779lkdSqlFNyaSX5fATYu2u3DbtkDwndfLc8
        RCo1WSbSrV5HRL5leZVvStvMJbfe6RxCpOI9/8TCS3/k0FH78KWxNI5JN2q36up6qMtY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iSWvz-0002i3-FG; Thu, 07 Nov 2019 02:50:03 +0100
Date:   Thu, 7 Nov 2019 02:50:03 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, Rob Herring <robh@kernel.org>,
        David Miller <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Simon Horman <simon.horman@netronome.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH v2 1/6] net: phy: at803x: fix Kconfig description
Message-ID: <20191107015003.GB8978@lunn.ch>
References: <20191106223617.1655-1-michael@walle.cc>
 <20191106223617.1655-2-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191106223617.1655-2-michael@walle.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 06, 2019 at 11:36:12PM +0100, Michael Walle wrote:
> The name of the PHY is actually AR803x not AT803x. Additionally, add the
> name of the vendor and mention the AR8031 support.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
