Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D83FA7B2E
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 08:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728648AbfIDGIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 02:08:02 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:52384 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726045AbfIDGIC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 02:08:02 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 1FDD460863; Wed,  4 Sep 2019 06:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567577281;
        bh=A5jxgUwpEQdGcpUrgTBp7J90qN5hLJxxlg5AJOlfIYw=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=ju3nP+nIT9JobGjhVXro7zxQqFIoHkfT8P4bqRjXNxhT0Y7jf0NjypR7XAHW3iiGI
         6Yz2HqV+Rs3j/TNc97UnPPuWTWE/m8vqCcvnBthzm1KEOKmrrJNhVi5uIT9Q4IDt90
         RAsIk3CUngOz79pfMtr5TXv2MlCo87CFtdX08S1U=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id AF42860863;
        Wed,  4 Sep 2019 06:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567577280;
        bh=A5jxgUwpEQdGcpUrgTBp7J90qN5hLJxxlg5AJOlfIYw=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=hqY0g/pwJZmTrVTa0oArHt2OE2P5q67htDxuWaCEFNvxPrHloIRDCsXKzPWXMwMGG
         RHF8+MZOHnOz1mfm+m2KlIng0yxrhaC13uJJMGllfbOR2Xt3/StASgTx49JyiDuuQI
         ljE4Y+5Hk4BsdOB1wrvO1C4P4YN9za+ryH6bH3s4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org AF42860863
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] wil6210: Delete an unnecessary kfree() call in
 wil_tid_ampdu_rx_alloc()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <b9620e49-618d-b392-6456-17de5807df75@web.de>
References: <b9620e49-618d-b392-6456-17de5807df75@web.de>
To:     Markus Elfring <Markus.Elfring@web.de>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        wil6210@qti.qualcomm.com, "David S. Miller" <davem@davemloft.net>,
        Maya Erez <merez@codeaurora.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190904060801.1FDD460863@smtp.codeaurora.org>
Date:   Wed,  4 Sep 2019 06:08:01 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Markus Elfring <Markus.Elfring@web.de> wrote:

> A null pointer would be passed to a call of the function “kfree”
> directly after a call of the function “kcalloc” failed at one place.
> Remove this superfluous function call.
> 
> This issue was detected by using the Coccinelle software.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> Reviewed-by: Maya Erez <merez@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

d20b1e6c8307 wil6210: Delete an unnecessary kfree() call in wil_tid_ampdu_rx_alloc()

-- 
https://patchwork.kernel.org/patch/11117119/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

