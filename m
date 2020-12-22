Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACBFC2E0CA0
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 16:22:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728010AbgLVPVp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 10:21:45 -0500
Received: from m43-15.mailgun.net ([69.72.43.15]:58459 "EHLO
        m43-15.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727867AbgLVPVn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 10:21:43 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1608650483; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=zdYObwsY2r8z2o2KPE7CUgSBuK7IkUOZ8qoqY6T5wcw=; b=EaXM4aO5IP+d8PX5Cg2ahUgu3oXGgaT9jhxLVx3NUpwKsYG04rwmuBBLVpbAcUgu4zCUtAfK
 b5kjD0o/YabTErQ2n8ZK4o7oEFqejctSSF5N/+MFERaeyAMMdugopontCDg/jzkucB6Vxgq2
 j+CQH0mkCE/V79x7aqs4DmbY7Ug=
X-Mailgun-Sending-Ip: 69.72.43.15
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 5fe20ed46d011aad6629c0bc (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 22 Dec 2020 15:20:52
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id E9043C43463; Tue, 22 Dec 2020 15:20:51 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from x230.qca.qualcomm.com (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4F788C433C6;
        Tue, 22 Dec 2020 15:20:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 4F788C433C6
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
Subject: Re: [PATCH v3 12/24] wfx: add hif_api_*.h
References: <20201104155207.128076-1-Jerome.Pouiller@silabs.com>
        <20201104155207.128076-13-Jerome.Pouiller@silabs.com>
Date:   Tue, 22 Dec 2020 17:20:46 +0200
In-Reply-To: <20201104155207.128076-13-Jerome.Pouiller@silabs.com> (Jerome
        Pouiller's message of "Wed, 4 Nov 2020 16:51:55 +0100")
Message-ID: <87h7od98a9.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jerome Pouiller <Jerome.Pouiller@silabs.com> writes:

> --- /dev/null
> +++ b/drivers/net/wireless/silabs/wfx/hif_api_general.h
> @@ -0,0 +1,267 @@
> +/* SPDX-License-Identifier: Apache-2.0 */
> +/*
> + * WFx hardware interface definitions
> + *
> + * Copyright (c) 2018-2020, Silicon Laboratories Inc.
> + */
> +
> +#ifndef WFX_HIF_API_GENERAL_H
> +#define WFX_HIF_API_GENERAL_H
> +
> +#ifdef __KERNEL__
> +#include <linux/types.h>
> +#include <linux/if_ether.h>
> +#else
> +#include <net/ethernet.h>
> +#include <stdint.h>
> +#define __packed __attribute__((__packed__))
> +#endif

Why check for __KERNEL__ and redefined __packed? These don't belong to a
wireless driver.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
