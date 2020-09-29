Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F24F27BF44
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 10:24:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727730AbgI2IYG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 04:24:06 -0400
Received: from m42-4.mailgun.net ([69.72.42.4]:36761 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727650AbgI2IYF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 04:24:05 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1601367845; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=j83bf1MXERUMpHodQZcI3Y2kF+MmoDVPrsU65+sFD38=;
 b=Tgt/dWTKP9ep+3VbgtQHebhJEfWbHpe96QrlCOwsjmHwBJrLXXiYzvcIlHApbIAKn9eeG4O5
 3/8yWO/MciRlHObdZ7wG7LoWh+5jiXkWUxBG6/3GCgVGdWO8t1FGng02D9rUxC813ofE46vj
 j5TKRNDxGUnghoIcc/DSyanRYMU=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 5f72ef247e9d6827ec07efee (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 29 Sep 2020 08:24:04
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 94490C433CA; Tue, 29 Sep 2020 08:24:04 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 05449C433C8;
        Tue, 29 Sep 2020 08:24:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 05449C433C8
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] qtnfmac: fix resource leaks on unsupported iftype error
 return path
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200925132224.21638-1-colin.king@canonical.com>
References: <20200925132224.21638-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Igor Mitsyanko <imitsyanko@quantenna.com>,
        Sergey Matyukevich <geomatsi@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Avinash Patil <avinashp@quantenna.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200929082404.94490C433CA@smtp.codeaurora.org>
Date:   Tue, 29 Sep 2020 08:24:04 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently if an unsupported iftype is detected the error return path
> does not free the cmd_skb leading to a resource leak. Fix this by
> free'ing cmd_skb.
> 
> Addresses-Coverity: ("Resource leak")
> Fixes: 805b28c05c8e ("qtnfmac: prepare for AP_VLAN interface type support")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Patch applied to wireless-drivers-next.git, thanks.

63f6982075d8 qtnfmac: fix resource leaks on unsupported iftype error return path

-- 
https://patchwork.kernel.org/patch/11799775/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

