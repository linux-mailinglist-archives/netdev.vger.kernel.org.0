Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A15D23671B0
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 19:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244754AbhDURqq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 13:46:46 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:36930 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238606AbhDURqq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 13:46:46 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1619027173; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=mIoGwTFNFlNcqe2snL+bh4loHX2D9cEh/9+/MXFcrK8=;
 b=kP2MrSU3uz60tEHRxXogWLt46shRnnNzxfsVa1dutg9FZf52ZO2TFyqOvM2KeitP7foPRGwZ
 +rTesVkKV7ILkFT1iAaOL3LoqyO5xJ308tnSEeQmVvERgia/tGWkj8PQfFmQGv4x7l0OY8IN
 fRk4stG9TKnNTtpDnZUi0D+txSQ=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-east-1.postgun.com with SMTP id
 608064e32cbba88980e64842 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 21 Apr 2021 17:46:11
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id B4FD1C433F1; Wed, 21 Apr 2021 17:46:10 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2C943C43460;
        Wed, 21 Apr 2021 17:46:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2C943C43460
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath9k:remove unneeded variable in
 ath9k_dump_legacy_btcoex
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210224130356.51444-1-zhangkun4jr@163.com>
References: <20210224130356.51444-1-zhangkun4jr@163.com>
To:     zhangkun4jr@163.com
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, ath9k-devel@qca.qualcomm.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zhang Kun <zhangkun@cdjrlc.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20210421174610.B4FD1C433F1@smtp.codeaurora.org>
Date:   Wed, 21 Apr 2021 17:46:10 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

zhangkun4jr@163.com wrote:

> From: Zhang Kun <zhangkun@cdjrlc.com>
> 
> Remove unneeded variable 'len' in ath9k_dump_legacy_btcoex.
> 
> Signed-off-by: Zhang Kun <zhangkun@cdjrlc.com>

This fails to compile. Always build check your patches!

In file included from drivers/net/wireless/ath/ath9k/gpio.c:17:
drivers/net/wireless/ath/ath9k/gpio.c: In function 'ath9k_dump_legacy_btcoex':
drivers/net/wireless/ath/ath9k/ath9k.h:763:3: error: 'len' undeclared (first use in this function)
  763 |   len += scnprintf(buf + len, size - len,  \
      |   ^~~
drivers/net/wireless/ath/ath9k/gpio.c:501:2: note: in expansion of macro 'ATH_DUMP_BTCOEX'
  501 |  ATH_DUMP_BTCOEX("Stomp Type", btcoex->bt_stomp_type);
      |  ^~~~~~~~~~~~~~~
drivers/net/wireless/ath/ath9k/ath9k.h:763:3: note: each undeclared identifier is reported only once for each function it appears in
  763 |   len += scnprintf(buf + len, size - len,  \
      |   ^~~
drivers/net/wireless/ath/ath9k/gpio.c:501:2: note: in expansion of macro 'ATH_DUMP_BTCOEX'
  501 |  ATH_DUMP_BTCOEX("Stomp Type", btcoex->bt_stomp_type);
      |  ^~~~~~~~~~~~~~~
make[5]: *** [drivers/net/wireless/ath/ath9k/gpio.o] Error 1
make[4]: *** [drivers/net/wireless/ath/ath9k] Error 2
make[3]: *** [drivers/net/wireless/ath] Error 2
make[2]: *** [drivers/net/wireless] Error 2
make[1]: *** [drivers/net] Error 2
make: *** [drivers] Error 2

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210224130356.51444-1-zhangkun4jr@163.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

