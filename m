Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41E972D50CA
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 03:22:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728273AbgLJCQh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 21:16:37 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:47826 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728033AbgLJCQY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 21:16:24 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1knBUV-00B9LD-Bw; Thu, 10 Dec 2020 03:15:35 +0100
Date:   Thu, 10 Dec 2020 03:15:35 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Claudiu Beznea <claudiu.beznea@microchip.com>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        nicolas.ferre@microchip.com, linux@armlinux.org.uk,
        paul.walmsley@sifive.com, palmer@dabbelt.com,
        natechancellor@gmail.com, ndesaulniers@google.com,
        yash.shah@sifive.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-riscv@lists.infradead.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH v3 3/8] net: macb: add function to disable all macb clocks
Message-ID: <20201210021535.GE2638572@lunn.ch>
References: <1607519019-19103-1-git-send-email-claudiu.beznea@microchip.com>
 <1607519019-19103-4-git-send-email-claudiu.beznea@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1607519019-19103-4-git-send-email-claudiu.beznea@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 09, 2020 at 03:03:34PM +0200, Claudiu Beznea wrote:
> Add function to disable all macb clocks.
> 
> Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
> Suggested-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
