Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F87C2AA69E
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 17:16:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728415AbgKGQQB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 11:16:01 -0500
Received: from m42-4.mailgun.net ([69.72.42.4]:19959 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726297AbgKGQQB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Nov 2020 11:16:01 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1604765760; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=yhmc/4tFcs6/ljdXZP2KS0wx0WYz/n+ogGlaNkCjmrM=;
 b=sFVxlmFgri4r9GRS9cp667hRef+vplfgftjH4Lm4mtQMV43kp0X1wtxM4HNpIljzo0yOzxBs
 NiZCZhdx9/89DXnI2ip7hk7Ijz0Kt/oACaSwf943MNGm3NuyJK+1VyK61/L0oW6Qkw12Brms
 2/6m68chdkcPSeuov9b/1yXkIRQ=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 5fa6c8248c0d657314464acf (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 07 Nov 2020 16:15:32
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 0A318C433CB; Sat,  7 Nov 2020 16:15:32 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0A013C433C6;
        Sat,  7 Nov 2020 16:15:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0A013C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [03/41] rtlwifi: rtl8192cu: mac: Fix some missing/ill-documented
 function parameters
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20201102112410.1049272-4-lee.jones@linaro.org>
References: <20201102112410.1049272-4-lee.jones@linaro.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Ping-Ke Shih <pkshih@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20201107161532.0A318C433CB@smtp.codeaurora.org>
Date:   Sat,  7 Nov 2020 16:15:32 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lee Jones <lee.jones@linaro.org> wrote:

> Fixes the following W=1 kernel build warning(s):
> 
>  drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.c:124: warning: Function parameter or member 'hw' not described in 'rtl92c_llt_write'
>  drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.c:124: warning: Excess function parameter 'io' description in 'rtl92c_llt_write'
>  drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.c:155: warning: Function parameter or member 'hw' not described in 'rtl92c_init_llt_table'
>  drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.c:155: warning: Excess function parameter 'io' description in 'rtl92c_init_llt_table'
> 
> Cc: Ping-Ke Shih <pkshih@realtek.com>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

11 patches applied to wireless-drivers-next.git, thanks.

230f874e4d95 rtlwifi: rtl8192cu: mac: Fix some missing/ill-documented function parameters
906a1b4f81a3 rtlwifi: rtl8192cu: trx: Demote clear abuse of kernel-doc format
bb053d0251a2 rtlwifi: halbtc8723b2ant: Remove a bunch of set but unused variables
87b08d1ecb93 rtlwifi: phy: Remove set but unused variable 'bbvalue'
0c73dab72f53 rtlwifi: halbtc8821a1ant: Remove set but unused variable 'wifi_rssi_state'
0a43d993ee7e rtlwifi: rtl8723be: Remove set but unused variable 'lc_cal'
6c75eab0417b rtlwifi: rtl8188ee: Remove set but unused variable 'reg_ea4'
28f811876262 rtlwifi: halbtc8821a2ant: Remove a bunch of unused variables
44ec6d9df96d rtlwifi: rtl8723be: Remove set but unused variable 'cck_highpwr'
29c6099a3890 rtlwifi: rtl8821ae: phy: Remove a couple of unused variables
398d816a64eb rtlwifi: rtl8821ae: Place braces around empty if() body

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20201102112410.1049272-4-lee.jones@linaro.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

