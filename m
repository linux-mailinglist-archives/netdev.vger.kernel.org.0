Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 685E43D9021
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 16:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236694AbhG1OKz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 10:10:55 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49924 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236668AbhG1OKz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 10:10:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=dn7Kp73y2jWoHdQMYsqP+HDt7Jswx+VZ/Cd2d00WOak=; b=oDIUmU8rD1Z1i6GeQCvr9SAo2b
        op4tL38NAz23ewHcEPU8UnkGvI3vbXp0cQ873+q2r+zreVEB4JTlymNHLOkvyZc4Zmpw8+zCJERmi
        IKMZGsD0lniUXMd6+d9ed70GHGPOkiCcHI/ZKj8SsZAz9MoS7BiNR249pS/37fbTIM9U=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m8kGl-00FB92-Q5; Wed, 28 Jul 2021 16:10:47 +0200
Date:   Wed, 28 Jul 2021 16:10:47 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        shawnguo@kernel.org, s.hauer@pengutronix.de, kernel@pengutronix.de,
        festevam@gmail.com, linux-imx@nxp.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 net-next 5/7] net: fec: add MAC internal delayed clock
 feature support
Message-ID: <YQFlZ+eZRTikjItm@lunn.ch>
References: <20210728115203.16263-1-qiangqing.zhang@nxp.com>
 <20210728115203.16263-6-qiangqing.zhang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210728115203.16263-6-qiangqing.zhang@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +	/* For rgmii internal delay, valid values are 0ps and 2000ps */
> +	if (of_property_read_u32(np, "tx-internal-delay-ps", &rgmii_delay))
> +		fep->rgmii_txc_dly = true;
> +	if (of_property_read_u32(np, "rx-internal-delay-ps", &rgmii_delay))
> +		fep->rgmii_rxc_dly = true;

I don't see any validation of the only supported values are 0ps and
2000ps.

	Andrew
