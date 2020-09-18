Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 541ED27001B
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 16:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbgIROq5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 10:46:57 -0400
Received: from so254-54.mailgun.net ([198.61.254.54]:15362 "EHLO
        so254-54.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726588AbgIROq5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 10:46:57 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1600440416; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=/Aa/WjjWk1ufZ8KJvR0ADmWUbZ4ou8nNCagks2bnfgU=; b=fA4nXwI4vb24uBWaZz6sZP51LLc9cTCMF5O+JFIXnGnPAXM/Cb6boN9jfPlAyb8adlOaxhSi
 HoeKgjlSXVzE9CIE5Be03HzihQKg0gIRKMdmSCRzhF6wMoJZB7cFh6M3g28Htop1HBHUvZP8
 ZZ8hmUGO+TFE5xzFfSQ32JTzanQ=
X-Mailgun-Sending-Ip: 198.61.254.54
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 5f64c734f1e3eb89c7c9cd2f (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 18 Sep 2020 14:41:56
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 7A9ECC433FE; Fri, 18 Sep 2020 14:41:55 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3D9DBC433CA;
        Fri, 18 Sep 2020 14:41:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3D9DBC433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>
Cc:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH net-next] net: brcmfmac: check return value of driver_for_each_device()
References: <1600429068-28003-1-git-send-email-zhangchangzhong@huawei.com>
Date:   Fri, 18 Sep 2020 17:41:48 +0300
In-Reply-To: <1600429068-28003-1-git-send-email-zhangchangzhong@huawei.com>
        (Zhang Changzhong's message of "Fri, 18 Sep 2020 19:37:48 +0800")
Message-ID: <87lfh7b103.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+ linux-wireless

Zhang Changzhong <zhangchangzhong@huawei.com> writes:

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

Please cc linux-wireless on all wireless patches. Otherwise our
patchwork won't see it and I can't apply it. So please resend as v2.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
