Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F712D09DE
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 10:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730252AbfJII3e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 04:29:34 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:37964 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725848AbfJII3d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 04:29:33 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 038F361AE9; Wed,  9 Oct 2019 08:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570609772;
        bh=y6pHvsteVVddO1oRHUQgNok3Gee8CWsJokmvjN8Sk74=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=G+4KrqCijv9YnTkjLgjZAq37Qgw2kjZQ2xtFPoGKVUR3eKvfFb+v1/9AQdlqSPZu5
         O5l/0xfRQRSzC5MXTgykWPwPKRSefdPybs91Y+acDaTR/CL7uyQoxu/1kllecy5RuU
         sTnJPLQhz4FnN+GI/y0OHW7Zn4OYVAsCe+UDy71U=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 521E361E87;
        Wed,  9 Oct 2019 08:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570609767;
        bh=y6pHvsteVVddO1oRHUQgNok3Gee8CWsJokmvjN8Sk74=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=C15n/aiao1uAqpBMypOxiLsaIOOfFtqubdd4aS66Hy/014gq8lgQMTVIexaI5FMdL
         95TbDhBShx4bHDkRwhSbChA9E6Wl5zfzolG15NYRSGdYxxtFcYwIAW+srPu5Gc7l8O
         sh5fIjLcMiRhgO6I7RKBeZRNh3hNXB9VjgIwPB+E=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 521E361E87
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtlwifi: rtl8192ee: Remove set but not used variable
 'cur_tx_wp'
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1570500100-61244-1-git-send-email-zhengbin13@huawei.com>
References: <1570500100-61244-1-git-send-email-zhengbin13@huawei.com>
To:     zhengbin <zhengbin13@huawei.com>
Cc:     <pkshih@realtek.com>, <davem@davemloft.net>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <zhengbin13@huawei.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191009082932.038F361AE9@smtp.codeaurora.org>
Date:   Wed,  9 Oct 2019 08:29:28 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

zhengbin <zhengbin13@huawei.com> wrote:

> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c: In function rtl92ee_is_tx_desc_closed:
> drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c:1005:18: warning: variable cur_tx_wp set but not used [-Wunused-but-set-variable]
> 
> It is not used since commit cf54622c8076 ("rtlwifi:
> cleanup the code that check whether TX ring is available")
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: zhengbin <zhengbin13@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

ac8efe4f4a84 rtlwifi: rtl8192ee: Remove set but not used variable 'cur_tx_wp'

-- 
https://patchwork.kernel.org/patch/11178717/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

