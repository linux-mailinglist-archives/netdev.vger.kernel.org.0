Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6549FDB228
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 18:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502133AbfJQQSp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 12:18:45 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50830 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390480AbfJQQSo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Oct 2019 12:18:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=UFZRirGPWkDC9ZYLNhlWhULtCcik28qwS7AoLgcl8tk=; b=jLc1yy5RVx/RiW2gzbJKNYbDVC
        Y3jnToIdcsDuJuh86ly+rIojyRf4gSHqcCu4Qsrr35FEdO2ncXwxQ9LVJGK4gy83n3FBaLwWHoSrE
        JKdjyiZbjiWwrQJ61RXc2DAMO8myU3ET+malAiRjckDLip1DDIWc8PrzR6ysM/yxq1C0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iL8U2-0005Cm-U7; Thu, 17 Oct 2019 18:18:38 +0200
Date:   Thu, 17 Oct 2019 18:18:38 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Sylvain Lemieux <slemieux.tyco@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/2] dt-bindings: net: lpc-eth: document optional
 properties
Message-ID: <20191017161838.GR17013@lunn.ch>
References: <20191017094757.26885-1-alexandre.belloni@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191017094757.26885-1-alexandre.belloni@bootlin.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 17, 2019 at 11:47:56AM +0200, Alexandre Belloni wrote:
> The Ethernet controller is also an mdio controller, to be able to parse
> children (phys for example), #address-cells and #size-cells must be
> present.
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

