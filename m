Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32EEE27C006
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 10:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727729AbgI2IuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 04:50:20 -0400
Received: from z5.mailgun.us ([104.130.96.5]:39529 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727035AbgI2IuU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 04:50:20 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1601369419; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=mRaPxdfj4LJlgy+NgHgvOHUAL2Pv9lq3ue6VUFHWv00=; b=haYu0/3PzoawcvXezFxCMURy2FALlKsoUc37c1RYB5sbO6r9WZrI34lja1/DTswJt/VJNQgq
 avAQS7oNbCjX+BRhmwb1sXzO0Ar1KuR6XUiu5gJnEYOnh8jNzUDVkvwi5YhaaNQtZdGSCjHI
 hlwwE28sKcYgYiqvoS9OLFTSuHA=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-east-1.postgun.com with SMTP id
 5f72f54b97ca3ed0fb6c854a (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 29 Sep 2020 08:50:19
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 661E8C43382; Tue, 29 Sep 2020 08:50:18 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DB1E1C433CB;
        Tue, 29 Sep 2020 08:50:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org DB1E1C433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     ath11k@lists.infradead.org, sfr@canb.auug.org.au,
        govinds@codeaurora.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH] ath11k: remove auto_start from channel config struct
References: <20200928101420.18745-1-manivannan.sadhasivam@linaro.org>
Date:   Tue, 29 Sep 2020 11:50:12 +0300
In-Reply-To: <20200928101420.18745-1-manivannan.sadhasivam@linaro.org>
        (Manivannan Sadhasivam's message of "Mon, 28 Sep 2020 15:44:20 +0530")
Message-ID: <87k0wddl17.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org> writes:

> Recent change in MHI bus removed the option to auto start the channels
> during MHI driver probe. The channel will only be started when the MHI
> client driver like QRTR gets probed. So, remove the option from ath11k
> channel config struct.
>
> Fixes: 1399fb87ea3e ("ath11k: register MHI controller device for QCA6390")
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

In the future please cc linux-wireless so that patchwork sees the patch.
I'll resend this as v2 and add the cc.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
