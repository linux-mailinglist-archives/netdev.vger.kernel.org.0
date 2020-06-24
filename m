Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06791207031
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 11:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389840AbgFXJjQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 05:39:16 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:41573 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388031AbgFXJjP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 05:39:15 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20200624093912euoutp02cbd593548cc5612d8c986b05ae0c5789~bcWCHF0OX0099200992euoutp02h;
        Wed, 24 Jun 2020 09:39:12 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20200624093912euoutp02cbd593548cc5612d8c986b05ae0c5789~bcWCHF0OX0099200992euoutp02h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1592991552;
        bh=jhE2g+EdK7KYLYq++li93VyEHOz3u+d9sY9J48zVjmg=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=hURrDbTZdD56J67iWCJ5lqsCaw4LfSkYihIVvTioPMAkRzj5d81cWKbSpU/jPKzmv
         /i+FnZNPx13Kly1hrT2AEK2/6ocfikCxvVKaIM1Yv47uQWpmxw61iO+oNDqiKM6d1g
         MHQCpiR+cLB7kEBO4yXS55qgHk4BMfZYggsGPUxY=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20200624093912eucas1p22e4ed7d39310e735332a69a65b961a35~bcWB7PPGP0467204672eucas1p2O;
        Wed, 24 Jun 2020 09:39:12 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id BB.DB.05997.04F13FE5; Wed, 24
        Jun 2020 10:39:12 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20200624093911eucas1p276a7d01031bdbbe40ddf74aa5e36d44b~bcWBhPncQ1540115401eucas1p2S;
        Wed, 24 Jun 2020 09:39:11 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200624093911eusmtrp13451e5f4c9eaec6867934affbb943456~bcWBf9aNK2349223492eusmtrp1p;
        Wed, 24 Jun 2020 09:39:11 +0000 (GMT)
X-AuditID: cbfec7f4-65dff7000000176d-43-5ef31f40e8f0
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id B1.22.06314.F3F13FE5; Wed, 24
        Jun 2020 10:39:11 +0100 (BST)
