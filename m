Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06D7020DA1E
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 22:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730840AbgF2Txq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 15:53:46 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:36515 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387633AbgF2Tk0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:40:26 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20200629141512euoutp014476a8500afc73056f924656bbd23cbf~dCVb56w5a1551515515euoutp019;
        Mon, 29 Jun 2020 14:15:12 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20200629141512euoutp014476a8500afc73056f924656bbd23cbf~dCVb56w5a1551515515euoutp019
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1593440112;
        bh=kBmxCxko1n0VixxrYshWStpzD3SLUqQMwQ6SZhlpW6E=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=W/mrSocws91eBINJr1KdwuKJephAmo+1EullCY2Qhm3rh2p5JdCyI3DodeQDl2eN8
         HMKTkIuvQfuyXXgdjQsz9n0IWw/YJP6M0pU4gGAEIaPiwx8kFOJeYAAfS39zPvvfgA
         avkPv1k6fmZLYzmy3NRKq1Edn0J7C5qzKtkK4QPg=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20200629141512eucas1p20bc22ec128d8b32aa5190d1994d59678~dCVbr6k4A0811208112eucas1p2a;
        Mon, 29 Jun 2020 14:15:12 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id C9.A6.06318.F67F9FE5; Mon, 29
        Jun 2020 15:15:12 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20200629141511eucas1p1c17b80c2274499b052144cca9df99b9f~dCVa8y-fP2426724267eucas1p1u;
        Mon, 29 Jun 2020 14:15:11 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200629141511eusmtrp2538d466b6ad8029693c898646580da6c~dCVa7hPIe3219232192eusmtrp2X;
        Mon, 29 Jun 2020 14:15:11 +0000 (GMT)
X-AuditID: cbfec7f5-38bff700000018ae-71-5ef9f76fefb8
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 3B.7B.06314.F67F9FE5; Mon, 29
        Jun 2020 15:15:11 +0100 (BST)
