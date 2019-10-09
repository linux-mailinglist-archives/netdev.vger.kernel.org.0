Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3427AD0995
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 10:23:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729841AbfJIIXO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 04:23:14 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:56858 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726698AbfJIIXO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 04:23:14 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id F072761C0B; Wed,  9 Oct 2019 08:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570609393;
        bh=+ER2l7QyQqmRjgzsuJZtEAcUaI+MNTnPl4Iq9yddUeg=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=lW190IE+SqzCfpgxmpy5I/gHXPFCPenRX34PtcU+KepFOh79cLwys7K0J0OFNRovG
         xK8H5DEp4dWlJZjwea+E60Blwg0q8k3owTKFP9L4TCTg2atmvOTDnOCBhwa9BXdNYd
         0+kzOUPvxcaeecJwjin+qpffH+cgJrSVfmDz6rxI=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 58A9361C0B;
        Wed,  9 Oct 2019 08:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570609391;
        bh=+ER2l7QyQqmRjgzsuJZtEAcUaI+MNTnPl4Iq9yddUeg=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=MsO/SH/UYIPCWEu5cYUYLiTXC9cLsdfBZZ1XmVWYxXMYYesvaO/Ipf+OTG44d8AAa
         eg3X0C1BOMfgJ9RpGOp5xCRu/Fh9KDvK4CldEN5tGZYQsKMkKeedWjl0CahjulmRmq
         sB65Lmne+bYfJBdC5MCD2Bf0wIa5BpCZjWI3Ygak=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 58A9361C0B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/8] rtlwifi: rtl8821ae: Remove set but not used variables
 'rtstatus', 'bd'
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1570178635-57582-2-git-send-email-zhengbin13@huawei.com>
References: <1570178635-57582-2-git-send-email-zhengbin13@huawei.com>
To:     zhengbin <zhengbin13@huawei.com>
Cc:     <pkshih@realtek.com>, <davem@davemloft.net>,
        <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <zhengbin13@huawei.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191009082312.F072761C0B@smtp.codeaurora.org>
Date:   Wed,  9 Oct 2019 08:23:12 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

zhengbin <zhengbin13@huawei.com> wrote:

> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c: In function rtl8812ae_phy_config_rf_with_headerfile:
> drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c:2079:7: warning: variable rtstatus set but not used [-Wunused-but-set-variable]
> drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c: In function rtl8821ae_phy_config_rf_with_headerfile:
> drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c:2114:7: warning: variable rtstatus set but not used [-Wunused-but-set-variable]
> drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c: In function _rtl8812ae_phy_get_txpower_limit:
> drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c:2354:6: warning: variable bd set but not used [-Wunused-but-set-variable]
> 
> They are not used since commit f1d2b4d338bf ("rtlwifi:
> rtl818x: Move drivers into new realtek directory")
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: zhengbin <zhengbin13@huawei.com>

8 patches applied to wireless-drivers-next.git, thanks.

0fc44cd4c480 rtlwifi: rtl8821ae: Remove set but not used variables 'rtstatus','bd'
a3e017fd8932 rtlwifi: rtl8723ae: Remove set but not used variables 'reg_ecc','reg_ec4','reg_eac','b_pathb_ok'
a003aec306c8 rtlwifi: rtl8192c: Remove set but not used variables 'reg_ecc','reg_eac'
925942b5da09 rtlwifi: rtl8188ee: Remove set but not used variables 'v3','rtstatus','reg_ecc','reg_ec4','reg_eac','b_pathb_ok'
073f8138f598 rtlwifi: rtl8188ee: Remove set but not used variable 'h2c_parameter'
e25076070201 rtlwifi: btcoex: Remove set but not used variable 'result'
aab7541a5a8b rtlwifi: btcoex: Remove set but not used variables 'wifi_busy','bt_info_ext'
4614239cba34 rtlwifi: rtl8723: Remove set but not used variable 'own'

-- 
https://patchwork.kernel.org/patch/11173861/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

