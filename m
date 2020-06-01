Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26D431EA2D4
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 13:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726101AbgFALhY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 1 Jun 2020 07:37:24 -0400
Received: from piie.net ([80.82.223.85]:41312 "EHLO piie.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725838AbgFALhY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jun 2020 07:37:24 -0400
Received: from mail.piie.net (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES128-SHA (128/128 bits))
        (Client did not present a certificate)
        by piie.net (Postfix) with ESMTPSA id 16098163C;
        Mon,  1 Jun 2020 13:37:19 +0200 (CEST)
Mime-Version: 1.0
Date:   Mon, 01 Jun 2020 11:37:19 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: RainLoop/1.11.3
From:   "=?utf-8?B?UGV0ZXIgS8Okc3RsZQ==?=" <peter@piie.net>
Message-ID: <1e979aee396e9d28189b4926af6f4684@piie.net>
Subject: Re: [PATCH v4 05/11] thermal: remove get_mode() operation of
 drivers
To:     "Andrzej Pietrasiewicz" <andrzej.p@collabora.com>,
        linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-renesas-soc@vger.kernel.org,
        linux-rockchip@lists.infradead.org
Cc:     "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        "Len Brown" <lenb@kernel.org>,
        "Vishal Kulkarni" <vishal@chelsio.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Jiri Pirko" <jiri@mellanox.com>,
        "Ido Schimmel" <idosch@mellanox.com>,
        "Johannes Berg" <johannes.berg@intel.com>,
        "Emmanuel Grumbach" <emmanuel.grumbach@intel.com>,
        "Luca Coelho" <luciano.coelho@intel.com>,
        "Intel Linux Wireless" <linuxwifi@intel.com>,
        "Kalle Valo" <kvalo@codeaurora.org>,
        "Darren Hart" <dvhart@infradead.org>,
        "Andy Shevchenko" <andy@infradead.org>,
        "Sebastian Reichel" <sre@kernel.org>,
        "Miquel Raynal" <miquel.raynal@bootlin.com>,
        "Daniel Lezcano" <daniel.lezcano@linaro.org>,
        "Amit Kucheria" <amit.kucheria@verdurent.com>,
        "Support Opensource" <support.opensource@diasemi.com>,
        "Shawn Guo" <shawnguo@kernel.org>,
        "Sascha Hauer" <s.hauer@pengutronix.de>,
        "Pengutronix Kernel Team" <kernel@pengutronix.de>,
        "Fabio Estevam" <festevam@gmail.com>,
        "NXP Linux Team" <linux-imx@nxp.com>,
        "=?utf-8?B?TmlrbGFzIFPDtmRlcmx1bmQ=?=" 
        <niklas.soderlund@ragnatech.se>,
        "Heiko Stuebner" <heiko@sntech.de>,
        "Orson Zhai" <orsonzhai@gmail.com>,
        "Baolin Wang" <baolin.wang7@gmail.com>,
        "Chunyan Zhang" <zhang.lyra@gmail.com>,
        "Zhang Rui" <rui.zhang@intel.com>,
        "Allison Randal" <allison@lohutok.net>,
        "Enrico Weigelt" <info@metux.net>,
        "Gayatri Kammela" <gayatri.kammela@intel.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Bartlomiej Zolnierkiewicz" <b.zolnierkie@samsung.com>,
        kernel@collabora.com
In-Reply-To: <20200528192051.28034-6-andrzej.p@collabora.com>
References: <20200528192051.28034-6-andrzej.p@collabora.com> <Message-ID:
 <4493c0e4-51aa-3907-810c-74949ff27ca4@samsung.com>
 <20200528192051.28034-1-andrzej.p@collabora.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

28. Mai 2020 21:21, "Andrzej Pietrasiewicz" <andrzej.p@collabora.com> schrieb:

> get_mode() is now redundant, as the state is stored in struct
> thermal_zone_device.
> 
> Consequently the "mode" attribute in sysfs can always be visible, because
> it is always possible to get the mode from struct tzd.
> 
> Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
> ---

[...]

> drivers/platform/x86/acerhdf.c | 12 --------

Acked-by: Peter Kaestle <peter@piie.net>
