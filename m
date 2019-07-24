Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9709A72E3D
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 13:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387423AbfGXLyA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 07:54:00 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:53822 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727629AbfGXLx7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 07:53:59 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id A37FB6055C; Wed, 24 Jul 2019 11:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1563969238;
        bh=pm7NDOnvr959jvmO9/5v6TwMtjYbrE+WmELI0vfKg2U=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=nwJYIqlNBjvs+klRa2v/zL8iR+BhueyeOzmA79NpmrVJNhc3ePSSshqBSvpL3I3pd
         rfweQ73LoFO78pgJmvv8+CO2ZplBFsjucqDEnlyH/Jmfrrw4NHkkp9Q/H199RdQzpc
         APZXTfEFPMNTMJ5O1X7CyN383vEpDDk/I6DoW730=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,MISSING_DATE,MISSING_MID,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 48A6960258;
        Wed, 24 Jul 2019 11:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1563969238;
        bh=pm7NDOnvr959jvmO9/5v6TwMtjYbrE+WmELI0vfKg2U=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=Kbr9yRT+uDm+e12jCBIisrNd8uEx/2Uwu/DPinwDBXDQpuOyspy0KmEDy2KOI0UfI
         buFwbVzIxGQMfaZzO4ugc0VmCA1Yb9gfgwmCZcgV0Sduv/d6DDEHzktrQKs3hOkxPg
         pGTrSD7xPWu0MIPh5WwQFTQNg1YfhnWosMsWfB2g=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 48A6960258
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] libertas_tf: Use correct channel range in lbtf_geo_init
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190716144218.20608-1-yuehaibing@huawei.com>
References: <20190716144218.20608-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <davem@davemloft.net>, <lkundrak@v3.sk>, <derosier@cal-sierra.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190724115358.A37FB6055C@smtp.codeaurora.org>
Date:   Wed, 24 Jul 2019 11:53:58 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

YueHaibing <yuehaibing@huawei.com> wrote:

> It seems we should use 'range' instead of 'priv->range'
> in lbtf_geo_init(), because 'range' is the corret one
> related to current regioncode.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Fixes: 691cdb49388b ("libertas_tf: command helper functions for libertas_tf")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

2ec4ad49b98e libertas_tf: Use correct channel range in lbtf_geo_init

-- 
https://patchwork.kernel.org/patch/11046191/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

