Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06B16C46A3
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 06:33:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbfJBEdR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 00:33:17 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:48144 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725991AbfJBEdQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 00:33:16 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 1E3AF6118D; Wed,  2 Oct 2019 04:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1569990796;
        bh=y6aD8B4rwHqCi0mGCo59eVLQVMzOQ3zMMRnM5KzbB54=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=I1d1VGk6IYHL5Ql+tYTEn0UjzAGom4zWfuq/teAsNivosnNZibsv7tdSBdNjp2Js0
         AalKvO6qjwPPkawF9h69ouhRK3IhpWsDtI1uF50Kv4EST6GCF3YVmXNKD6jP0DBqwb
         lKNorcYF2IgiMy0nefjFNh6DEtGzyqQCCUHo5krk=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 49E43608CC;
        Wed,  2 Oct 2019 04:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1569990795;
        bh=y6aD8B4rwHqCi0mGCo59eVLQVMzOQ3zMMRnM5KzbB54=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=ULh0VeDs3YdPUJhhUmgWnsmS9+iEV7ViCpAV9LcpdSRmkYTkl9M4RqirNNxZGPLJO
         rypCJkF4IICJIIgu0tAt2dM77dnlBlm5d76JOi4Ht2aJCkn0QINSIk5kWhdkGeabTm
         crCLRU5h44Kfgu+zALUIipeHFtWJkyPc+WTTmp60=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 49E43608CC
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/6] rtlwifi: Remove set but not used variable 'rtstate'
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1569833692-93288-2-git-send-email-zhengbin13@huawei.com>
References: <1569833692-93288-2-git-send-email-zhengbin13@huawei.com>
To:     zhengbin <zhengbin13@huawei.com>
Cc:     <pkshih@realtek.com>, <davem@davemloft.net>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <zhengbin13@huawei.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191002043316.1E3AF6118D@smtp.codeaurora.org>
Date:   Wed,  2 Oct 2019 04:33:16 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

zhengbin <zhengbin13@huawei.com> wrote:

> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/wireless/realtek/rtlwifi/ps.c: In function rtl_ps_set_rf_state:
> drivers/net/wireless/realtek/rtlwifi/ps.c:71:19: warning: variable rtstate set but not used [-Wunused-but-set-variable]
> 
> It is not used since commit f1d2b4d338bf ("rtlwifi:
> rtl818x: Move drivers into new realtek directory")
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: zhengbin <zhengbin13@huawei.com>

5 patches applied to wireless-drivers-next.git, thanks.

4010758eb082 rtlwifi: Remove set but not used variable 'rtstate'
70906d941ccd rtlwifi: Remove set but not used variables 'dataempty','hoffset'
4a26e11500b8 rtlwifi: rtl8192ee: Remove set but not used variables 'short_gi','buf_len'
533e3de41205 rtlwifi: rtl8192ee: Remove set but not used variables 'reg_ecc','reg_eac'
66070e86878c rtlwifi: rtl8723be: Remove set but not used variables 'reg_ecc','reg_eac'

-- 
https://patchwork.kernel.org/patch/11166203/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

