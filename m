Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D0633043D8
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 17:29:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392879AbhAZQ2N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 11:28:13 -0500
Received: from a1.mail.mailgun.net ([198.61.254.60]:10775 "EHLO
        a1.mail.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392886AbhAZQ0b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 11:26:31 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1611678365; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=roFrb5eBhPqZTvXpSEWS1kSBgr+K1E0l4LAsnVOoPAw=;
 b=mNnHE2VHRe04UHrFvJ9mwHjoiyU/2gNpOf3X+PU4Clmb/HBy0GA5Ybq5H/MPbhKh/d0RkkOk
 WvRgftrBHvvXqSXs1P4l6OYwehxSoFWiLWWrd/jiDpP8t78MoFL5uHnQRMLQpOm48ZiJydNL
 eg1yjtBYSCFeFEcURXmm9etXPB4=
X-Mailgun-Sending-Ip: 198.61.254.60
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-east-1.postgun.com with SMTP id
 6010427cfb02735e8cffe38e (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 26 Jan 2021 16:25:32
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 2357AC433ED; Tue, 26 Jan 2021 16:25:31 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id AAB1EC433CA;
        Tue, 26 Jan 2021 16:25:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org AAB1EC433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH wireless v2 -next] wcn36xx: Remove unnecessary memset
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20201223012516.24286-1-zhengyongjun3@huawei.com>
References: <20201223012516.24286-1-zhengyongjun3@huawei.com>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>
Cc:     <davem@davemloft.net>, <kuba@kernel.org>,
        <wcn36xx@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Zheng Yongjun <zhengyongjun3@huawei.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20210126162531.2357AC433ED@smtp.codeaurora.org>
Date:   Tue, 26 Jan 2021 16:25:31 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zheng Yongjun <zhengyongjun3@huawei.com> wrote:

> memcpy operation is next to memset code, and the size to copy is equals to the size to
> memset, so the memset operation is unnecessary, remove it.
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

337cd0d3ce0c wcn36xx: Remove unnecessary memset

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20201223012516.24286-1-zhengyongjun3@huawei.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

