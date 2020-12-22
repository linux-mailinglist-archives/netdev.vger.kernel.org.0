Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83E832E0C66
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 16:07:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728029AbgLVPGP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 10:06:15 -0500
Received: from so254-31.mailgun.net ([198.61.254.31]:58915 "EHLO
        so254-31.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728014AbgLVPGO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 10:06:14 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1608649551; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: In-Reply-To: Date: References: Subject: Cc:
 To: From: Sender; bh=nBdti4p145SybWnCMKjk232I8BcskhOJcfGH3EeiP68=; b=lEMk/hrmvaRDAQ8TU15Sm0luc5VsvuXbzCjwxOapP16GjBuEkGQjhLNh/QWJlxP+2sA9qZsl
 6Jjq65kk6NZ4qRY/HnMUtqyn7q2hEuuc9HGgkEl2nB+WUoPSIes1dj6eNeAUVClcpFxGw4Lx
 9ky762BSa3pGMcg1I+99Pn9yGlM=
X-Mailgun-Sending-Ip: 198.61.254.31
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n08.prod.us-east-1.postgun.com with SMTP id
 5fe20b4b7bc801dc4f99888e (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 22 Dec 2020 15:05:47
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 206A6C43461; Tue, 22 Dec 2020 15:05:47 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from x230.qca.qualcomm.com (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 94631C433C6;
        Tue, 22 Dec 2020 15:05:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 94631C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
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
Subject: Re: [PATCH v3 03/24] wfx: add Makefile/Kconfig
References: <20201104155207.128076-1-Jerome.Pouiller@silabs.com>
        <20201104155207.128076-4-Jerome.Pouiller@silabs.com>
Date:   Tue, 22 Dec 2020 17:05:41 +0200
In-Reply-To: <20201104155207.128076-4-Jerome.Pouiller@silabs.com> (Jerome
        Pouiller's message of "Wed, 4 Nov 2020 16:51:46 +0100")
Message-ID: <87tusd98ze.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
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
> ---
>  drivers/net/wireless/silabs/wfx/Kconfig  |  8 ++++++++
>  drivers/net/wireless/silabs/wfx/Makefile | 25 ++++++++++++++++++++++++
>  2 files changed, 33 insertions(+)
>  create mode 100644 drivers/net/wireless/silabs/wfx/Kconfig
>  create mode 100644 drivers/net/wireless/silabs/wfx/Makefile
>
> diff --git a/drivers/net/wireless/silabs/wfx/Kconfig
> b/drivers/net/wireless/silabs/wfx/Kconfig
> new file mode 100644
> index 000000000000..83ee4d0ca8c6
> --- /dev/null
> +++ b/drivers/net/wireless/silabs/wfx/Kconfig
> @@ -0,0 +1,8 @@
> +config WFX
> +	tristate "Silicon Labs wireless chips WF200 and further"
> +	depends on MAC80211
> +	depends on MMC || !MMC # do not allow WFX=3Dy if MMC=3Dm
> +	depends on (SPI || MMC)
> +	help
> +	  This is a driver for Silicons Labs WFxxx series (WF200 and further)
> +	  chipsets. This chip can be found on SPI or SDIO buses.

Kconfig should mention about the SDIO id snafu and that Device Tree is
required.

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
