Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E113341EC7C
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 13:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353880AbhJALrj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 07:47:39 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:56420 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353877AbhJALri (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 07:47:38 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1633088755; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: In-Reply-To: Date: References: Subject: Cc:
 To: From: Sender; bh=YxKSm706CYmC7dlY4TeabSYZk/p/Y9Jzdo8dW/FTdPs=; b=xEV3ziTgFnPU9Ts3p4ipJhB2GFQ+Jc+8XuIjhZ33iSRJptiC46sPC9rjZAzlJvdtcWJV/RlY
 LJRli7vpewzXgkKgZKb48SrCO06dN2H+CRiWoR5M5G7ERs5xB9DERqD3wuV7g0xE74eSGK8y
 Tf2fuF8S0XnVQrXRkIvFaVcRlVU=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 6156f4f2a3e8d3c640d3b6c9 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 01 Oct 2021 11:45:54
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id C4E98C43617; Fri,  1 Oct 2021 11:45:53 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1ABFDC43460;
        Fri,  1 Oct 2021 11:45:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 1ABFDC43460
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
Subject: Re: [PATCH v7 12/24] wfx: add hif_api_*.h
References: <20210920161136.2398632-1-Jerome.Pouiller@silabs.com>
        <20210920161136.2398632-13-Jerome.Pouiller@silabs.com>
Date:   Fri, 01 Oct 2021 14:45:42 +0300
In-Reply-To: <20210920161136.2398632-13-Jerome.Pouiller@silabs.com> (Jerome
        Pouiller's message of "Mon, 20 Sep 2021 18:11:24 +0200")
Message-ID: <871r55kly1.fsf@codeaurora.org>
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

> +#define HIF_STATUS_SUCCESS                         (cpu_to_le32(0x0000))
> +#define HIF_STATUS_FAIL                            (cpu_to_le32(0x0001))
> +#define HIF_STATUS_INVALID_PARAMETER               (cpu_to_le32(0x0002))
> +#define HIF_STATUS_WARNING                         (cpu_to_le32(0x0003))
> +#define HIF_STATUS_UNKNOWN_REQUEST                 (cpu_to_le32(0x0004))
> +#define HIF_STATUS_RX_FAIL_DECRYPT                 (cpu_to_le32(0x0010))
> +#define HIF_STATUS_RX_FAIL_MIC                     (cpu_to_le32(0x0011))
> +#define HIF_STATUS_RX_FAIL_NO_KEY                  (cpu_to_le32(0x0012))
> +#define HIF_STATUS_TX_FAIL_RETRIES                 (cpu_to_le32(0x0013))
> +#define HIF_STATUS_TX_FAIL_TIMEOUT                 (cpu_to_le32(0x0014))
> +#define HIF_STATUS_TX_FAIL_REQUEUE                 (cpu_to_le32(0x0015))
> +#define HIF_STATUS_REFUSED                         (cpu_to_le32(0x0016))
> +#define HIF_STATUS_BUSY                            (cpu_to_le32(0x0017))
> +#define HIF_STATUS_SLK_SET_KEY_SUCCESS             (cpu_to_le32(0x005A))
> +#define HIF_STATUS_SLK_SET_KEY_ALREADY_BURNED      (cpu_to_le32(0x006B))
> +#define HIF_STATUS_SLK_SET_KEY_DISALLOWED_MODE     (cpu_to_le32(0x007C))
> +#define HIF_STATUS_SLK_SET_KEY_UNKNOWN_MODE        (cpu_to_le32(0x008D))
> +#define HIF_STATUS_SLK_NEGO_SUCCESS                (cpu_to_le32(0x009E))
> +#define HIF_STATUS_SLK_NEGO_FAILED                 (cpu_to_le32(0x00AF))
> +#define HIF_STATUS_ROLLBACK_SUCCESS                (cpu_to_le32(0x1234))
> +#define HIF_STATUS_ROLLBACK_FAIL                   (cpu_to_le32(0x1256))

I think it's a bad idea to use cpu_to_le32 here. Just define in cpu
order and use cpu_to_le32() whenever using these defines.

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
