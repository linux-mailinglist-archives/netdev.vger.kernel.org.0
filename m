Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7530F1E84CF
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 19:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727023AbgE2Rbn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 13:31:43 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:41856 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726857AbgE2RXB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 13:23:01 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: andrzej.p)
        with ESMTPSA id EAFDB2A194B
Subject: Re: [PATCH v4 05/11] thermal: remove get_mode() operation of drivers
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
References: <20200529154910.GA158174@roeck-us.net>
From:   Andrzej Pietrasiewicz <andrzej.p@collabora.com>
Message-ID: <1c4a029e-bb5b-fcfd-1b4b-beea1d6fd577@collabora.com>
Date:   Fri, 29 May 2020 19:22:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200529154910.GA158174@roeck-us.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Guenter,

W dniu 29.05.2020 o 17:49, Guenter Roeck pisze:
> On Thu, May 28, 2020 at 09:20:45PM +0200, Andrzej Pietrasiewicz wrote:
>> get_mode() is now redundant, as the state is stored in struct
>> thermal_zone_device.
>>
>> Consequently the "mode" attribute in sysfs can always be visible, because
>> it is always possible to get the mode from struct tzd.
>>
>> Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
> 
> There is a slight semantic change for the two drivers which still have
> a local copy of enum thermal_device_mode: Previously trying to read the
> mode for those would return -EPERM since they don't have a get_mode
> function. Now the global value for mode is returned, but I am not sure
> if it matches the local value.

Please see my replies to your comment about patch 4/11.

Regards,

Andrzej
