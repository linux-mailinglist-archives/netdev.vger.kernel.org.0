Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84DBC2775C2
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 17:48:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728551AbgIXPsn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 11:48:43 -0400
Received: from z5.mailgun.us ([104.130.96.5]:28847 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728448AbgIXPsl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Sep 2020 11:48:41 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1600962521; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=Sjl9wunnHhbDBefPvYSya2E0YyYkeliUtysS/WiPdH0=;
 b=WABdGiA5gtYWuTLpwJUc3KSB0mLS+rHJSMnVcHysN2UJuGAJ2btTworaJpMddpx2hlN38A2+
 zT/WukXWTOr9nrI3ZygoodYRhT/u/V3aHo9kaBE1qxPeEkY3GfaUVV6Ow8e61cCNAtyFfqfW
 4/iyFpycqJrWjT+VHMieO9FyIzM=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 5f6cbfbe971b64f61b5afd80 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 24 Sep 2020 15:48:14
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 78757C433FF; Thu, 24 Sep 2020 15:48:13 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DFA09C433CA;
        Thu, 24 Sep 2020 15:48:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org DFA09C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] brcmfmac: check return value of
 driver_for_each_device()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1600481191-14250-1-git-send-email-zhangchangzhong@huawei.com>
References: <1600481191-14250-1-git-send-email-zhangchangzhong@huawei.com>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>
Cc:     <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200924154813.78757C433FF@smtp.codeaurora.org>
Date:   Thu, 24 Sep 2020 15:48:13 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zhang Changzhong <zhangchangzhong@huawei.com> wrote:

> Fixes the following W=1 kernel build warning(s):
> 
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c:1576:6: warning:
>  variable 'ret' set but not used [-Wunused-but-set-variable]
>   1576 |  int ret;
>        |      ^~~
> 
> driver_for_each_device() has been declared with __must_check, so the
> return value should be checked.
> 
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

72a398a63b88 brcmfmac: check return value of driver_for_each_device()

-- 
https://patchwork.kernel.org/patch/11786561/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

