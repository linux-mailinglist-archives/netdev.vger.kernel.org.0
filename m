Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9A52C4BBF
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 01:01:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728502AbgKZAA6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 19:00:58 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:50598 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728350AbgKZAA6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Nov 2020 19:00:58 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1ki4iP-008tGk-Qz; Thu, 26 Nov 2020 01:00:49 +0100
Date:   Thu, 26 Nov 2020 01:00:49 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lukasz Majewski <lukma@denx.de>
Cc:     Fugang Duan <fugang.duan@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Fabio Estevam <festevam@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Peng Fan <peng.fan@nxp.com>, stefan.agner@toradex.com,
        krzk@kernel.org, Shawn Guo <shawnguo@kernel.org>
Subject: Re: [RFC 0/4] net: l2switch: Provide support for L2 switch on i.MX28
 SoC
Message-ID: <20201126000049.GL2073444@lunn.ch>
References: <20201125232459.378-1-lukma@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201125232459.378-1-lukma@denx.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 26, 2020 at 12:24:55AM +0100, Lukasz Majewski wrote:
> This is the first attempt to add support for L2 switch available on some NXP
> devices - i.e. iMX287 or VF610. This patch set uses common FEC and DSA code.

Interesting. I need to take another look at the Vybrid manual. Last
time i looked, i was more thinking of a pure switchdev driver, not a
DSA driver. So i'm not sure this is the correct architecture. But has
been a while since i looked at the datasheet.

    Andrew
