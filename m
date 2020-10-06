Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9D912845C1
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 08:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbgJFGDC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 02:03:02 -0400
Received: from z5.mailgun.us ([104.130.96.5]:26268 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726022AbgJFGDB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Oct 2020 02:03:01 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1601964181; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=nZzKky66K+LBgKtoq+KUTHglfyK1fxDJQuYKFBYUmKo=; b=YxXCzBwQ+pTdaifwMJdchNKvbthqD5SO/PiyQv87v/lvefj1tqYE9D5Xdd0epbZSihpg+eZF
 kdBUJCWm1NeMyqQEK7uq/S87UxLcftjwD2AsoH/7VYZdDbUEOPKzDN4F7zdf0JyN27Ox6ekt
 LuZQ1IEFTWUshm3z+1zFMonbbT4=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 5f7c088242f9861fb15a4d84 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 06 Oct 2020 06:02:42
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 2E814C433F1; Tue,  6 Oct 2020 06:02:42 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id AAB45C433CA;
        Tue,  6 Oct 2020 06:02:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org AAB45C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Chris Chiu <chiu@endlessos.org>
Cc:     Pkshih <pkshih@realtek.com>, David Miller <davem@davemloft.net>,
        kuba@kernel.org, linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] rtlwifi: rtl8192se: remove duplicated legacy_httxpowerdiff
References: <20201005150048.4596-1-chiu@endlessm.com>
        <CAB4CAwfaaozSbdiB05Mk-WgY1VQTyXtLNVjY+4vax09Qvr_asg@mail.gmail.com>
Date:   Tue, 06 Oct 2020 09:02:37 +0300
In-Reply-To: <CAB4CAwfaaozSbdiB05Mk-WgY1VQTyXtLNVjY+4vax09Qvr_asg@mail.gmail.com>
        (Chris Chiu's message of "Tue, 6 Oct 2020 12:02:12 +0800")
Message-ID: <87pn5vc2o2.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Chris Chiu <chiu@endlessos.org> writes:

> On Mon, Oct 5, 2020 at 11:01 PM Chris Chiu <chiu@endlessos.org> wrote:
>
>     From: Chris Chiu <chiu@endlessos.org>
>     
>     The legacy_httxpowerdiff in rtl8192se is pretty much the same as
>     the legacy_ht_txpowerdiff for other chips. Use the same name to
>     keep the consistency.
>     
>     Signed-off-by: Chris Chiu <chiu@endlessos.org>
>     ---
>     drivers/net/wireless/realtek/rtlwifi/rtl8192se/hw.c | 2 +-
>     drivers/net/wireless/realtek/rtlwifi/rtl8192se/rf.c | 2 +-
>     drivers/net/wireless/realtek/rtlwifi/wifi.h | 1 -
>     3 files changed, 2 insertions(+), 3 deletions(-)
>     
>
> Sorry. There's no patch series `PATCH 1/3` for this. I'll resubmit the
> patch.

Please don't send HTML mail, they will be dropped by mailing list and
patchwork.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
