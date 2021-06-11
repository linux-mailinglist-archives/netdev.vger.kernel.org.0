Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40D4A3A47F7
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 19:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbhFKRh7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 13:37:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:38086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229480AbhFKRh4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Jun 2021 13:37:56 -0400
Received: from jic23-huawei (cpc108967-cmbg20-2-0-cust86.5-4.cable.virginm.net [81.101.6.87])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 292F960E0C;
        Fri, 11 Jun 2021 17:35:47 +0000 (UTC)
Date:   Fri, 11 Jun 2021 18:37:43 +0100
From:   Jonathan Cameron <jic23@kernel.org>
To:     trix@redhat.com
Cc:     robh+dt@kernel.org, tsbogend@alpha.franken.de, lars@metafoo.de,
        tomas.winkler@intel.com, arnd@arndb.de, gregkh@linuxfoundation.org,
        nbd@nbd.name, lorenzo.bianconi83@gmail.com, ryder.lee@mediatek.com,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        matthias.bgg@gmail.com, mcoquelin.stm32@gmail.com,
        alexandre.torgue@foss.st.com, apw@canonical.com, joe@perches.com,
        dwaipayanray1@gmail.com, lukas.bulwahn@gmail.com,
        chenhuacai@kernel.org, jiaxun.yang@flygoat.com,
        zhangqing@loongson.cn, jbhayana@google.com, sean.wang@mediatek.com,
        shayne.chen@mediatek.com, Soul.Huang@mediatek.com,
        shorne@gmail.com, gsomlo@gmail.com,
        pczarnecki@internships.antmicro.com, mholenko@antmicro.com,
        davidgow@google.com, devicetree@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com
Subject: Re: [PATCH 5/7] iio/scmi: fix spelling of SPDX tag
Message-ID: <20210611183743.6f65100f@jic23-huawei>
In-Reply-To: <20210610214438.3161140-7-trix@redhat.com>
References: <20210610214438.3161140-1-trix@redhat.com>
        <20210610214438.3161140-7-trix@redhat.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Jun 2021 14:44:36 -0700
trix@redhat.com wrote:

> From: Tom Rix <trix@redhat.com>
> 
> checkpatch looks for SPDX-License-Identifier.
> Remove the extra spaces.
> 
> Signed-off-by: Tom Rix <trix@redhat.com>
Applied this one to the togreg branch of iio.git (initially pushed out as testing
to let 0-day have first poke at it).  Thanks,

Jonathan

> ---
>  drivers/iio/common/scmi_sensors/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/iio/common/scmi_sensors/Makefile b/drivers/iio/common/scmi_sensors/Makefile
> index f13140a2575a4..645e0fce1a739 100644
> --- a/drivers/iio/common/scmi_sensors/Makefile
> +++ b/drivers/iio/common/scmi_sensors/Makefile
> @@ -1,4 +1,4 @@
> -# SPDX - License - Identifier : GPL - 2.0 - only
> +# SPDX-License-Identifier: GPL-2.0-only
>  #
>  # Makefile for the IIO over SCMI
>  #

