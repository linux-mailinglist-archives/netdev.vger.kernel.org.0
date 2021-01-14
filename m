Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27F7F2F67C7
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 18:36:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728418AbhANRdH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 12:33:07 -0500
Received: from m43-15.mailgun.net ([69.72.43.15]:14854 "EHLO
        m43-15.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726110AbhANRdG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 12:33:06 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1610645566; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=ZCKHVoEJspq/zV1a4bRl6/7Wbwi5CK1RSB8Zy5PWuMs=;
 b=hjc0XHYNCCcAPBpASyNqVRFjQF5dW3SThUJ+3gfPq1zroAeoSp0swU4dNHLawYA8owwhx3ts
 9q7CPlv3F/CqH+k5n1/7D0oZyuinBkzZl32RAOacjBUmfiEjHNpdl4w++w3rEoUPDrdH4Y5T
 9WVQIwkxkkg/kLZJi2JSVubkYfY=
X-Mailgun-Sending-Ip: 69.72.43.15
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-west-2.postgun.com with SMTP id
 600080234104d9478d873de4 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 14 Jan 2021 17:32:19
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id EAEB1C433C6; Thu, 14 Jan 2021 17:32:18 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 94B3CC433CA;
        Thu, 14 Jan 2021 17:32:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 94B3CC433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH wireless v3 -next] brcmfmac: Delete useless kfree code
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20201222135113.20680-1-zhengyongjun3@huawei.com>
References: <20201222135113.20680-1-zhengyongjun3@huawei.com>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>
Cc:     <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        <SHA-cyfmac-dev-list@infineon.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <Markus.Elfring@web.de>,
        Zheng Yongjun <zhengyongjun3@huawei.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20210114173218.EAEB1C433C6@smtp.codeaurora.org>
Date:   Thu, 14 Jan 2021 17:32:18 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zheng Yongjun <zhengyongjun3@huawei.com> wrote:

> A null pointer will be passed to a kfree() call after a kzalloc() call failed.
> This code is useless. Thus delete the extra function call.
> 
> A goto statement is also no longer needed. Thus adjust an if branch.
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

73c655410181 brcmfmac: Delete useless kfree code

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20201222135113.20680-1-zhengyongjun3@huawei.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

