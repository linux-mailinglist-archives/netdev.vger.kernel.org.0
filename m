Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7A26F1CF8
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 18:57:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732475AbfKFR4w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 12:56:52 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:35934 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729435AbfKFR4w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 12:56:52 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id E537660134; Wed,  6 Nov 2019 17:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573063010;
        bh=nQ+P7pXx778DX1/XphSgc5IhHKuslBvN8ajv5VvEmxU=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=FNbKbf+hcv2URueWbVdvZ0S25w8iTl82Q6TiJ8Yk0Mpix9jlzrDpVNtlNuT80Qf7M
         RvyuBy/NgDx5nE9F8DPudiaeV9c1/8iwLVE2nlXod0TDdDlFknITylabKkgIJjaYaw
         ZTMQO1Gr2ikGmFCboS2JZYjl0XIMiSAlHhKElqMg=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id AB0C8601D4;
        Wed,  6 Nov 2019 17:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573063010;
        bh=nQ+P7pXx778DX1/XphSgc5IhHKuslBvN8ajv5VvEmxU=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=VKc9x2sQgEtMEFTKscLB6q8EVrIiHCkAaiUiJ/yxXSNjPJgZmsRMbQUahC+xu3ehg
         D9ZMEAEGyxcxW5CTmN5+HwgoMeBQnKgAd6PyJB8LiVqt7A+FYUK7PapoxUwXUOocRi
         60oQXgkxN0SZPdh+xLMywBe841nkAEOCDeleqOnA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org AB0C8601D4
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtlwifi: rtl8225se: remove some unused const variables
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20191102074603.38516-1-yuehaibing@huawei.com>
References: <20191102074603.38516-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <davem@davemloft.net>, <allison@lohutok.net>,
        <gregkh@linuxfoundation.org>, <kstewart@linuxfoundation.org>,
        <info@metux.net>, <tglx@linutronix.de>, <yuehaibing@huawei.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191106175650.E537660134@smtp.codeaurora.org>
Date:   Wed,  6 Nov 2019 17:56:50 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

YueHaibing <yuehaibing@huawei.com> wrote:

> drivers/net/wireless//realtek/rtl818x/rtl8180/rtl8225se.c:83:17: warning: 'rtl8225sez2_tx_power_cck' defined but not used [-Wunused-const-variable=]
> drivers/net/wireless//realtek/rtl818x/rtl8180/rtl8225se.c:79:17: warning: 'rtl8225sez2_tx_power_cck_A' defined but not used [-Wunused-const-variable=]
> drivers/net/wireless//realtek/rtl818x/rtl8180/rtl8225se.c:75:17: warning: 'rtl8225sez2_tx_power_cck_B' defined but not used [-Wunused-const-variable=]
> drivers/net/wireless//realtek/rtl818x/rtl8180/rtl8225se.c:71:17: warning: 'rtl8225sez2_tx_power_cck_ch14' defined but not used [-Wunused-const-variable=]
> drivers/net/wireless//realtek/rtl818x/rtl8180/rtl8225se.c:62:17: warning: 'rtl8225se_tx_power_ofdm' defined but not used [-Wunused-const-variable=]
> drivers/net/wireless//realtek/rtl818x/rtl8180/rtl8225se.c:53:17: warning: 'rtl8225se_tx_power_cck_ch14' defined but not used [-Wunused-const-variable=]
> drivers/net/wireless//realtek/rtl818x/rtl8180/rtl8225se.c:44:17: warning: 'rtl8225se_tx_power_cck' defined but not used [-Wunused-const-variable=]
> drivers/net/wireless//realtek/rtl818x/rtl8180/rtl8225se.c:40:17: warning: 'rtl8225se_tx_gain_cck_ofdm' defined but not used [-Wunused-const-variable=]
> 
> They are never used, so can be removed.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

a3a03716196f rtlwifi: rtl8225se: remove some unused const variables

-- 
https://patchwork.kernel.org/patch/11224057/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

