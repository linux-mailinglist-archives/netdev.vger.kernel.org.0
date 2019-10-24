Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5DCE2A21
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 07:48:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408504AbfJXFsu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 01:48:50 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:53014 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404449AbfJXFsu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 01:48:50 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 5BEE860E74; Thu, 24 Oct 2019 05:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571896129;
        bh=0+XpGRo4KJBK5nPTsN/tQ2wYFnwui5wKor6T9RGaQr4=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=aU1dnSyKi6CRyvfCOOBwZpwNhGSA19HP3FF8wE1DASDn+H8g/ju5biXiOyaUeHnLj
         xD2h2j2868+owCJoYlAsamRgnN8c2qKwmS6pdWVrfCrrIHateOIuQVfLtdbNxiS6XN
         +ofPxUI0qJmUdQfBqnS/K1C2Dmxj4DN8lU05fYGA=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7821660DA9;
        Thu, 24 Oct 2019 05:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571896129;
        bh=0+XpGRo4KJBK5nPTsN/tQ2wYFnwui5wKor6T9RGaQr4=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=WwHHq0VN8npqlTYYK2wpdSPOBRmtz0BTHOK10nZrxmdo/39HYJRba6ZwY94ezRaCa
         qn6+UEfQFWJA7tZbpcbMehFeIK3+hWwSoMPRYuY0IQts6Rnh9sRabwkn0XTVVo1JZk
         Mk6nrIQx/XSDKPKNAV69QvBa7otWNFakw14Dvbik=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7821660DA9
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] atmel: remove set but not used variable 'dev'
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20191023074019.29708-1-yuehaibing@huawei.com>
References: <20191023074019.29708-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <simon@thekelleys.org.uk>, <davem@davemloft.net>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191024054849.5BEE860E74@smtp.codeaurora.org>
Date:   Thu, 24 Oct 2019 05:48:49 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

YueHaibing <yuehaibing@huawei.com> wrote:

> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/wireless/atmel/atmel_cs.c:120:21:
>  warning: variable dev set but not used [-Wunused-but-set-variable]
> 
> It is never used, so can remove it.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

d0c160b18ef5 atmel: remove set but not used variable 'dev'

-- 
https://patchwork.kernel.org/patch/11205835/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

