Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97FC443C468
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 09:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235729AbhJ0H4Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 03:56:16 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:55654 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237071AbhJ0H4O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 03:56:14 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1635321229; h=Date: Message-ID: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=OkgHr2Y6HEkj1kBlD9Tm89+Omnw4DhBiRqIgVdp5c8E=;
 b=VEa42wK3fsFezPfOcCHbi/j2qtDh9yrvY3QIzGiP0AH2ei+VUNUB51vHEJ8YB57GdCis0Q0o
 lwJDXRLETnuGIkEWLWdvoqEfpranQ5ySq9QI/sNrHMveNynNqXhclVpxccWcL15qF/rIhvxJ
 svGdSZl4RR22KoY5O4yH+xT1B5E=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 61790581c75c436a30cdd23d (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 27 Oct 2021 07:53:37
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 2563BC43618; Wed, 27 Oct 2021 07:53:37 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.5 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,SPF_FAIL autolearn=no autolearn_force=no version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 05E46C4338F;
        Wed, 27 Oct 2021 07:53:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 05E46C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/3] wcn36xx: add debug prints for sw_scan start/complete
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20211023003949.3082900-2-benl@squareup.com>
References: <20211023003949.3082900-2-benl@squareup.com>
To:     Benjamin Li <benl@squareup.com>
Cc:     Joseph Gates <jgates@squareup.com>,
        Bryan O'Donoghue <bryan.odonoghue@linaro.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        linux-arm-msm@vger.kernel.org, Benjamin Li <benl@squareup.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eugene Krasnikov <k.eugene.e@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <163532120872.19793.15468481505724352001.kvalo@codeaurora.org>
Date:   Wed, 27 Oct 2021 07:53:37 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Benjamin Li <benl@squareup.com> wrote:

> Add some MAC debug prints for more easily demarcating a software scan
> when parsing logs.
> 
> Signed-off-by: Benjamin Li <benl@squareup.com>

Failed to build:

In file included from ./include/linux/bitops.h:7,
                 from ./include/linux/kernel.h:12,
                 from ./include/linux/interrupt.h:6,
                 from drivers/net/wireless/ath/wcn36xx/dxe.c:25:
drivers/net/wireless/ath/wcn36xx/dxe.c: In function '_wcn36xx_dxe_tx_channel_is_empty':
./include/linux/typecheck.h:12:25: error: comparison of distinct pointer types lacks a cast [-Werror]
   12 |         (void)(&__dummy == &__dummy2); \
      |                         ^~
./include/linux/spinlock.h:255:17: note: in expansion of macro 'typecheck'
  255 |                 typecheck(unsigned long, flags);        \
      |                 ^~~~~~~~~
./include/linux/spinlock.h:393:9: note: in expansion of macro 'raw_spin_lock_irqsave'
  393 |         raw_spin_lock_irqsave(spinlock_check(lock), flags);     \
      |         ^~~~~~~~~~~~~~~~~~~~~
drivers/net/wireless/ath/wcn36xx/dxe.c:844:9: note: in expansion of macro 'spin_lock_irqsave'
  844 |         spin_lock_irqsave(&ch->lock, flags);
      |         ^~~~~~~~~~~~~~~~~
cc1: all warnings being treated as errors
make[5]: *** [scripts/Makefile.build:277: drivers/net/wireless/ath/wcn36xx/dxe.o] Error 1
make[4]: *** [scripts/Makefile.build:540: drivers/net/wireless/ath/wcn36xx] Error 2
make[3]: *** [scripts/Makefile.build:540: drivers/net/wireless/ath] Error 2
make[2]: *** [scripts/Makefile.build:540: drivers/net/wireless] Error 2
make[1]: *** [scripts/Makefile.build:540: drivers/net] Error 2
make: *** [Makefile:1868: drivers] Error 2

3 patches set to Changes Requested.

12579221 [1/3] wcn36xx: add debug prints for sw_scan start/complete
12579223 [2/3] wcn36xx: implement flush op to speed up connected scan
12579225 [3/3] wcn36xx: ensure pairing of init_scan/finish_scan and start_scan/end_scan

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20211023003949.3082900-2-benl@squareup.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

