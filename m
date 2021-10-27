Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05AE643C413
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 09:38:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240527AbhJ0HlW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 03:41:22 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:39514 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240494AbhJ0HlV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 03:41:21 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1635320336; h=Date: Message-ID: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=NTPIzzTI1NeHuhOUmduNZK63HwxCHd7rR4gCUwjOGBQ=;
 b=cd0wqsdW2+Jq3Zxt9uvoH5S9Kzr2PO/f8ARzGCIyHJDZ1QvKXqUzPpglyCeJOoclIY7fWGbM
 f1vakoj4Cf5xue4m8zHFFo2b+Ghwb7qggb40Lu8miBaodPFoDC5/ctGy0d0qkBS6NpTsTZ7p
 lFM5Yx42l8TJn00l8nU/Cx4PaTg=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-east-1.postgun.com with SMTP id
 6179020214914866fa91fc2b (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 27 Oct 2021 07:38:42
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id D304AC43460; Wed, 27 Oct 2021 07:38:41 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.5 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,SPF_FAIL autolearn=no autolearn_force=no version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B6353C4338F;
        Wed, 27 Oct 2021 07:38:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org B6353C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] libertas: replace snprintf in show functions with
 sysfs_emit
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20211022090438.1065286-1-ye.guojin@zte.com.cn>
References: <20211022090438.1065286-1-ye.guojin@zte.com.cn>
To:     cgel.zte@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, gregkh@linuxfoundation.org,
        ye.guojin@zte.com.cn, yuehaibing@huawei.com,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zeal Robot <zealci@zte.com.cn>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <163532031650.30745.4260926719614261494.kvalo@codeaurora.org>
Date:   Wed, 27 Oct 2021 07:38:41 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

cgel.zte@gmail.com wrote:

> From: Ye Guojin <ye.guojin@zte.com.cn>
> 
> coccicheck complains about the use of snprintf() in sysfs show
> functions:
> WARNING  use scnprintf or sprintf
> 
> Use sysfs_emit instead of scnprintf or sprintf makes more sense.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Ye Guojin <ye.guojin@zte.com.cn>

Patch applied to wireless-drivers-next.git, thanks.

d3c6daa174ff libertas: replace snprintf in show functions with sysfs_emit

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20211022090438.1065286-1-ye.guojin@zte.com.cn/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