Received: from [106.120.51.71] (unknown [106.120.51.71]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200624093910eusmtip2e984fea04ccca3e77383bdce1627692a~bcV-uE0ed1359413594eusmtip24;
        Wed, 24 Jun 2020 09:39:10 +0000 (GMT)
Subject: Re: [PATCH v4 03/11] thermal: Add current mode to thermal zone
 device
To:     Andrzej Pietrasiewicz <andrzej.p@collabora.com>
Cc:     linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-renesas-soc@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>,
        Vishal Kulkarni <vishal@chelsio.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Peter Kaestle <peter@piie.net>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        Sebastian Reichel <sre@kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amit.kucheria@verdurent.com>,
        Support Opensource <support.opensource@diasemi.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>,
        Heiko Stuebner <heiko@sntech.de>,
        Orson Zhai <orsonzhai@gmail.com>,
        Baolin Wang <baolin.wang7@gmail.com>,
        Chunyan Zhang <zhang.lyra@gmail.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Allison Randal <allison@lohutok.net>,
        Enrico Weigelt <info@metux.net>,
        Gayatri Kammela <gayatri.kammela@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, kernel@collabora.com
From:   Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Message-ID: <eda187b4-8b20-4fb4-bea8-84dc1fe1eee6@samsung.com>
Date:   Wed, 24 Jun 2020 11:39:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
        Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200528192051.28034-4-andrzej.p@collabora.com>
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Ta0yTZxj1/W4tjTWfxY13bpOlmzMaFBkmPm7O4VyyL7tkZsmWXXF1fEEi
        VNJCN8ePQcalNFoLXmAdQ1RCLy6DtQgUsXGtKyN1VXZhU4G0wiggNYWSbW0GruUrGf/O85xz
        nvOeH6+YlBlE68UFyhJepVQUyhkJ1eWJ+rbmpEdytzeGZWD5cZGCv31RAtrGRimob3xAwncV
        AQKaI49D041KCnTntkNV1wgNgd/egOpIIwUP7t6LT1f3wa2KywQ0TWrgrtkoArvvGA3W0w4K
        zlvOMeAIhBgwOU8gsI0N0aCLWUiIHL+G4NLUfQLm/PGgGfOwCGrtdQjcl1oIcNc4afC0PAz9
        Z/Q0NIS/QnDz5gdwsW+ShOven2kYD+gZWOi2UTDZmQbeyyVwpWqQBLvtNAlDLREKTP5eUU4G
        1/xNGfdnTxPN/aI/TnA9I62I67TcIjjzXCbnMI6IOLt5C3ehb4rgbNZahhse6mO4+z5ffN/6
        OTc7My7iJhrcBGcIh5j9+D3J7jy+sEDDqzL3fCQ5FAy7qOLQ6k8d0RhVjtwSHUoRY3YHDrYu
        0DokEctYM8KegQFGGOYRvufUJZkIwubfO5lli9MykyRMCN+wlxPCEEL41PwdlFClsvuxraad
        TOB1bDaOdoVECRHJ6qQ4FHSKEgTDPovraqxLBim7B1c2D9EJTLEbsdmrX9I8xL6D5/xuWtCs
        xQNfjlMJnMI+j4Oxs0tekk3Dt8fPEgJOx92hJjIRhtm/UvAX1jtxszg+vIQr63cKFVLxdH+n
        SMCPYe/JY5Sg/xbhBe1k0tyNsOnkYrL0c3jYF2MSh0h2M27vzRTWe/H1hmukcH8N/iO0VnjD
        Glzf1ZBcS7G2Wiaon8YdbR3McqzOYSENSG5c0cy4oo1xRRvj/7ktiLKiNL5UXZTPq59R8p9s
        UyuK1KXK/G0fHymyofg/8S72z/eg3n8PuhArRvLV0g7/bK6MVmjUR4tcCItJ+Trpiz95c2XS
        PMXRz3jVkQOq0kJe7UKPiil5mjT7/NSHMjZfUcIf5vliXrXMEuKU9eUor13cvjHH9Ir+ifTs
        1O//Objr3WioR3N4r3vTm9r0q9J59+js6GDN9HTZxIbbL3g2S97K8p+KPbJqB6rbV3zgybI2
        eixjYleVMltTsHvDJkcW9fVAXuGvVa+v2lrxfl/g4g+pO8ueMlSHglc8Gdra/NaI9sLbg6+O
        uU5ESsIVAcPLr8XklPqQImsLqVIr/gMlj8c3IwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02SbUxTZxTH89zXQmi8VpRnTMNStzjJVrxU6MEJLPphN3Gby/ZlGQxp9AZU
        Sk1vYXMzDjKQWbHCEgULgaJMWjBxtIAgDB01IOvGGHNNXISBMF4mZUCnSxmKLZ0J337nnP/v
        PHmSIyMVl5ho2eFco2jI1eYomXDK/bRv5PXUGF/GDnvhdrDfeUrBvwN+Aq6Mj1DwdeUKCc2F
        YwTU+LZA9c9FFJjqdkBx2zANY7/th1O+SgpWHjwMVLf2wr3CTgKqp/Phgc3CgnOglIbG8x0U
        XLLXMdAx5mWgofscAse4hwbTkp0E39nbCFpn5ghYHA08NGu7z8JpZzkCV6uVAFdJNw291k3Q
        d8FMQ8V8FYLBwXRo6pom4Uf3EA0TY2YGnlx3UDDdEgXuTiN8V/wLCU7HeRI8Vh8FDaM32Ddf
        E2qufi782V5NC7+azxJC+3A9Elrs9wjBthgndFiGWcFpixUud80QgqPxNCPc93QxwtzAQKBf
        /4WwMDvBCpMVLkIom/cy7+GPVLsN+jyj+FK2XjImK9N4iFfxSaCK35mk4tWaj3fFJyjjUnYf
        EnMO54uGuJRMVfbUfA91zBvxaYd/iSpArnATCpNhbifuts/SJhQuU3DfIFznXiZNSBYYbMZ9
        1/JDmQ142WNiQpmHCN+uGKGCgw3cu3hhboYNciSnxv42LxsMkZxZjjsnr7Iho5jAt/6qWjUY
        bhcuL2lEQZZzKbioxkMHmeJewTa3eXXTRu5D7Gq3/J9Zj/svTqy6YVwynlqqXe2T3Da8XDNE
        hjgK/z5RS4Q4Bl/3VpNlSGFZo1vWKJY1imWNYkVUI4oU8yRdlk7iVZJWJ+XlZqkO6nUOFLjP
        tl6/sx0NNX/QgzgZUkbIvx1dyFDQ2nzpuK4HYRmpjJTv+cmdoZAf0h7/TDToDxjyckSpByUE
        PldORm88qA9ce67xAJ/AayCJ16g16kRQRsm/4r5PV3BZWqN4VBSPiYbnHiELiy5AaJw4EpVc
        mvjyqy9kTn/5H3ticuodoi7GbBVWrmwmDZWKzsVZp+f9KtGvvPb23+rmk/sL3jCn3XU8jn2U
        PZjaZPxjKjps6w/N/yRqmJZYz57+Ozd779ZHnkgv2lfaQFxOK2kbp4+mFp15q7WeanWn32ja
        3n9zU8SWriMvZm5bd/KTMl5JSdlaPpY0SNpn9Ok+rbUDAAA=
X-CMS-MailID: 20200624093911eucas1p276a7d01031bdbbe40ddf74aa5e36d44b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20200528192153eucas1p1b0119928489e5fd22e17908d2bb0890b
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200528192153eucas1p1b0119928489e5fd22e17908d2bb0890b
References: <Message-ID: <4493c0e4-51aa-3907-810c-74949ff27ca4@samsung.com>
        <20200528192051.28034-1-andrzej.p@collabora.com>
        <CGME20200528192153eucas1p1b0119928489e5fd22e17908d2bb0890b@eucas1p1.samsung.com>
        <20200528192051.28034-4-andrzej.p@collabora.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 5/28/20 9:20 PM, Andrzej Pietrasiewicz wrote:
> Prepare for changing the place where the mode is stored: now it is in
> drivers, which might or might not implement get_mode()/set_mode() methods.
> A lot of cleanup can be done thanks to storing it in struct tzd. The
> get_mode() methods will become redundant.
> 
> Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>

Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

> ---
>  include/linux/thermal.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/include/linux/thermal.h b/include/linux/thermal.h
> index 216185bb3014..5f91d7f04512 100644
> --- a/include/linux/thermal.h
> +++ b/include/linux/thermal.h
> @@ -128,6 +128,7 @@ struct thermal_cooling_device {
>   * @trip_temp_attrs:	attributes for trip points for sysfs: trip temperature
>   * @trip_type_attrs:	attributes for trip points for sysfs: trip type
>   * @trip_hyst_attrs:	attributes for trip points for sysfs: trip hysteresis
> + * @mode:		current mode of this thermal zone
>   * @devdata:	private pointer for device private data
>   * @trips:	number of trip points the thermal zone supports
>   * @trips_disabled;	bitmap for disabled trips
> @@ -170,6 +171,7 @@ struct thermal_zone_device {
>  	struct thermal_attr *trip_temp_attrs;
>  	struct thermal_attr *trip_type_attrs;
>  	struct thermal_attr *trip_hyst_attrs;
> +	enum thermal_device_mode mode;
>  	void *devdata;
>  	int trips;
>  	unsigned long trips_disabled;	/* bitmap for disabled trips */
> 
