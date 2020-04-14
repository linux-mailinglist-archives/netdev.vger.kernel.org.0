Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FEB31A8169
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 17:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436730AbgDNPHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 11:07:53 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:58409 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2440192AbgDNPHc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 11:07:32 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1586876852; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=pzkx7xJD1kBHfGD+u6PRwl7F+O1g7GJzrEjUCdwfk/E=;
 b=kRM9L2re+bU432M7oNCQ2HSWbX0m5nOVxEe1/8upFff6aM09o0Jl9yHE5IjQ7XftFPCwEg4+
 boPd1Gc8yMcLwXp2om88OgrLh/7lkZ6ADlsaiam5AwbQk6DwvfltGmB8ufs38lm84bgX2ahl
 p1kpa0ToNcrgpr67tV58RfNlvfI=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e95d1b0.7f7bb752a650-smtp-out-n01;
 Tue, 14 Apr 2020 15:07:28 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id D6DA0C4478C; Tue, 14 Apr 2020 15:07:28 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A6BEFC433CB;
        Tue, 14 Apr 2020 15:07:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A6BEFC433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] rtw88: Add delay on polling h2c command status bit
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200407073331.397-1-kai.heng.feng@canonical.com>
References: <20200407073331.397-1-kai.heng.feng@canonical.com>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     yhchuang@realtek.com, Kai-Heng Feng <kai.heng.feng@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org (open list:REALTEK WIRELESS DRIVER
        (rtw88)), netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20200414150728.D6DA0C4478C@smtp.codeaurora.org>
Date:   Tue, 14 Apr 2020 15:07:28 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kai-Heng Feng <kai.heng.feng@canonical.com> wrote:

> On some systems we can constanly see rtw88 complains:
> [39584.721375] rtw_pci 0000:03:00.0: failed to send h2c command
> 
> Increase interval of each check to wait the status bit really changed.
> 
> Use read_poll_timeout() macro which fits anything we need here.
> 
> Suggested-by: Kalle Valo <kvalo@codeaurora.org>
> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>

Patch applied to wireless-drivers-next.git, thanks.

6343a6d4b213 rtw88: Add delay on polling h2c command status bit

-- 
https://patchwork.kernel.org/patch/11477667/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
