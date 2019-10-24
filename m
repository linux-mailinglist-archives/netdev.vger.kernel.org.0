Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54378E2A24
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 07:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408519AbfJXFt1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 01:49:27 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:53152 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404449AbfJXFt1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 01:49:27 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id C703660D7D; Thu, 24 Oct 2019 05:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571896166;
        bh=zBJyyCBKj4sAv/VGa+BHTvcgD+ISVRuOWnhGH3Cx1/I=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=ScY9rk20XR2tr+LMQ6vXkleajeQuwZnWkgBWp1jBoBGV3kXC9RgjJY4vyFkToRKL4
         vWgXkfiKY/PoxVUoBQy1VkmfdtvYC6iSXAx9v7tdZe+8cDPJ9sPSfAaJMtdp+McZD7
         cPnt5UzbqXQ2Qrs5c+Nw+ynDqF3DOufu1y1UrdJM=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,MISSING_DATE,MISSING_MID,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (unknown [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DAC9060B6E;
        Thu, 24 Oct 2019 05:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571896166;
        bh=zBJyyCBKj4sAv/VGa+BHTvcgD+ISVRuOWnhGH3Cx1/I=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=f2F4JqiBb6VEkOHBAa+diGGZE0/e1vb7yZoTku5m0QS+aOkbTJHt3hswxjn3RgAUe
         WPLZhUHirsGBM24hHdfkk0uxPCxn0fq06vGumjhEsht18UXgOsY34nPPnyN/w2WrU8
         09iycX9TgS9hPDZf1Vw8dywzv3iFeK1rlWbbh9EI=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org DAC9060B6E
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtl8xxxu: remove set but not used variable 'rate_mask'
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20191023075342.26656-1-yuehaibing@huawei.com>
References: <20191023075342.26656-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <Jes.Sorensen@gmail.com>, <davem@davemloft.net>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191024054926.C703660D7D@smtp.codeaurora.org>
Date:   Thu, 24 Oct 2019 05:49:26 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

YueHaibing <yuehaibing@huawei.com> wrote:

> drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c:4484:6:
>  warning: variable rate_mask set but not used [-Wunused-but-set-variable]
> 
> It is never used since commit a9bb0b515778 ("rtl8xxxu: Improve
> TX performance of RTL8723BU on rtl8xxxu driver")
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

4fcef8609132 rtl8xxxu: remove set but not used variable 'rate_mask'

-- 
https://patchwork.kernel.org/patch/11205849/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

