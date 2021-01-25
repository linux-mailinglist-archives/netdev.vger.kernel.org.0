Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D698303416
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 06:16:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730142AbhAZFOw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:14:52 -0500
Received: from a1.mail.mailgun.net ([198.61.254.60]:35940 "EHLO
        a1.mail.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729643AbhAYOjY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 09:39:24 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1611585540; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=SNkcgclhaLaZTc7lhg9DW3tZsSFJLuqpSdcYvUg4B2M=;
 b=Yr6ATFsY6/fL0549jc3Cd+uzdhaEaDiTSlex/O4MpZMQhFAQvlkWsSTmAjF/fos7ubMSxgll
 33Gd18jbdtbRix2kYooRPdPVgl5JahiwDvRqZf53sJ3fiMWAobQ9mR1Kgdt46JlQODbG3q3T
 XbfrOApVbNz+79id+zesQIcECrU=
X-Mailgun-Sending-Ip: 198.61.254.60
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-west-2.postgun.com with SMTP id
 600ed7e6f07bb817ad1a17b7 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 25 Jan 2021 14:38:30
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 8E2B2C43461; Mon, 25 Jan 2021 14:38:29 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id EC55AC433C6;
        Mon, 25 Jan 2021 14:38:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org EC55AC433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH wireless v2] scsi: megaraid: Remove unnecessary memset
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210115014559.7803-1-zhengyongjun3@huawei.com>
References: <20210115014559.7803-1-zhengyongjun3@huawei.com>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>
Cc:     <davem@davemloft.net>, <kuba@kernel.org>,
        <wcn36xx@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Zheng Yongjun <zhengyongjun3@huawei.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20210125143829.8E2B2C43461@smtp.codeaurora.org>
Date:   Mon, 25 Jan 2021 14:38:29 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zheng Yongjun <zhengyongjun3@huawei.com> wrote:

> memcpy operation is next to memset code, and the size to copy
> is equals to the size to memset, so the memset operation is
> unnecessary, remove it.
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>

Wrong title.

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210115014559.7803-1-zhengyongjun3@huawei.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

