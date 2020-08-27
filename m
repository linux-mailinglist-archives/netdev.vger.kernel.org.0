Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F201D254381
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 12:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728721AbgH0KSY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 06:18:24 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:19374 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728533AbgH0KR7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 06:17:59 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1598523478; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=JZ7miBjeeIeD/blRB2aueu7P99GRKdFWzvTFVESuqK8=;
 b=NjMLgyW4ypeCXqBdewkfj3ZzBzfZ97tHA7QMdGozlCHKvRqyL4HGZVF17TZFtsJZV2NQrtN+
 qQLPqWuqBYxx4qhXtFLrROvejspq0CpptmlnLzb16Q7Zc9NeALswlY3p1tmch6MpvrUNI/5h
 Vx0kGFDHqS+B5rTBSF0+ATMkk9Y=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 5f4788558741f54bbd719cdc (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 27 Aug 2020 10:17:57
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 770A0C433CB; Thu, 27 Aug 2020 10:17:57 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7F03CC433C6;
        Thu, 27 Aug 2020 10:17:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7F03CC433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 17/30] wireless: ath: ath9k: ar9002_initvals: Remove
 unused
 array 'ar9280PciePhy_clkreq_off_L1_9280'
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200826093401.1458456-18-lee.jones@linaro.org>
References: <20200826093401.1458456-18-lee.jones@linaro.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200827101757.770A0C433CB@smtp.codeaurora.org>
Date:   Thu, 27 Aug 2020 10:17:57 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lee Jones <lee.jones@linaro.org> wrote:

> Fixes the following W=1 kernel build warning(s):
> 
>  drivers/net/wireless/ath/ath9k/ar9002_initvals.h:900:18: warning: ‘ar9280PciePhy_clkreq_off_L1_9280’ defined but not used [-Wunused-const-variable=]
> 
> Cc: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

4 patches applied to ath-next branch of ath.git, thanks.

660f101eaac2 ath9k: ar9002_initvals: Remove unused array 'ar9280PciePhy_clkreq_off_L1_9280'
2a0b6a97d01e ath9k: ar9001_initvals: Remove unused array 'ar5416Bank6_9100'
694815e74ba3 ath9k: ar5008_initvals: Remove unused table entirely
b016d0a5b817 ath9k: ar5008_initvals: Move ar5416Bank{0,1,2,3,7} to where they are used

-- 
https://patchwork.kernel.org/patch/11737695/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

