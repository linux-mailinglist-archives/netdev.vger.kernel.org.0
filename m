Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE14B2C889E
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 16:52:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727395AbgK3Pvi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 10:51:38 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:57640 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726629AbgK3Pvh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Nov 2020 10:51:37 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kjlRs-009Wj6-SH; Mon, 30 Nov 2020 16:50:44 +0100
Date:   Mon, 30 Nov 2020 16:50:44 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vignesh Raghavendra <vigneshr@ti.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Jonathan Corbet <corbet@lwn.net>, Jiri Pirko <jiri@nvidia.com>,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linux ARM Mailing List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/4] net: ti: am65-cpsw-nuss: Add devlink support
Message-ID: <20201130155044.GE2073444@lunn.ch>
References: <20201130082046.16292-1-vigneshr@ti.com>
 <20201130082046.16292-2-vigneshr@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201130082046.16292-2-vigneshr@ti.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 30, 2020 at 01:50:43PM +0530, Vignesh Raghavendra wrote:
> AM65 NUSS ethernet switch on K3 devices can be configured to work either
> in independent mac mode where each port acts as independent network
> interface (multi mac) or switch mode.
> 
> Add devlink hooks to provide a way to switch b/w these modes.

Hi Vignesh

What is not clear is why you need this? Ports are independent anyway
until you add them to a bridge when using switchdev.

       Andrew
