Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABC3F149B74
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 16:37:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbgAZPgf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 10:36:35 -0500
Received: from mail25.static.mailgun.info ([104.130.122.25]:42750 "EHLO
        mail25.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725838AbgAZPgf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 10:36:35 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1580052994; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=fB+9Ig6BEvL0LASv8D9I/HUEKOK3HLWIXnz4r7aDix4=;
 b=sxEBPpkNs7TqeCvz/V7EJ+TqSw6UpMTm83YQMc7FZ5R+PdaDJ0FBhwDVDGnF+P0htvV27GsU
 tbqY2FSz/ckOvVdFmvXVLMXM25Vt3Wgc1xiOVYUVgNPT7ghsyukifqU+NK7yXKWpL4uIpPyD
 DdYweANq8iu3jcoWMhyHGlUk1c4=
X-Mailgun-Sending-Ip: 104.130.122.25
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e2db201.7f4488a5bca8-smtp-out-n01;
 Sun, 26 Jan 2020 15:36:33 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id CD520C4479C; Sun, 26 Jan 2020 15:36:33 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2E70FC43383;
        Sun, 26 Jan 2020 15:36:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2E70FC43383
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] hostap: Adjust indentation in prism2_hostapd_add_sta
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20191218011545.40557-1-natechancellor@gmail.com>
References: <20191218011545.40557-1-natechancellor@gmail.com>
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        Nathan Chancellor <natechancellor@gmail.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20200126153633.CD520C4479C@smtp.codeaurora.org>
Date:   Sun, 26 Jan 2020 15:36:33 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nathan Chancellor <natechancellor@gmail.com> wrote:

> Clang warns:
> 
> ../drivers/net/wireless/intersil/hostap/hostap_ap.c:2511:3: warning:
> misleading indentation; statement is not part of the previous 'if'
> [-Wmisleading-indentation]
>         if (sta->tx_supp_rates & WLAN_RATE_5M5)
>         ^
> ../drivers/net/wireless/intersil/hostap/hostap_ap.c:2509:2: note:
> previous statement is here
>         if (sta->tx_supp_rates & WLAN_RATE_2M)
>         ^
> 1 warning generated.
> 
> This warning occurs because there is a space before the tab on this
> line. Remove it so that the indentation is consistent with the Linux
> kernel coding style and clang no longer warns.
> 
> Fixes: ff1d2767d5a4 ("Add HostAP wireless driver.")
> Link: https://github.com/ClangBuiltLinux/linux/issues/813
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

Patch applied to wireless-drivers-next.git, thanks.

b61156fba74f hostap: Adjust indentation in prism2_hostapd_add_sta

-- 
https://patchwork.kernel.org/patch/11299247/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
