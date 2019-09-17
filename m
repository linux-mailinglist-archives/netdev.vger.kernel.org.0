Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E319B479D
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 08:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391304AbfIQGlC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 02:41:02 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:44614 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729443AbfIQGlB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Sep 2019 02:41:01 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id E72E0613A8; Tue, 17 Sep 2019 06:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1568702460;
        bh=PsCESTKuaXVgX05Dw2TtqzRSs+kJpkOmCLBNa9gPZ/A=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=gBGxvFFdwMyz9SenL8v+jRpIhZs4yhoSIQDyP2FopVEb0teLoaN6zwMtLVy7cqjeE
         D8p9I3RG11cFWfxX/gprvZGRHRJclyY0+8Gm8vEInlsQi6xgtzXh2vKzZi+k0inKUH
         miwzF0LV3inSAu9U9xklGOSKO+zTmp5hKbfa1BuY=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,MISSING_DATE,MISSING_MID,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E37316016D;
        Tue, 17 Sep 2019 06:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1568702458;
        bh=PsCESTKuaXVgX05Dw2TtqzRSs+kJpkOmCLBNa9gPZ/A=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=E3LHzA9Kc4Fw8KCwHSIuM9cRLB+PqftD8jDQh5mbyX8ELcF2PwTX1F9o4ZWMnU0r1
         EZej7yALG3ngrOnu4pSibrfTaIV5tghGg9WQGGpbBLb40G8jAh/ZMBu4Gk9z+X5e6T
         jxLug6oIpzTyzx4hJi8Xeivm+K3IJCGC1B4XFb9I=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E37316016D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath9k: remove unneeded variable
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1568109312-13175-1-git-send-email-dingxiang@cmss.chinamobile.com>
References: <1568109312-13175-1-git-send-email-dingxiang@cmss.chinamobile.com>
To:     Ding Xiang <dingxiang@cmss.chinamobile.com>
Cc:     davem@davemloft.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190917064100.E72E0613A8@smtp.codeaurora.org>
Date:   Tue, 17 Sep 2019 06:41:00 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ding Xiang <dingxiang@cmss.chinamobile.com> wrote:

> "len" is unneeded,just return 0
> 
> Signed-off-by: Ding Xiang <dingxiang@cmss.chinamobile.com>

ALWAYS build check your patches! I admit that ATH_DUMP_BTCOEX() is an
evil macro as it uses len variable in secret, but if you had compiled
your patch you would have noticed this immeadiately.

In file included from drivers/net/wireless/ath/ath9k/gpio.c:17:
drivers/net/wireless/ath/ath9k/gpio.c: In function 'ath9k_dump_legacy_btcoex':
drivers/net/wireless/ath/ath9k/ath9k.h:763:3: error: 'len' undeclared (first use in this function); did you mean '_end'?
   len += scnprintf(buf + len, size - len,  \
   ^~~
drivers/net/wireless/ath/ath9k/gpio.c:502:2: note: in expansion of macro 'ATH_DUMP_BTCOEX'
  ATH_DUMP_BTCOEX("Stomp Type", btcoex->bt_stomp_type);
  ^~~~~~~~~~~~~~~
drivers/net/wireless/ath/ath9k/ath9k.h:763:3: note: each undeclared identifier is reported only once for each function it appears in
   len += scnprintf(buf + len, size - len,  \
   ^~~
drivers/net/wireless/ath/ath9k/gpio.c:502:2: note: in expansion of macro 'ATH_DUMP_BTCOEX'
  ATH_DUMP_BTCOEX("Stomp Type", btcoex->bt_stomp_type);
  ^~~~~~~~~~~~~~~
make[5]: *** [drivers/net/wireless/ath/ath9k/gpio.o] Error 1
make[4]: *** [drivers/net/wireless/ath/ath9k] Error 2
make[3]: *** [drivers/net/wireless/ath] Error 2
make[2]: *** [drivers/net/wireless] Error 2
make[1]: *** [drivers/net] Error 2
make[1]: *** Waiting for unfinished jobs....
make: *** [drivers] Error 2

-- 
https://patchwork.kernel.org/patch/11139147/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

