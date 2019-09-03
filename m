Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57ACFA694C
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 15:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729374AbfICNGj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 09:06:39 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:58520 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729088AbfICNGj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 09:06:39 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id E38C36090E; Tue,  3 Sep 2019 13:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567515997;
        bh=iYGhXpPlajGpKbgH+Vr47Mz8PaZJai97C3ZVp5vJip0=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=DJN8UxEpeLXw+LNie/A0qWBTUGTZBwqVQGYr5b4G+FThYhhV+aEY9MPSpDkmuIqkh
         oZIpks6R2pbUFc6jEpwOwvrXhiGkjFcuykPgbKHKGscHuml/7ftxlocoH2vnnwltdV
         PdAwOtcYuSKt6m7v7JEy3h5IOBtd9VcDlNgamBnc=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A4616602F2;
        Tue,  3 Sep 2019 13:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567515997;
        bh=iYGhXpPlajGpKbgH+Vr47Mz8PaZJai97C3ZVp5vJip0=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=bNeeRYqTRtYpuIsgSbAPI/D9RUHO0pja5RYmMoKD0/sjflArFZVcUyEKpt3yRWbBG
         K+T2AHXjNc2WcVFxcKxQDb+QO8Nhp/wBx5Xb6U2DjQwsAQTD1BQCLGdt6hi9l5c48x
         zLo/GDuxby3CRwugfbTlPSfBPh4rdG7068ZCK1sY=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A4616602F2
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] rtlwifi: fix non-kerneldoc comment in usb.c
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <34195.1565229118@turing-police>
References: <34195.1565229118@turing-police>
To:     "Valdis =?utf-8?q?Kl=C4=93tnieks?= " <valdis.kletnieks@vt.edu>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190903130637.E38C36090E@smtp.codeaurora.org>
Date:   Tue,  3 Sep 2019 13:06:37 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Valdis wrote:

> Fix spurious warning message when building with W=1:
> 
>   CC [M]  drivers/net/wireless/realtek/rtlwifi/usb.o
> drivers/net/wireless/realtek/rtlwifi/usb.c:243: warning: Cannot understand  * on line 243 - I thought it was a doc line
> drivers/net/wireless/realtek/rtlwifi/usb.c:760: warning: Cannot understand  * on line 760 - I thought it was a doc line
> drivers/net/wireless/realtek/rtlwifi/usb.c:790: warning: Cannot understand  * on line 790 - I thought it was a doc line
> 
> Clean up the comment format.
> 
> Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>

Patch applied to wireless-drivers-next.git, thanks.

b6326fc025aa rtlwifi: fix non-kerneldoc comment in usb.c

-- 
https://patchwork.kernel.org/patch/11083073/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

