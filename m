Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BD8A2F6792
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 18:30:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728957AbhANR0g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 12:26:36 -0500
Received: from m43-15.mailgun.net ([69.72.43.15]:56445 "EHLO
        m43-15.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726266AbhANR0e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 12:26:34 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1610645175; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=XM1YMfBnE8uyWCbYGW+mzahVhM+v5GtXtGEBuN14Zpo=;
 b=mjFBaAgjDVnT8cW2GvK2MF7m5u4RRYFwpPG+RKT68IgbAU7E71SQu3gdNerobho/4EG7uyUQ
 YdiKvoYrZ6EIXeUkZtnFbD1IuEQ+0OFJ3ietdQNHXL5Hc9yPeHofTtEMq8Zovnd3uvEW2XaE
 gZpwizfmzthT9t6IQeibtzqhqn8=
X-Mailgun-Sending-Ip: 69.72.43.15
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 60007e91d84bad3547b046ba (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 14 Jan 2021 17:25:37
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 84AF2C433ED; Thu, 14 Jan 2021 17:25:37 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9FB97C433CA;
        Thu, 14 Jan 2021 17:25:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9FB97C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH wireless -next] rtw88: Delete useless kfree code
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20201216130442.13869-1-zhengyongjun3@huawei.com>
References: <20201216130442.13869-1-zhengyongjun3@huawei.com>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>
Cc:     <tony0620emma@gmail.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Zheng Yongjun <zhengyongjun3@huawei.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20210114172537.84AF2C433ED@smtp.codeaurora.org>
Date:   Thu, 14 Jan 2021 17:25:37 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zheng Yongjun <zhengyongjun3@huawei.com> wrote:

> The parameter of kfree function is NULL, so kfree code is useless, delete it.
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

Patch applied to wireless-drivers-next.git, thanks.

8873e8f56f74 rtw88: Delete useless kfree code

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20201216130442.13869-1-zhengyongjun3@huawei.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

