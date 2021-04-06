Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7EC3550DF
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 12:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245094AbhDFK3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 06:29:39 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:29518 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245118AbhDFK3N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 06:29:13 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1617704946; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=J7orDIS84Fhl5iLzBY56ve+IpWWZFsF/yhfnYMTenVY=; b=P6qB3ZZNOr81IHXY6ZdMnkSJBzu9D9DV7YFC0UFAaCzypT8uV6oMPQR6ZYpZJraswX3qt/Ch
 5DCUigfNGpYoWvMw79UNSj6h1GWElnUCJnz3DthWAqwPQ0qjlXKm9dwDbQh5Gy9tzlzR65jz
 PtSsAFuhQERFGm1TOGfsc6CCv04=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-west-2.postgun.com with SMTP id
 606c37e32cc44d3aea67666d (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 06 Apr 2021 10:28:51
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 4C5BFC43468; Tue,  6 Apr 2021 10:28:51 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 27FD5C43464;
        Tue,  6 Apr 2021 10:28:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 27FD5C43464
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Qiheng Lin <linqiheng@huawei.com>
Cc:     <nbd@nbd.name>, <lorenzo.bianconi83@gmail.com>,
        <ryder.lee@mediatek.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <matthias.bgg@gmail.com>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] mt76: mt7921: remove unneeded semicolon
References: <20210406032051.7750-1-linqiheng@huawei.com>
Date:   Tue, 06 Apr 2021 13:28:44 +0300
In-Reply-To: <20210406032051.7750-1-linqiheng@huawei.com> (Qiheng Lin's
        message of "Tue, 6 Apr 2021 11:20:51 +0800")
Message-ID: <87eefnogf7.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Qiheng Lin <linqiheng@huawei.com> writes:

> Eliminate the following coccicheck warning:
>  drivers/net/wireless/mediatek/mt76/mt7921/mac.c:1402:2-3: Unneeded semicolon
>
> Signed-off-by: Qiheng Lin <linqiheng@huawei.com>

mt76 patches go to the mt76 tree maintained by Felix, not to net-next.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
