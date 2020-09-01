Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AFB1258EF9
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 15:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728126AbgIANSr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 09:18:47 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:38268 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728150AbgIANQd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 09:16:33 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1598966192; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=iZDL70iS5jOLhNK6xZEocM/uElQ9fMrM5LZHQs4smwk=;
 b=VGsvt1mEcFZ+0jCqXWty58TFzfjdsIhEwsIaL9xRJHqEvIfcspPFEsGMJc68Gt9PQbpy2BoW
 bi+jjOCYGYBrcr7af4cqOhm9yBK6pL/Wi7uY8kFY6oTdGf3QxIL43v4ESiK8sh0dGrfs3utB
 o/fS1Pf6Xo0wH/P9Bgtqq0JzWRA=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-east-1.postgun.com with SMTP id
 5f4e4992885efaea0a2a16a3 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 01 Sep 2020 13:16:02
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 311B0C433AD; Tue,  1 Sep 2020 13:16:02 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2062FC433C9;
        Tue,  1 Sep 2020 13:15:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2062FC433C9
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [24/30] mwifiex: wmm: Mark 'mwifiex_1d_to_wmm_queue' as
 __maybe_unused
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200826093401.1458456-25-lee.jones@linaro.org>
References: <20200826093401.1458456-25-lee.jones@linaro.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200901131602.311B0C433AD@smtp.codeaurora.org>
Date:   Tue,  1 Sep 2020 13:16:02 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lee Jones <lee.jones@linaro.org> wrote:

> 'mwifiex_1d_to_wmm_queue' is used in'; main.c, txrx.c and uap_txrx.c
> 
> ... but not used in 14 other source files which include 'wmm.h'.
> 
> Fixes the following W=1 kernel build warning(s):
> 
>  In file included from drivers/net/wireless/marvell/mwifiex/init.c:25:
>  drivers/net/wireless/marvell/mwifiex/wmm.h:34:18: warning: ‘mwifiex_1d_to_wmm_queue’ defined but not used [-Wunused-const-variable=]
>  34 | static const u16 mwifiex_1d_to_wmm_queue[8] = { 1, 0, 0, 1, 2, 2, 3, 3 };
>  | ^~~~~~~~~~~~~~~~~~~~~~~
>  In file included from drivers/net/wireless/marvell/mwifiex/cmdevt.c:26:
>  drivers/net/wireless/marvell/mwifiex/wmm.h:34:18: warning: ‘mwifiex_1d_to_wmm_queue’ defined but not used [-Wunused-const-variable=]
>  34 | static const u16 mwifiex_1d_to_wmm_queue[8] = { 1, 0, 0, 1, 2, 2, 3, 3 };
>  | ^~~~~~~~~~~~~~~~~~~~~~~
>  In file included from drivers/net/wireless/marvell/mwifiex/util.c:25:
>  drivers/net/wireless/marvell/mwifiex/wmm.h:34:18: warning: ‘mwifiex_1d_to_wmm_queue’ defined but not used [-Wunused-const-variable=]
>  34 | static const u16 mwifiex_1d_to_wmm_queue[8] = { 1, 0, 0, 1, 2, 2, 3, 3 };
>  | ^~~~~~~~~~~~~~~~~~~~~~~
>  In file included from drivers/net/wireless/marvell/mwifiex/wmm.c:25:
>  drivers/net/wireless/marvell/mwifiex/wmm.h:34:18: warning: ‘mwifiex_1d_to_wmm_queue’ defined but not used [-Wunused-const-variable=]
>  34 | static const u16 mwifiex_1d_to_wmm_queue[8] = { 1, 0, 0, 1, 2, 2, 3, 3 };
>  | ^~~~~~~~~~~~~~~~~~~~~~~
>  In file included from drivers/net/wireless/marvell/mwifiex/11n.c:25:
>  drivers/net/wireless/marvell/mwifiex/wmm.h:34:18: warning: ‘mwifiex_1d_to_wmm_queue’ defined but not used [-Wunused-const-variable=]
>  34 | static const u16 mwifiex_1d_to_wmm_queue[8] = { 1, 0, 0, 1, 2, 2, 3, 3 };
>  | ^~~~~~~~~~~~~~~~~~~~~~~
>  In file included from drivers/net/wireless/marvell/mwifiex/11n_aggr.c:25:
>  drivers/net/wireless/marvell/mwifiex/wmm.h:34:18: warning: ‘mwifiex_1d_to_wmm_queue’ defined but not used [-Wunused-const-variable=]
>  34 | static const u16 mwifiex_1d_to_wmm_queue[8] = { 1, 0, 0, 1, 2, 2, 3, 3 };
>  | ^~~~~~~~~~~~~~~~~~~~~~~
>  In file included from drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c:25:
>  drivers/net/wireless/marvell/mwifiex/wmm.h:34:18: warning: ‘mwifiex_1d_to_wmm_queue’ defined but not used [-Wunused-const-variable=]
>  34 | static const u16 mwifiex_1d_to_wmm_queue[8] = { 1, 0, 0, 1, 2, 2, 3, 3 };
>  | ^~~~~~~~~~~~~~~~~~~~~~~
>  In file included from drivers/net/wireless/marvell/mwifiex/11n.h:25,
>  from drivers/net/wireless/marvell/mwifiex/scan.c:25:
>  drivers/net/wireless/marvell/mwifiex/wmm.h:34:18: warning: ‘mwifiex_1d_to_wmm_queue’ defined but not used [-Wunused-const-variable=]
>  34 | static const u16 mwifiex_1d_to_wmm_queue[8] = { 1, 0, 0, 1, 2, 2, 3, 3 };
>  | ^~~~~~~~~~~~~~~~~~~~~~~
> 
>  NB: Many entries - snipped for brevity.
> 
> Cc: Amitkumar Karwar <amitkarwar@gmail.com>
> Cc: Ganapathi Bhat <ganapathi.bhat@nxp.com>
> Cc: Xinming Hu <huxinming820@gmail.com>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Failed to apply:

fatal: sha1 information is lacking or useless (drivers/net/wireless/marvell/mwifiex/wmm.h).
error: could not build fake ancestor
Applying: mwifiex: wmm: Mark 'mwifiex_1d_to_wmm_queue' as __maybe_unused
Patch failed at 0001 mwifiex: wmm: Mark 'mwifiex_1d_to_wmm_queue' as __maybe_unused
The copy of the patch that failed is found in: .git/rebase-apply/patch

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/patch/11737713/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

