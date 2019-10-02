Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB48C4693
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 06:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729835AbfJBE0G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 00:26:06 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:46296 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726411AbfJBE0G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 00:26:06 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 529B0601E7; Wed,  2 Oct 2019 04:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1569990365;
        bh=RIa0/sdQ4wDolecD+VCTngmzACfLt9L4lzi0R6k4E7A=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=WOPiIfLFoOs+YRPyFtvYe0a9OKs+lNBDKbGIOg+Bc3cytUSLc/Z6s9e1h6N07g0ec
         L5dWi12rIQZPrHHtBHialIb5YK3HeLqGD4YhmEKbhqYs67yqxgiHwOGOpbTAS5m724
         H0sSNoHr2bbEYytlsRSZJC0Nx8HSADYSugBefIfM=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1966F6074F;
        Wed,  2 Oct 2019 04:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1569990364;
        bh=RIa0/sdQ4wDolecD+VCTngmzACfLt9L4lzi0R6k4E7A=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=F8Bf25ffzaX6jT8ld8RKtehbV9/0kh0YGduNRjUHlPfOLdbmTKwQqLQwTM3d3bAwv
         ajIcGmmPEo5wC6N8HQ3y/k1DFct655Oqe+cbQSeWEY3/McDtcNb4ZsooRSXeubt2Uc
         NYY78Nl7LnJkskH76EGsg5AsHI4DTk79srMZGJgs=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 1966F6074F
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 3/6] rtlwifi: rtl8192ee: Remove set but not used variable
 'err'
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1569833692-93288-4-git-send-email-zhengbin13@huawei.com>
References: <1569833692-93288-4-git-send-email-zhengbin13@huawei.com>
To:     zhengbin <zhengbin13@huawei.com>
Cc:     <pkshih@realtek.com>, <davem@davemloft.net>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <zhengbin13@huawei.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191002042605.529B0601E7@smtp.codeaurora.org>
Date:   Wed,  2 Oct 2019 04:26:05 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

zhengbin <zhengbin13@huawei.com> wrote:

> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c: In function rtl92ee_download_fw:
> drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c:111:6: warning: variable err set but not used [-Wunused-but-set-variable]
> 
> It is not used since commit c93ac39da006 ("rtlwifi:
> Remove some redundant code")
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: zhengbin <zhengbin13@huawei.com>

Dropping this patch per Ping's comment, please fix and resend this
patch.

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/patch/11166207/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