Received: from [106.120.51.71] (unknown [106.120.51.71]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200629141509eusmtip2e2ffb527aaf8c82b3c8390b8abad32a6~dCVZSG0bm1156011560eusmtip2K;
        Mon, 29 Jun 2020 14:15:09 +0000 (GMT)
Subject: Re: [PATCH v7 08/11] thermal: Explicitly enable non-changing
 thermal zone devices
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
Message-ID: <c28f04b1-be65-58a8-8620-0a44ef74dbc7@samsung.com>
Date:   Mon, 29 Jun 2020 16:15:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
        Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200629122925.21729-9-andrzej.p@collabora.com>
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02TfUxbZRTG897PQiy5K0PegGhsMhcWhRmWeDK3OT8Wr4kJJmhizNatypUR
        oSMtIFOzwTK+mg06sAIdGx8yaLtlQGGFDizaujHTrU4XcCgYKMUVpQhUs5UwasuFyH+/c87z
        vM85f7wSUqZjEyTZqnxBrVLmyJloynoz6H4h72FQsfPRJALTrVUKHrqDBLRP/05BTX2IhO6S
        KQIuBpKg8cfTFGhbdkKpdYKGqZF0KAvUUxDy/BWuvn0dxkoGCGj0FYLHaGChx32GBrPeRkGr
        qYUB25SfgQ57NQLL9CgN2mUTCYGz3yO4NjtPwNJkOGjOOM5CZc85BM5rzQQ4y+003Gx+Eoa/
        qqKhbuE8grt3D8LlQR8Jt10/0+CdqmLgcZ+FAl9vPLgG8uGb0p9I6LHoSRhtDlDQMXmd3f88
        f/HK5/xMfyPN36s6S/D9E22I7zWNEbxxKZW3GSZYvse4g/96cJbgLeZKhh8fHWT4ebc73G87
        yS/OeVn+jzonwesW/Mw7+IPoPZlCTnahoE7ddyT6aJvjDpNnOlS0MMQUo8q3tShKgrldeO7M
        PKVF0RIZZ0R4pcrDisU/CM+cKkZiEUA4NDhBbFgCei0hDjoQDjwaWff7Eb40FkQRVSx3EAdm
        hpgIb+XScNDqX3uX5LRS7H9gZyMDhtuNz5Wb1wxSbh+ub9HREaa4bfjGgGiO497HS5NOWtRs
        wT80eKkIR3F78fkvR8gIk1w8/tXbRIj8DO7zN5KRMMwtReHaB/eRuPcb2Ne6ss6x+M/hXlbk
        p3DI1kSIhqsIP67wrbv7EO6oXWVE1ct43L0cZkk4Ihl3Xk8V26/ixd8urLUxF4Pv+7eIS8Tg
        GmsdKbaluKJMJqqfw13tXcxGrNZmInVIbth0mmHTOYZN5xj+z21GlBnFCwWa3CxBk6YSPk3R
        KHM1BaqslI+O5VpQ+J+4Vof/7Uf2lQ8diJMg+RPSI+6gQkYrCzXHcx0IS0j5Vulrd1wKmTRT
        efwzQX3ssLogR9A4UKKEksdL01pnD8m4LGW+8Ikg5AnqjSkhiUooRraZL27HJahKT3TrTv/y
        rrk2RoitG9l+xVOU8bF3+bu9XW8NJRcW70kscz37prOzzfNe3Eu27TVJZK8yQ3qgIFuRuL99
        0VG+q6JhOnNF4S1Kr854mq2+dyIluS5JrzlpbpAf6C5ratHfsqXbrXbXDeLvnG2XLr+i15/q
        zwx1liTsRnJKc1T54g5SrVH+B+khGR4jBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA02SbUxTZxTH89y3FmKzS8XxhMxpajZfVyyIPRjATb/cD2TDLMtEEWnwBswo
        Jb2lDk1EdKhU6cAAYiVYGCoF1NAKFIuytRtoqh2wyCIRpYIKEQhSN9ONl7XiEr79zjn/X05O
        csSk1MxEig/m6HhtjipbxoRS7vmeJ59p3vrTNl++LwHL3XkK3nr8BFwZeULBuaoFEloKvQTU
        +FZC9e8/UGCo3QxFbUM0eB9+BSd9VRQsPHsVqH7eCY8KHQRUj+nhWYNJBDbPWRoaKzooqLPU
        MtDhnWTg6p0fEVhHBmgw/GMhwVfyK4LW8SkCZoYDiyYaHoug2FaGwNVqJsB16g4N3eYPoafS
        SMP56YsIentToalzjIT77n4aRr1GBubarRSM3YwAt0MHt4v6SLBZK0gYMPsouDp8S/T5Jq6m
        +Qj33F5Nc38YSwjOPlSPuJuWRwTXMBPFdZiGRJytYQP3U+c4wVkbixnu8UAnw015PIF+fQH3
        emJUxL047yK40ulJJhnvkcdrNXk6fnWWRtAlyPYqIFquiAN59JY4uSJGuW9bdKwsKjH+AJ99
        UM9roxLT5Vn1zgdMrmXf99NdzDFUnGRAIWLMbsG+CgMRZCl7GeH2p6EGJA70P8I9N/SLkeV4
        dsDAGFBoIPIK4YXWBRQcLGdTscvbJwpyOBuD/W2TomCIZI0S7HjRLFo0XAjXOU68Mxh2Gy47
        1fiOJWwirqotpYNMsZ/g3xxdTJBXsLuxy256nwnD9y6MUkEOYRPwxfKHZJBJdi2erel/zxF4
        cPQSscircPtkNVmKpKYlummJYlqimJYoZkQ1onA+T1BnqgWFXFCphbycTHmGRm1Fge9s6/bb
        7Ki/5WsnYsVItkyS7vGnSWmVXshXOxEWk7JwyY4H7jSp5IAq/zCv1ezX5mXzghPFBo4rIyNX
        ZGgCv56j26+IVSghTqGMUcZsBVmE5DT7S6qUzVTp+O94PpfX/u8R4pDIY+jMkb+/2FEyOLXp
        UIJtRvmtreevoU9vXGvSrK3p7yObyq8X3PZmNR990zxY2RdWML6nZc1zZ3r+yPGjtm7Nnx+A
        Njm57kvdvaozJ7/RzQ8b1t3duL511a6w7W9S3HZnl+9l2Ny/fNKsfnxm68ZeKiOk4unOlPjC
        sRS7wzecm/yxMFFplFFClkqxgdQKqv8AOs0WKrMDAAA=
X-CMS-MailID: 20200629141511eucas1p1c17b80c2274499b052144cca9df99b9f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20200629123004eucas1p2c714a621eb1c153d6cee952b033fecbe
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200629123004eucas1p2c714a621eb1c153d6cee952b033fecbe
References: <20200629122925.21729-1-andrzej.p@collabora.com>
        <CGME20200629123004eucas1p2c714a621eb1c153d6cee952b033fecbe@eucas1p2.samsung.com>
        <20200629122925.21729-9-andrzej.p@collabora.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 6/29/20 2:29 PM, Andrzej Pietrasiewicz wrote:
> Some thermal zone devices never change their state, so they should be
> always enabled.
> 
> Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>

Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

> ---
>  drivers/net/ethernet/chelsio/cxgb4/cxgb4_thermal.c       | 8 ++++++++
>  drivers/net/wireless/intel/iwlwifi/mvm/tt.c              | 9 ++++++++-
>  drivers/platform/x86/intel_mid_thermal.c                 | 6 ++++++
>  drivers/power/supply/power_supply_core.c                 | 9 +++++++--
>  drivers/thermal/armada_thermal.c                         | 6 ++++++
>  drivers/thermal/dove_thermal.c                           | 6 ++++++
>  .../thermal/intel/int340x_thermal/int340x_thermal_zone.c | 5 +++++
>  drivers/thermal/intel/intel_pch_thermal.c                | 5 +++++
>  drivers/thermal/intel/intel_soc_dts_iosf.c               | 3 +++
>  drivers/thermal/intel/x86_pkg_temp_thermal.c             | 6 ++++++
>  drivers/thermal/kirkwood_thermal.c                       | 7 +++++++
>  drivers/thermal/rcar_thermal.c                           | 9 ++++++++-
>  drivers/thermal/spear_thermal.c                          | 7 +++++++
>  drivers/thermal/st/st_thermal.c                          | 5 +++++
>  14 files changed, 87 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_thermal.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_thermal.c
> index 3de8a5e83b6c..e3510e9b21f3 100644
> --- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_thermal.c
> +++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_thermal.c
> @@ -92,6 +92,14 @@ int cxgb4_thermal_init(struct adapter *adap)
>  		ch_thermal->tzdev = NULL;
>  		return ret;
>  	}
> +
> +	ret = thermal_zone_device_enable(ch_thermal->tzdev);
> +	if (ret) {
> +		dev_err(adap->pdev_dev, "Failed to enable thermal zone\n");
> +		thermal_zone_device_unregister(adap->ch_thermal.tzdev);
> +		return ret;
> +	}
> +
>  	return 0;
>  }
>  
> diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tt.c b/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
> index 418e59b7c671..0c95663bf9ed 100644
> --- a/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
> +++ b/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
> @@ -733,7 +733,7 @@ static  struct thermal_zone_device_ops tzone_ops = {
>  
>  static void iwl_mvm_thermal_zone_register(struct iwl_mvm *mvm)
>  {
> -	int i;
> +	int i, ret;
>  	char name[16];
>  	static atomic_t counter = ATOMIC_INIT(0);
>  
> @@ -759,6 +759,13 @@ static void iwl_mvm_thermal_zone_register(struct iwl_mvm *mvm)
>  		return;
>  	}
>  
> +	ret = thermal_zone_device_enable(mvm->tz_device.tzone);
> +	if (ret) {
> +		IWL_DEBUG_TEMP(mvm, "Failed to enable thermal zone\n");
> +		thermal_zone_device_unregister(mvm->tz_device.tzone);
> +		return;
> +	}
> +
>  	/* 0 is a valid temperature,
>  	 * so initialize the array with S16_MIN which invalid temperature
>  	 */
> diff --git a/drivers/platform/x86/intel_mid_thermal.c b/drivers/platform/x86/intel_mid_thermal.c
> index f402e2e74a38..f12f4e7bd971 100644
> --- a/drivers/platform/x86/intel_mid_thermal.c
> +++ b/drivers/platform/x86/intel_mid_thermal.c
> @@ -493,6 +493,12 @@ static int mid_thermal_probe(struct platform_device *pdev)
>  			ret = PTR_ERR(pinfo->tzd[i]);
>  			goto err;
>  		}
> +		ret = thermal_zone_device_enable(pinfo->tzd[i]);
> +		if (ret) {
> +			kfree(td_info);
> +			thermal_zone_device_unregister(pinfo->tzd[i]);
> +			goto err;
> +		}
>  	}
>  
>  	pinfo->pdev = pdev;
> diff --git a/drivers/power/supply/power_supply_core.c b/drivers/power/supply/power_supply_core.c
> index 02b37fe6061c..90e56736d479 100644
> --- a/drivers/power/supply/power_supply_core.c
> +++ b/drivers/power/supply/power_supply_core.c
> @@ -939,7 +939,7 @@ static struct thermal_zone_device_ops psy_tzd_ops = {
>  
>  static int psy_register_thermal(struct power_supply *psy)
>  {
> -	int i;
> +	int i, ret;
>  
>  	if (psy->desc->no_thermal)
>  		return 0;
> @@ -949,7 +949,12 @@ static int psy_register_thermal(struct power_supply *psy)
>  		if (psy->desc->properties[i] == POWER_SUPPLY_PROP_TEMP) {
>  			psy->tzd = thermal_zone_device_register(psy->desc->name,
>  					0, 0, psy, &psy_tzd_ops, NULL, 0, 0);
> -			return PTR_ERR_OR_ZERO(psy->tzd);
> +			if (IS_ERR(psy->tzd))
> +				return PTR_ERR(psy->tzd);
> +			ret = thermal_zone_device_enable(psy->tzd);
> +			if (ret)
> +				thermal_zone_device_unregister(psy->tzd);
> +			return ret;
>  		}
>  	}
>  	return 0;
> diff --git a/drivers/thermal/armada_thermal.c b/drivers/thermal/armada_thermal.c
> index 7c447cd149e7..c2ebfb5be4b3 100644
> --- a/drivers/thermal/armada_thermal.c
> +++ b/drivers/thermal/armada_thermal.c
> @@ -874,6 +874,12 @@ static int armada_thermal_probe(struct platform_device *pdev)
>  			return PTR_ERR(tz);
>  		}
>  
> +		ret = thermal_zone_device_enable(tz);
> +		if (ret) {
> +			thermal_zone_device_unregister(tz);
> +			return ret;
> +		}
> +
>  		drvdata->type = LEGACY;
>  		drvdata->data.tz = tz;
>  		platform_set_drvdata(pdev, drvdata);
> diff --git a/drivers/thermal/dove_thermal.c b/drivers/thermal/dove_thermal.c
> index 75901ced4a62..73182eb94bc0 100644
> --- a/drivers/thermal/dove_thermal.c
> +++ b/drivers/thermal/dove_thermal.c
> @@ -153,6 +153,12 @@ static int dove_thermal_probe(struct platform_device *pdev)
>  		return PTR_ERR(thermal);
>  	}
>  
> +	ret = thermal_zone_device_enable(thermal);
> +	if (ret) {
> +		thermal_zone_device_unregister(thermal);
> +		return ret;
> +	}
> +
>  	platform_set_drvdata(pdev, thermal);
>  
>  	return 0;
> diff --git a/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c b/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c
> index 432213272f1e..6e479deff76b 100644
> --- a/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c
> +++ b/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c
> @@ -259,9 +259,14 @@ struct int34x_thermal_zone *int340x_thermal_zone_add(struct acpi_device *adev,
>  		ret = PTR_ERR(int34x_thermal_zone->zone);
>  		goto err_thermal_zone;
>  	}
> +	ret = thermal_zone_device_enable(int34x_thermal_zone->zone);
> +	if (ret)
> +		goto err_enable;
>  
>  	return int34x_thermal_zone;
>  
> +err_enable:
> +	thermal_zone_device_unregister(int34x_thermal_zone->zone);
>  err_thermal_zone:
>  	acpi_lpat_free_conversion_table(int34x_thermal_zone->lpat_table);
>  	kfree(int34x_thermal_zone->aux_trips);
> diff --git a/drivers/thermal/intel/intel_pch_thermal.c b/drivers/thermal/intel/intel_pch_thermal.c
> index 56401fd4708d..65702094f3d3 100644
> --- a/drivers/thermal/intel/intel_pch_thermal.c
> +++ b/drivers/thermal/intel/intel_pch_thermal.c
> @@ -352,9 +352,14 @@ static int intel_pch_thermal_probe(struct pci_dev *pdev,
>  		err = PTR_ERR(ptd->tzd);
>  		goto error_cleanup;
>  	}
> +	err = thermal_zone_device_enable(ptd->tzd);
> +	if (err)
> +		goto err_unregister;
>  
>  	return 0;
>  
> +err_unregister:
> +	thermal_zone_device_unregister(ptd->tzd);
>  error_cleanup:
>  	iounmap(ptd->hw_base);
>  error_release:
> diff --git a/drivers/thermal/intel/intel_soc_dts_iosf.c b/drivers/thermal/intel/intel_soc_dts_iosf.c
> index f75271b669c6..4f1a2f7c016c 100644
> --- a/drivers/thermal/intel/intel_soc_dts_iosf.c
> +++ b/drivers/thermal/intel/intel_soc_dts_iosf.c
> @@ -329,6 +329,9 @@ static int add_dts_thermal_zone(int id, struct intel_soc_dts_sensor_entry *dts,
>  		ret = PTR_ERR(dts->tzone);
>  		goto err_ret;
>  	}
> +	ret = thermal_zone_device_enable(dts->tzone);
> +	if (ret)
> +		goto err_enable;
>  
>  	ret = soc_dts_enable(id);
>  	if (ret)
> diff --git a/drivers/thermal/intel/x86_pkg_temp_thermal.c b/drivers/thermal/intel/x86_pkg_temp_thermal.c
> index a006b9fd1d72..b81c33202f41 100644
> --- a/drivers/thermal/intel/x86_pkg_temp_thermal.c
> +++ b/drivers/thermal/intel/x86_pkg_temp_thermal.c
> @@ -363,6 +363,12 @@ static int pkg_temp_thermal_device_add(unsigned int cpu)
>  		kfree(zonedev);
>  		return err;
>  	}
> +	err = thermal_zone_device_enable(zonedev->tzone);
> +	if (err) {
> +		thermal_zone_device_unregister(zonedev->tzone);
> +		kfree(zonedev);
> +		return err;
> +	}
>  	/* Store MSR value for package thermal interrupt, to restore at exit */
>  	rdmsr(MSR_IA32_PACKAGE_THERM_INTERRUPT, zonedev->msr_pkg_therm_low,
>  	      zonedev->msr_pkg_therm_high);
> diff --git a/drivers/thermal/kirkwood_thermal.c b/drivers/thermal/kirkwood_thermal.c
> index 189b675cf14d..7fb6e476c82a 100644
> --- a/drivers/thermal/kirkwood_thermal.c
> +++ b/drivers/thermal/kirkwood_thermal.c
> @@ -65,6 +65,7 @@ static int kirkwood_thermal_probe(struct platform_device *pdev)
>  	struct thermal_zone_device *thermal = NULL;
>  	struct kirkwood_thermal_priv *priv;
>  	struct resource *res;
> +	int ret;
>  
>  	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
>  	if (!priv)
> @@ -82,6 +83,12 @@ static int kirkwood_thermal_probe(struct platform_device *pdev)
>  			"Failed to register thermal zone device\n");
>  		return PTR_ERR(thermal);
>  	}
> +	ret = thermal_zone_device_enable(thermal);
> +	if (ret) {
> +		thermal_zone_device_unregister(thermal);
> +		dev_err(&pdev->dev, "Failed to enable thermal zone device\n");
> +		return ret;
> +	}
>  
>  	platform_set_drvdata(pdev, thermal);
>  
> diff --git a/drivers/thermal/rcar_thermal.c b/drivers/thermal/rcar_thermal.c
> index 46aeb28b4e90..787710bb88fe 100644
> --- a/drivers/thermal/rcar_thermal.c
> +++ b/drivers/thermal/rcar_thermal.c
> @@ -550,12 +550,19 @@ static int rcar_thermal_probe(struct platform_device *pdev)
>  			priv->zone = devm_thermal_zone_of_sensor_register(
>  						dev, i, priv,
>  						&rcar_thermal_zone_of_ops);
> -		else
> +		else {
>  			priv->zone = thermal_zone_device_register(
>  						"rcar_thermal",
>  						1, 0, priv,
>  						&rcar_thermal_zone_ops, NULL, 0,
>  						idle);
> +
> +			ret = thermal_zone_device_enable(priv->zone);
> +			if (ret) {
> +				thermal_zone_device_unregister(priv->zone);
> +				priv->zone = ERR_PTR(ret);
> +			}
> +		}
>  		if (IS_ERR(priv->zone)) {
>  			dev_err(dev, "can't register thermal zone\n");
>  			ret = PTR_ERR(priv->zone);
> diff --git a/drivers/thermal/spear_thermal.c b/drivers/thermal/spear_thermal.c
> index f68f581fd669..ee33ed692e4f 100644
> --- a/drivers/thermal/spear_thermal.c
> +++ b/drivers/thermal/spear_thermal.c
> @@ -131,6 +131,11 @@ static int spear_thermal_probe(struct platform_device *pdev)
>  		ret = PTR_ERR(spear_thermal);
>  		goto disable_clk;
>  	}
> +	ret = thermal_zone_device_enable(spear_thermal);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Cannot enable thermal zone\n");
> +		goto unregister_tzd;
> +	}
>  
>  	platform_set_drvdata(pdev, spear_thermal);
>  
> @@ -139,6 +144,8 @@ static int spear_thermal_probe(struct platform_device *pdev)
>  
>  	return 0;
>  
> +unregister_tzd:
> +	thermal_zone_device_unregister(spear_thermal);
>  disable_clk:
>  	clk_disable(stdev->clk);
>  
> diff --git a/drivers/thermal/st/st_thermal.c b/drivers/thermal/st/st_thermal.c
> index b928ca6a289b..1276b95604fe 100644
> --- a/drivers/thermal/st/st_thermal.c
> +++ b/drivers/thermal/st/st_thermal.c
> @@ -246,11 +246,16 @@ int st_thermal_register(struct platform_device *pdev,
>  		ret = PTR_ERR(sensor->thermal_dev);
>  		goto sensor_off;
>  	}
> +	ret = thermal_zone_device_enable(sensor->thermal_dev);
> +	if (ret)
> +		goto tzd_unregister;
>  
>  	platform_set_drvdata(pdev, sensor);
>  
>  	return 0;
>  
> +tzd_unregister:
> +	thermal_zone_device_unregister(sensor->thermal_dev);
>  sensor_off:
>  	st_thermal_sensor_off(sensor);
>  
> 
