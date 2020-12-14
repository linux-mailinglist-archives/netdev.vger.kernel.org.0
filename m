Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA972DA041
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 20:22:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441033AbgLNTVb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 14:21:31 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:54166 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440976AbgLNTVK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 14:21:10 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kotOS-00BxQC-Ni; Mon, 14 Dec 2020 20:20:24 +0100
Date:   Mon, 14 Dec 2020 20:20:24 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Divya Koppera <Divya.Koppera@microchip.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, marex@denx.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v2 net-next] net: phy: mchp: Add 1588 support for LAN8814
 Quad PHY
Message-ID: <20201214192024.GC2846647@lunn.ch>
References: <20201214175658.11138-1-Divya.Koppera@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201214175658.11138-1-Divya.Koppera@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 14, 2020 at 11:26:58PM +0530, Divya Koppera wrote:
> This patch add supports for 1588 Hardware Timestamping support
> to LAN8814 Quad Phy. It supports L2 and Ipv4 encapsulations.

Please could you break this patch up a bit. Add support for link
up/down interrupts in one patch. Then add the PTP support, for
example.

	Andrew
