Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D249149B8D
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 16:44:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728253AbgAZPnq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 10:43:46 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:64819 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726252AbgAZPnq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 10:43:46 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1580053425; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=pejZ+l4byocUl4MO9Xh34Wf+bv32hnImIXB9SxfFKhw=;
 b=S/ZpsuyI9pTYlbCJlV/z9byzgr+KAzgzVV8gzkzJ2Qr/+Fzhy64x0i0uq6GTl/tneN0HrjJY
 6ITBqBUEACNPa/LyUU9Iykzy00uspgi6iZRXBPbx+ETzGMPjXkHw/XcvIIImaA5CUG6hDZPw
 FmGPuJ2dzgQgG4zjPE9Y1q+vkeQ=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e2db3b0.7f8407011768-smtp-out-n03;
 Sun, 26 Jan 2020 15:43:44 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id BBC4EC433CB; Sun, 26 Jan 2020 15:43:44 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 043C8C43383;
        Sun, 26 Jan 2020 15:43:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 043C8C43383
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] brcmfmac: Remove always false 'idx < 0' statement
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200108135748.46096-1-yuehaibing@huawei.com>
References: <20200108135748.46096-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <arend.vanspriel@broadcom.com>, <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        <brcm80211-dev-list@cypress.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, yuehaibing <yuehaibing@huawei.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20200126154344.BBC4EC433CB@smtp.codeaurora.org>
Date:   Sun, 26 Jan 2020 15:43:44 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

YueHaibing <yuehaibing@huawei.com> wrote:

> From: yuehaibing <yuehaibing@huawei.com>
> 
> idx is declared as u32, it will never less than 0.
> 
> Signed-off-by: yuehaibing <yuehaibing@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

627b0d094240 brcmfmac: Remove always false 'idx < 0' statement

-- 
https://patchwork.kernel.org/patch/11323743/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
