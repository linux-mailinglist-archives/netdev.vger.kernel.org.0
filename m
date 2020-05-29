Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59E1E1E813F
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 17:08:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbgE2PI2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 11:08:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbgE2PI2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 11:08:28 -0400
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03708C03E969;
        Fri, 29 May 2020 08:08:27 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: andrzej.p)
        with ESMTPSA id B4BEF2A46A5
Subject: Re: [PATCH v4 02/11] thermal: Store thermal mode in a dedicated enum
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-renesas-soc@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Heiko Stuebner <heiko@sntech.de>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Vishal Kulkarni <vishal@chelsio.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        kernel@collabora.com, Fabio Estevam <festevam@gmail.com>,
        Amit Kucheria <amit.kucheria@verdurent.com>,
        Chunyan Zhang <zhang.lyra@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Allison Randal <allison@lohutok.net>,
        NXP Linux Team <linux-imx@nxp.com>,
        Darren Hart <dvhart@infradead.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Gayatri Kammela <gayatri.kammela@intel.com>,
        Len Brown <lenb@kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Ido Schimmel <idosch@mellanox.com>,
        Baolin Wang <baolin.wang7@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Orson Zhai <orsonzhai@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        Support Opensource <support.opensource@diasemi.com>,
        Enrico Weigelt <info@metux.net>,
        Peter Kaestle <peter@piie.net>,
        Sebastian Reichel <sre@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>,
        Shawn Guo <shawnguo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Andy Shevchenko <andy@infradead.org>
References: <20200529150549.GA154196@roeck-us.net>
From:   Andrzej Pietrasiewicz <andrzej.p@collabora.com>
Message-ID: <b9aa246f-4534-db23-aea1-07aae2edbdd5@collabora.com>
Date:   Fri, 29 May 2020 17:08:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200529150549.GA154196@roeck-us.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

W dniu 29.05.2020 o 17:05, Guenter Roeck pisze:
> On Thu, May 28, 2020 at 09:20:42PM +0200, Andrzej Pietrasiewicz wrote:
>> Prepare for storing mode in struct thermal_zone_device.
>>
>> Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
> 
> What is the baseline for this series ? I can't get this patch to apply
> on top of current mainline, nor on v5.6, nor on top of linux-next.
> 
> Thanks,
> Guenter
> 

git://git.kernel.org/pub/scm/linux/kernel/git/thermal/linux.git, branch "testing".

base-commit: 351f4911a477ae01239c42f771f621d85b06ea10

Andrzej
