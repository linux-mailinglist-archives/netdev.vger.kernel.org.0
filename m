Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 806CEC191F
	for <lists+netdev@lfdr.de>; Sun, 29 Sep 2019 21:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729242AbfI2TeR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Sep 2019 15:34:17 -0400
Received: from gloria.sntech.de ([185.11.138.130]:45272 "EHLO gloria.sntech.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729098AbfI2TeQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 29 Sep 2019 15:34:16 -0400
Received: from ip5f5a6266.dynamic.kabel-deutschland.de ([95.90.98.102] helo=phil.localnet)
        by gloria.sntech.de with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <heiko@sntech.de>)
        id 1iEexA-0001BS-Tj; Sun, 29 Sep 2019 21:33:56 +0200
From:   Heiko Stuebner <heiko@sntech.de>
To:     Jerome Brunet <jbrunet@baylibre.com>
Cc:     Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>, linux-clk@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tero Kristo <t-kristo@ti.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-amlogic@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-rockchip@lists.infradead.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH 2/3] clk: let init callback return an error code
Date:   Sun, 29 Sep 2019 21:33:53 +0200
Message-ID: <7697352.nLdc4jJAoa@phil>
In-Reply-To: <20190924123954.31561-3-jbrunet@baylibre.com>
References: <20190924123954.31561-1-jbrunet@baylibre.com> <20190924123954.31561-3-jbrunet@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Dienstag, 24. September 2019, 14:39:53 CEST schrieb Jerome Brunet:
> If the init callback is allowed to request resources, it needs a return
> value to report the outcome of such a request.
> 
> Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
> ---
[...]
>  drivers/clk/rockchip/clk-pll.c        | 28 ++++++++++++++++-----------

for the Rockchip part
Acked-by: Heiko Stuebner <heiko@sntech.de>


