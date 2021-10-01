Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5056F41ECD1
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 14:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354250AbhJAMD1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 08:03:27 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:31789 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354253AbhJAMDN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 08:03:13 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1633089690; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: In-Reply-To: Date: References: Subject: Cc:
 To: From: Sender; bh=p2Ore5ulMIaePgcqUBJyw2WiETcga1BN2OxeVaOjVH4=; b=CP4rxNcS+HO3cCTvirT29soPXYWxXtBq+H68slshZknMtgiHDsr4W5J2g0NPqsUTYoNAB1YY
 p/B2Hn8+ivi8jOLHx4NLig8/d5lD92ZJOCRti4zBijnKiGVrWtIJFKXHrfW4KaLNI9fYRhqy
 YO/FAottGYkp/JZBnwxg84t2Sj4=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 6156f897605ecf100bc57fd2 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 01 Oct 2021 12:01:26
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 84B00C43619; Fri,  1 Oct 2021 12:01:26 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 08EC7C4338F;
        Fri,  1 Oct 2021 12:01:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 08EC7C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Jerome Pouiller <Jerome.Pouiller@silabs.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-mmc@vger.kernel.org,
        Pali =?utf-8?Q?Roh?= =?utf-8?Q?=C3=A1r?= <pali@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH v7 21/24] wfx: add debug.c/debug.h
References: <20210920161136.2398632-1-Jerome.Pouiller@silabs.com>
        <20210920161136.2398632-22-Jerome.Pouiller@silabs.com>
Date:   Fri, 01 Oct 2021 15:01:20 +0300
In-Reply-To: <20210920161136.2398632-22-Jerome.Pouiller@silabs.com> (Jerome
        Pouiller's message of "Mon, 20 Sep 2021 18:11:33 +0200")
Message-ID: <87o889j6nj.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jerome Pouiller <Jerome.Pouiller@silabs.com> writes:

> From: J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com>
>
> Signed-off-by: J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com>

[...]

> +static int wfx_ps_timeout_set(void *data, u64 val)
> +{
> +	struct wfx_dev *wdev =3D (struct wfx_dev *)data;
> +	struct wfx_vif *wvif;
> +
> +	wdev->force_ps_timeout =3D val;
> +	wvif =3D NULL;
> +	while ((wvif =3D wvif_iterate(wdev, wvif)) !=3D NULL)
> +		wfx_update_pm(wvif);
> +	return 0;
> +}
> +
> +static int wfx_ps_timeout_get(void *data, u64 *val)
> +{
> +	struct wfx_dev *wdev =3D (struct wfx_dev *)data;
> +
> +	*val =3D wdev->force_ps_timeout;
> +	return 0;
> +}
> +
> +DEFINE_DEBUGFS_ATTRIBUTE(wfx_ps_timeout_fops, wfx_ps_timeout_get,
> wfx_ps_timeout_set, "%lld\n");
> +
> +int wfx_debug_init(struct wfx_dev *wdev)
> +{
> +	struct dentry *d;
> +
> +	d =3D debugfs_create_dir("wfx", wdev->hw->wiphy->debugfsdir);
> +	debugfs_create_file("counters", 0444, d, wdev, &wfx_counters_fops);
> +	debugfs_create_file("rx_stats", 0444, d, wdev, &wfx_rx_stats_fops);
> +	debugfs_create_file("tx_power_loop", 0444, d, wdev,
> +			    &wfx_tx_power_loop_fops);
> +	debugfs_create_file("send_pds", 0200, d, wdev, &wfx_send_pds_fops);
> +	debugfs_create_file("send_hif_msg", 0600, d, wdev,
> +			    &wfx_send_hif_msg_fops);
> +	debugfs_create_file("ps_timeout", 0600, d, wdev, &wfx_ps_timeout_fops);

ps_timeout sounds like something which should be in nl80211, not in
debugfs. Please remove it until the driver is accepted.

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
