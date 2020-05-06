Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC07A1C6C21
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 10:45:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728942AbgEFIpa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 04:45:30 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:50029 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728644AbgEFIp3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 04:45:29 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1588754729; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=Cq0w218bAG5z/ZkdwIfzHBhWjL3hPo37a25LqwxjbIY=;
 b=F1Z7YyFPFjRAGrCWUTSq00BMmlpIMAYKl6HqyXcJ0pYo286VupEs61Co4BUDjKTh5dcNO/o/
 OOX6/muYMQK2Wez+UZeyRV5NCp3Gm4qEpSxkqUZtjsq000fbCA3TlYnTbnDyFnwIQeg7CC8G
 0qsuw0fMAf2v44NZedijtm2as04=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5eb27921.7f3179ba2688-smtp-out-n05;
 Wed, 06 May 2020 08:45:21 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 57C09C433BA; Wed,  6 May 2020 08:45:21 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 59FF6C433F2;
        Wed,  6 May 2020 08:45:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 59FF6C433F2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] b43: remove Comparison of 0/1 to bool variable in phy_n.c
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200504113300.40895-1-yanaijie@huawei.com>
References: <20200504113300.40895-1-yanaijie@huawei.com>
To:     Jason Yan <yanaijie@huawei.com>
Cc:     <davem@davemloft.net>, <tglx@linutronix.de>,
        <linux-wireless@vger.kernel.org>, <b43-dev@lists.infradead.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Jason Yan <yanaijie@huawei.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200506084521.57C09C433BA@smtp.codeaurora.org>
Date:   Wed,  6 May 2020 08:45:21 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jason Yan <yanaijie@huawei.com> wrote:

> Fix the following coccicheck warning:
> 
> drivers/net/wireless/broadcom/b43/phy_n.c:5510:19-32: WARNING:
> Comparison of 0/1 to bool variable
> 
> Signed-off-by: Jason Yan <yanaijie@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

e2b9ac590810 b43: remove Comparison of 0/1 to bool variable in phy_n.c

-- 
https://patchwork.kernel.org/patch/11525529/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
