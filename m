Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 650F8E9EBD
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 16:19:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727176AbfJ3PS7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 11:18:59 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:37624 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726589AbfJ3PS7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 11:18:59 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 63E3360913; Wed, 30 Oct 2019 15:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572448737;
        bh=knA8Ic2tqj9JF9EG2DEMqJxtA5w9Djz+7CUfs/V50Aw=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=bGtl+H+XrUoY03ZZr3HSatChd6MxvbSQMsB1RfH0TokgE4gYSCkGBWh6OuSe9oKHp
         6G+xK01An6Q4mXjr8v3Z9hMyHmOm4Fvnhji/ip6MG1nfQbSmg+n44e1Gv5SoklOskS
         BKXL29/yhutMB7giM5Cx/5gSv8iyNij5McL2acOc=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9563E60F7A;
        Wed, 30 Oct 2019 15:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572448736;
        bh=knA8Ic2tqj9JF9EG2DEMqJxtA5w9Djz+7CUfs/V50Aw=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=mvj20y4BOibzuXc0Nbz+dRAhmVfmZV2VG0hn093YqWfpdd17xIpxEPhNxp22dhI+L
         AMwNA/iuiW+hTlspeyanWyQzY1VBqbGozmVCrXl/kgeKX1iW+V9pju6HkEA6xCETO9
         P7pNnp65bgfH81aU+gmE5Od0zG60rJSoM+NLJEdE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9563E60F7A
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath: ath9k: Remove unneeded variable
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20191028204317.GA29468@saurav>
References: <20191028204317.GA29468@saurav>
To:     Saurav Girepunje <saurav.girepunje@gmail.com>
Cc:     ath9k-devel@qca.qualcomm.com, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, saurav.girepunje@hotmail.com
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191030151857.63E3360913@smtp.codeaurora.org>
Date:   Wed, 30 Oct 2019 15:18:57 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Saurav Girepunje <saurav.girepunje@gmail.com> wrote:

> Remove "len" variable which is not used in ath9k_dump_legacy_btcoex.
> 
> Signed-off-by: Saurav Girepunje <saurav.girepunje@gmail.com>

Fails to build, always compile test your patches.

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

Patch set to Rejected.

-- 
https://patchwork.kernel.org/patch/11216495/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

