Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E041A1CEF90
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 10:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729272AbgELIxz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 04:53:55 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:12757 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728525AbgELIxy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 04:53:54 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1589273634; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=+/6p3DIC11Te8kQlt9AC+E8H68Kw1m5lGU+xJ31vemE=;
 b=sD9B8HLFq3G/AWApE0+5dcYyOShXxawLUgsuAOU3TKcGa4j43qj5CVwSzSoO4A86Mg20XAMr
 CtxPNuHI8Iqb9TL8kNZ2q7ITgWQvUUjNHnU7ofI0A/DvaBRVTkjHcvfF8NjLZRe9t7l85OlR
 xe6o5COixHk4did5JPmUym/iLgY=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5eba6411.7fc2ed2de730-smtp-out-n05;
 Tue, 12 May 2020 08:53:37 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id B8DE4C433CB; Tue, 12 May 2020 08:53:36 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 94D4FC433CB;
        Tue, 12 May 2020 08:53:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 94D4FC433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH][next] rndis_wlan: Remove logically dead code
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200505235205.GA18539@embeddedor>
References: <20200505235205.GA18539@embeddedor>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200512085336.B8DE4C433CB@smtp.codeaurora.org>
Date:   Tue, 12 May 2020 08:53:36 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Gustavo A. R. Silva" <gustavo@embeddedor.com> wrote:

> caps_buf is always of size sizeof(*caps) because
> sizeof(caps->auth_encr_pair) * 16 is always zero. Notice
> that when using zero-length arrays, sizeof evaluates to zero[1].
> 
> So, the code introduced by 
> commit 0308383f9591 ("rndis_wlan: get max_num_pmkids from device")
> is logically dead, hence is never executed and can be removed. As a
> consequence, the rest of the related code can be refactored a bit.
> 
> Notice that this code has been out there since March 2010.
> 
> [1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Patch applied to wireless-drivers-next.git, thanks.

485c64be7152 rndis_wlan: Remove logically dead code

-- 
https://patchwork.kernel.org/patch/11530089/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
