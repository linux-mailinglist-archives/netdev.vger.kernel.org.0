Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 182D141E968
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 11:06:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352853AbhJAJIi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 05:08:38 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:15923 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352865AbhJAJIh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 05:08:37 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1633079213; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: In-Reply-To: Date: References: Subject: Cc:
 To: From: Sender; bh=6bQDWcDi7avoxUXWzlznZhXymgDiWCWV7nuIi3PdecU=; b=C1jGRp+cyzhyMrCnxr7i8E6pcsDZP8WOq4N+5NUtiN9ddjOVjoLE61QnM4755iazzlW7/icF
 bVRcdh25uOxyyE8E0SmLgbkJfio84OdNqEIwpBmr7unEvstDe2UvmOgYVj7js8DtKR5iCtIS
 T9Wh5NTG0gx7pRQrH4gAs5cSiuU=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 6156cfa6519bd8dcf09be72c (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 01 Oct 2021 09:06:46
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id AAE75C4360D; Fri,  1 Oct 2021 09:06:46 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 32F95C4338F;
        Fri,  1 Oct 2021 09:06:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 32F95C4338F
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
Subject: Re: [PATCH v7 03/24] wfx: add Makefile/Kconfig
References: <20210920161136.2398632-1-Jerome.Pouiller@silabs.com>
        <20210920161136.2398632-4-Jerome.Pouiller@silabs.com>
Date:   Fri, 01 Oct 2021 12:06:40 +0300
In-Reply-To: <20210920161136.2398632-4-Jerome.Pouiller@silabs.com> (Jerome
        Pouiller's message of "Mon, 20 Sep 2021 18:11:15 +0200")
Message-ID: <8735plm7vj.fsf@codeaurora.org>
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
> +++ b/drivers/net/wireless/silabs/wfx/Makefile
> @@ -0,0 +1,26 @@
> +# SPDX-License-Identifier: GPL-2.0

All other files use GPL-2.0-only:

bh.c:// SPDX-License-Identifier: GPL-2.0-only
bh.h:/* SPDX-License-Identifier: GPL-2.0-only */
bus.h:/* SPDX-License-Identifier: GPL-2.0-only */
bus_sdio.c:// SPDX-License-Identifier: GPL-2.0-only
bus_spi.c:// SPDX-License-Identifier: GPL-2.0-only
data_rx.c:// SPDX-License-Identifier: GPL-2.0-only

I don't remember what's the difference, if any, but having consistent
SPDX tags would be nice.

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
