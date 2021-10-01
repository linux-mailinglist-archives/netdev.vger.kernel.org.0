Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 723F341ECB0
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 13:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354189AbhJAMAv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 08:00:51 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:48878 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354158AbhJAMAs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 08:00:48 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1633089544; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: In-Reply-To: Date: References: Subject: Cc:
 To: From: Sender; bh=gh+rxO6W9CGfXjbfCmIpOQMXtVKYgt25V055BZp/pL8=; b=HtoI/ey54rY3mHn5jAQUf11jQI1EO4g19oy+zxmDZ692Eu+EmlJDuUMgntzl2V1cmlOCvTI3
 oD6ehdG7yhmGvhwwxw6ilpWyswW8BJEVczF5kP1k9Bwil+UC8gwQroV+4ho9NhDNdJfHsJ/G
 3xaH+HJPmRAeOYFGJ5ha+/DUthc=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 6156f7f4a3e8d3c640dd85b3 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 01 Oct 2021 11:58:44
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id E6B88C43619; Fri,  1 Oct 2021 11:58:43 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 32663C4338F;
        Fri,  1 Oct 2021 11:58:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 32663C4338F
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
Subject: Re: [PATCH v7 10/24] wfx: add fwio.c/fwio.h
References: <20210920161136.2398632-1-Jerome.Pouiller@silabs.com>
        <20210920161136.2398632-11-Jerome.Pouiller@silabs.com>
Date:   Fri, 01 Oct 2021 14:58:38 +0300
In-Reply-To: <20210920161136.2398632-11-Jerome.Pouiller@silabs.com> (Jerome
        Pouiller's message of "Mon, 20 Sep 2021 18:11:22 +0200")
Message-ID: <87sfxlj6s1.fsf@codeaurora.org>
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

> +static int get_firmware(struct wfx_dev *wdev, u32 keyset_chip,
> +			const struct firmware **fw, int *file_offset)
> +{
> +	int keyset_file;
> +	char filename[256];
> +	const char *data;
> +	int ret;
> +
> +	snprintf(filename, sizeof(filename), "%s_%02X.sec",
> +		 wdev->pdata.file_fw, keyset_chip);
> +	ret =3D firmware_request_nowarn(fw, filename, wdev->dev);
> +	if (ret) {
> +		dev_info(wdev->dev, "can't load %s, falling back to %s.sec\n",
> +			 filename, wdev->pdata.file_fw);
> +		snprintf(filename, sizeof(filename), "%s.sec",
> +			 wdev->pdata.file_fw);
> +		ret =3D request_firmware(fw, filename, wdev->dev);
> +		if (ret) {
> +			dev_err(wdev->dev, "can't load %s\n", filename);
> +			*fw =3D NULL;
> +			return ret;
> +		}
> +	}

How is this firmware file loading supposed to work? If I'm reading the
code right, the driver tries to load file "wfm_wf200_??.sec" but in
linux-firmware the file is silabs/wfm_wf200_C0.sec:

https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git=
/tree/silabs

That can't work automatically, unless I'm missing something of course.

Also I would prefer to use directory name as the driver name wfx, but I
guess silabs is also doable.

Also I'm not seeing the PDS files in linux-firmware. The idea is that
when user installs an upstream kernel and the linux-firmware everything
will work automatically, without any manual file installations.

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
