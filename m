Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 790912CC5DA
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 19:50:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730832AbgLBSuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 13:50:18 -0500
Received: from a2.mail.mailgun.net ([198.61.254.61]:10081 "EHLO
        a2.mail.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728649AbgLBSuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 13:50:18 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1606934993; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=FGxsOL5le8HRJQR6tlEK29rA5Su+CsaXXEfwJS9SH4Q=;
 b=WKRviKiC9ibVnrhAgw4ro8QU5X4vZjfFYmMdCVyLSDWTT1Sobt4xinWrPhK1yqSF7HBw3b1H
 acgbijTghO5di9hlmsuDgYhZHF9tXbRit1XrRkbzUt5tf/UFzvRyoadDYnwaz+UXlyTIQ4Fm
 4IgJIV/I0ikwFpOhUscvfDdeU5o=
X-Mailgun-Sending-Ip: 198.61.254.61
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n10.prod.us-west-2.postgun.com with SMTP id
 5fc7e1b64a918fcc078f5c49 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 02 Dec 2020 18:49:26
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 04078C433C6; Wed,  2 Dec 2020 18:49:26 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id ACC63C433ED;
        Wed,  2 Dec 2020 18:49:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org ACC63C433ED
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 03/17] ath9k: ar9330_1p1_initvals: Remove unused const
 variable 'ar9331_common_tx_gain_offset1_1'
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20201126133152.3211309-4-lee.jones@linaro.org>
References: <20201126133152.3211309-4-lee.jones@linaro.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     lee.jones@linaro.org, linux-kernel@vger.kernel.org,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20201202184926.04078C433C6@smtp.codeaurora.org>
Date:   Wed,  2 Dec 2020 18:49:26 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lee Jones <lee.jones@linaro.org> wrote:

> Fixes the following W=1 kernel build warning(s):
> 
>  drivers/net/wireless/ath/ath9k/ar9330_1p1_initvals.h:1013:18: warning: ‘ar9331_common_tx_gain_offset1_1’ defined but not used [-Wunused-const-variable=]
> 
> Cc: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

ath9k patches fail to apply:

error: patch failed: drivers/net/wireless/ath/ath9k/ar9330_1p1_initvals.h:1010
error: drivers/net/wireless/ath/ath9k/ar9330_1p1_initvals.h: patch does not apply
stg import: Diff does not apply cleanly

6 patches set to Changes Requested.

11933887 [03/17] ath9k: ar9330_1p1_initvals: Remove unused const variable 'ar9331_common_tx_gain_offset1_1'
11933889 [04/17] ath9k: ar9340_initvals: Remove unused const variable 'ar9340Modes_ub124_tx_gain_table_1p0'
11933883 [05/17] ath9k: ar9485_initvals: Remove unused const variable 'ar9485_fast_clock_1_1_baseband_postamble'
11933879 [06/17] ath9k: ar9003_2p2_initvals: Remove unused const variables
11933861 [10/17] ath9k: ar5008_phy: Demote half completed function headers
11933875 [15/17] ath9k: dynack: Demote non-compliant function header

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20201126133152.3211309-4-lee.jones@linaro.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

