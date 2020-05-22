Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D6801DE716
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 14:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729738AbgEVMk4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 08:40:56 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:56460 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728717AbgEVMk4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 08:40:56 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1590151255; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=oh+42u1jD0lF3Mak7Y5plxChvFaOqSnyizeGieH43rM=;
 b=WZLsdI4WLXBCxkRnCMKfK2a6mopfqh1tYPZR2Zp1UTWVJgLhlRg+bzgiiFak89lkSOHJSBJd
 yfDpmtYZxHFtmASPswRna2ehl+gXeSzMBGXOcO0AeKTm/9tdc0vAfzBRBonp064HL8GnLXfa
 KYXcVNl1kPabfpvAqdpsevNUtjU=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 5ec7c8564110e147184f67a9 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 22 May 2020 12:40:54
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id D1B5FC4339C; Fri, 22 May 2020 12:40:52 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C56E6C433C6;
        Fri, 22 May 2020 12:40:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C56E6C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next] mt76: mt7915: Fix build error
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200522034533.61716-1-yuehaibing@huawei.com>
References: <20200522034533.61716-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <nbd@nbd.name>, <lorenzo.bianconi83@gmail.com>,
        <ryder.lee@mediatek.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <matthias.bgg@gmail.com>, <shayne.chen@mediatek.com>,
        <chih-min.chen@mediatek.com>, <yf.luo@mediatek.com>,
        <yiwei.chung@mediatek.com>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200522124052.D1B5FC4339C@smtp.codeaurora.org>
Date:   Fri, 22 May 2020 12:40:52 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

YueHaibing <yuehaibing@huawei.com> wrote:

> In file included from ./include/linux/firmware.h:6:0,
>                  from drivers/net/wireless/mediatek/mt76/mt7915/mcu.c:4:
> In function ‘__mt7915_mcu_msg_send’,
>     inlined from ‘mt7915_mcu_send_message’ at drivers/net/wireless/mediatek/mt76/mt7915/mcu.c:370:6:
> ./include/linux/compiler.h:396:38: error: call to ‘__compiletime_assert_545’ declared with attribute error: BUILD_BUG_ON failed: cmd == MCU_EXT_CMD_EFUSE_ACCESS && mcu_txd->set_query != MCU_Q_QUERY
>   _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
>                                       ^
> ./include/linux/compiler.h:377:4: note: in definition of macro ‘__compiletime_assert’
>     prefix ## suffix();    \
>     ^~~~~~
> ./include/linux/compiler.h:396:2: note: in expansion of macro ‘_compiletime_assert’
>   _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
>   ^~~~~~~~~~~~~~~~~~~
> ./include/linux/build_bug.h:39:37: note: in expansion of macro ‘compiletime_assert’
>  #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
>                                      ^~~~~~~~~~~~~~~~~~
> ./include/linux/build_bug.h:50:2: note: in expansion of macro ‘BUILD_BUG_ON_MSG’
>   BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
>   ^~~~~~~~~~~~~~~~
> drivers/net/wireless/mediatek/mt76/mt7915/mcu.c:280:2: note: in expansion of macro ‘BUILD_BUG_ON’
>   BUILD_BUG_ON(cmd == MCU_EXT_CMD_EFUSE_ACCESS &&
>   ^~~~~~~~~~~~
> 
> BUILD_BUG_ON is meaningless here, chang it to WARN_ON.
> 
> Fixes: e57b7901469f ("mt76: add mac80211 driver for MT7915 PCIe-based chipsets")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

472f0a240250 mt76: mt7915: Fix build error

-- 
https://patchwork.kernel.org/patch/11564595/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

