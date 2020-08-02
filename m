Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55EF8235817
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 17:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbgHBPUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 11:20:49 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:36799 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725968AbgHBPUs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 Aug 2020 11:20:48 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1596381648; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=Y/XJqTYgdOp0UaZSA4QW2k1p+s9dYdd6Love7yCfvE0=;
 b=h0Yb6N5cMiSQjLxOrxYvpKP7ckv5q9EAgo6k17e+mLGg78w3LqHkwd1gqaJxaWY/9xd3LOv0
 kwCyOJUfRWr8ThMxQZvjHhvkQdI76gEneyzsrntQHgQZ0nCWhwaIYxA2eC6r0wlY06Xc+1YV
 Jx5HPqldF3RtixIj84SQSJy15Wc=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n10.prod.us-east-1.postgun.com with SMTP id
 5f26d9cfeecfc978d39d75fe (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sun, 02 Aug 2020 15:20:47
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id E4F85C433C6; Sun,  2 Aug 2020 15:20:46 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 223C3C433C9;
        Sun,  2 Aug 2020 15:20:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 223C3C433C9
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH net] qtnfmac: Missing platform_device_unregister() on
 error in
 qtnf_core_mac_alloc()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200730064910.37589-1-wanghai38@huawei.com>
References: <20200730064910.37589-1-wanghai38@huawei.com>
To:     Wang Hai <wanghai38@huawei.com>
Cc:     <imitsyanko@quantenna.com>, <geomatsi@gmail.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <mst@redhat.com>,
        <mkarpenko@quantenna.com>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200802152046.E4F85C433C6@smtp.codeaurora.org>
Date:   Sun,  2 Aug 2020 15:20:46 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wang Hai <wanghai38@huawei.com> wrote:

> Add the missing platform_device_unregister() before return from
> qtnf_core_mac_alloc() in the error handling case.
> 
> Fixes: 616f5701f4ab ("qtnfmac: assign each wiphy to its own virtual platform device")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wang Hai <wanghai38@huawei.com>
> Reviewed-by: Sergey Matyukevich <geomatsi@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

141bc9abbbff qtnfmac: Missing platform_device_unregister() on error in qtnf_core_mac_alloc()

-- 
https://patchwork.kernel.org/patch/11692387/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

