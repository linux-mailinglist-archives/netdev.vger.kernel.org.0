Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DADA2E0BE1
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 15:35:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727692AbgLVOef (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 09:34:35 -0500
Received: from m43-15.mailgun.net ([69.72.43.15]:38849 "EHLO
        m43-15.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727671AbgLVOef (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 09:34:35 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1608647655; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=BuXqzRCrkXeGwJLsnDwSgyDfSAuFS9jWlpvG1AGPLV4=; b=O8vnm+CvAhdVPGFHRc0b+cdsFnvYS9ssTePW4/5DDcy8xilbAU7mijBknWuqRCvRI9CVGy5F
 oh1q1I+UjNpYtRMy8XATLpV3gdTTZLwbG09W5cmYJjMATcJXXWcdYOITLwSy7hGiOwKPMtTe
 UK7uh1lLlTgzlyu7NJBW3++kV6o=
X-Mailgun-Sending-Ip: 69.72.43.15
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 5fe203cc7036173f4f69e914 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 22 Dec 2020 14:33:48
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id E1637C433ED; Tue, 22 Dec 2020 14:33:47 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from x230.qca.qualcomm.com (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 793B1C433C6;
        Tue, 22 Dec 2020 14:33:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 793B1C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>
Cc:     <davem@davemloft.net>, <kuba@kernel.org>,
        <wcn36xx@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] scsi: megaraid: Remove unnecessary memset
References: <20201222133424.19969-1-zhengyongjun3@huawei.com>
Date:   Tue, 22 Dec 2020 16:33:43 +0200
In-Reply-To: <20201222133424.19969-1-zhengyongjun3@huawei.com> (Zheng
        Yongjun's message of "Tue, 22 Dec 2020 21:34:24 +0800")
Message-ID: <87ft3xap14.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zheng Yongjun <zhengyongjun3@huawei.com> writes:

> memcpy operation is next to memset code, and the size to copy is equals to the size to
> memset, so the memset operation is unnecessary, remove it.
>
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
> ---
>  drivers/net/wireless/ath/wcn36xx/smd.c | 1 -
>  1 file changed, 1 deletion(-)

The title is wrong, this is not about scsi. Please resend as v2.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
