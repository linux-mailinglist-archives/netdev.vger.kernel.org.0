Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 095734594C3
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 19:37:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238530AbhKVSkv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 13:40:51 -0500
Received: from m43-7.mailgun.net ([69.72.43.7]:20463 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236888AbhKVSks (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Nov 2021 13:40:48 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1637606261; h=Date: Message-ID: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=byKH944N5FLT3iZWf8p0yBQzL8UpoJCxCwxyIvt1S/Q=;
 b=sk5+luvawyfiVtGIAAWL6k+aQnubE4VjaGRP7VtAD70oWC7i2Zg7a1KYvJPV5GEYVVIvDt01
 uxQBQgu+xIgeyKUqSLdqnVrzhUZkmUTYbU6Ti4i244X3Lo4G7pOWv/EDGuw5Gqfsl1wLUH03
 vYfn8P+eXtVu81L29CDPjzt7zk4=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-west-2.postgun.com with SMTP id
 619be374bebfa3d4d5501ea4 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 22 Nov 2021 18:37:40
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 9607EC43618; Mon, 22 Nov 2021 18:37:40 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.5 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,SPF_FAIL autolearn=no autolearn_force=no version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0761DC4338F;
        Mon, 22 Nov 2021 18:37:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 0761DC4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] iwlwifi: Fix missing error code in iwl_pci_probe()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1635838727-128735-1-git-send-email-jiapeng.chong@linux.alibaba.com>
References: <1635838727-128735-1-git-send-email-jiapeng.chong@linux.alibaba.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     luciano.coelho@intel.com, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        chongjiapeng <jiapeng.chong@linux.alibaba.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <163760625578.7371.11933192931311657024.kvalo@codeaurora.org>
Date:   Mon, 22 Nov 2021 18:37:40 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jiapeng Chong <jiapeng.chong@linux.alibaba.com> wrote:

> From: chongjiapeng <jiapeng.chong@linux.alibaba.com>
> 
> The error code is missing in this code scenario, add the error code
> '-EINVAL' to the return value 'ret'.
> 
> Eliminate the follow smatch warning:
> 
> drivers/net/wireless/intel/iwlwifi/pcie/drv.c:1376 iwl_pci_probe() warn:
> missing error code 'ret'.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Fixes: 1f171f4f1437 ("iwlwifi: Add support for getting rf id with blank otp")
> Signed-off-by: chongjiapeng <jiapeng.chong@linux.alibaba.com>
> Acked-by: Luca Coelho <luciano.coelho@intel.com>

Patch applied to wireless-drivers.git, thanks.

1b54403c9cc4 iwlwifi: Fix missing error code in iwl_pci_probe()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/1635838727-128735-1-git-send-email-jiapeng.chong@linux.alibaba.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

