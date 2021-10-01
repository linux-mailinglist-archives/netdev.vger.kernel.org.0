Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A14B41EC8A
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 13:49:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353918AbhJALu4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 07:50:56 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:60437 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353899AbhJALur (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 07:50:47 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1633088944; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: In-Reply-To: Date: References: Subject: Cc:
 To: From: Sender; bh=bttwt/gBeucZtbTJvrBvHIv/d1PTWoUeIF2t4CtWbIY=; b=lpcRtqRO96OaynFZWipPDD4nLgP2/1qoIO/XpcHTVbzbEWFqBVNba2GJZAl6lPSoMVPzQTSp
 YCB6jmBtGmGpjrsEtvyoUGxSAyP5HznfcZC7ReoUpNzU0AEH9/tTpnXUH7mNPTHMwDPSklfX
 a8MfIpZgVdHQbAq0CMHcqLcVurY=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 6156f599605ecf100bb8c1a9 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 01 Oct 2021 11:48:41
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id A20D9C43460; Fri,  1 Oct 2021 11:48:41 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 22C83C4338F;
        Fri,  1 Oct 2021 11:48:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 22C83C4338F
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
Date:   Fri, 01 Oct 2021 14:48:36 +0300
In-Reply-To: <20210920161136.2398632-13-Jerome.Pouiller@silabs.com> (Jerome
        Pouiller's message of "Mon, 20 Sep 2021 18:11:24 +0200")
Message-ID: <87wnmxj78r.fsf@codeaurora.org>
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

> --- /dev/null
> +++ b/drivers/net/wireless/silabs/wfx/hif_api_general.h
> @@ -0,0 +1,256 @@
> +/* SPDX-License-Identifier: Apache-2.0 */
> +/*
> + * WF200 hardware interface definitions
> + *
> + * Copyright (c) 2018-2020, Silicon Laboratories Inc.
> + */
> +
> +#ifndef WFX_HIF_API_GENERAL_H
> +#define WFX_HIF_API_GENERAL_H
> +
> +#include <linux/types.h>
> +#include <linux/if_ether.h>

I'm looking at staging-next (commit 42ce32b1ae54) while reviewing the
driver and there I see:

#ifndef WFX_HIF_API_GENERAL_H
#define WFX_HIF_API_GENERAL_H

#ifdef __KERNEL__
#include <linux/types.h>
#include <linux/if_ether.h>
#else
#include <net/ethernet.h>
#include <stdint.h>
#define __packed __attribute__((__packed__))
#endif

I don't know what's causing the difference, but that ifdef __KERNEL__
looks useless.

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
