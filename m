Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 380FD149B69
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 16:31:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727067AbgAZPb0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 10:31:26 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:29526 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726240AbgAZPbZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 10:31:25 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1580052685; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=bO52typVteT+dUc0mpKNPXbpFZmLnOhBYL05cpNAgdY=;
 b=ouZuhw1jQ9rQ4LafFuoCAjyrAMClwnm4XZVJzwRHyQsQkfs0pWUBcAtpmOP6xAJ/p8ZSMkEN
 hppLP3sNKNlYmMFeVXLPYgUGU0XVaKPRaa/IwsU72tokc7ixV2JO31WRi4oXjAxPYKiuqTy1
 ZDh+SZa+tkM9yR+kmA0HLynMWho=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e2db0c4.7f4b9dbef650-smtp-out-n02;
 Sun, 26 Jan 2020 15:31:16 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id A1C26C4479F; Sun, 26 Jan 2020 15:31:16 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 96579C433CB;
        Sun, 26 Jan 2020 15:31:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 96579C433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 1/2] DTS: bindings: wl1251: mark ti,
 power-gpio as optional
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <de42cdd5c5d2c46978c15cd2f27b49fa144ae6a7.1576606020.git.hns@goldelico.com>
References: <de42cdd5c5d2c46978c15cd2f27b49fa144ae6a7.1576606020.git.hns@goldelico.com>
To:     "H. Nikolaus Schaller" <hns@goldelico.com>
Cc:     Ulf Hansson <ulf.hansson@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "H. Nikolaus Schaller" <hns@goldelico.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexios Zavras <alexios.zavras@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        letux-kernel@openphoenux.org, kernel@pyra-handheld.com
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20200126153116.A1C26C4479F@smtp.codeaurora.org>
Date:   Sun, 26 Jan 2020 15:31:16 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"H. Nikolaus Schaller" <hns@goldelico.com> wrote:

> It is now only useful for SPI interface.
> Power control of SDIO mode is done through mmc core.
> 
> Suggested by: Ulf Hansson <ulf.hansson@linaro.org>
> Acked-by: Rob Herring <robh@kernel.org>
> Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>

Failed to apply to wireless-drivers-next, please rebase and resend.

fatal: sha1 information is lacking or useless (drivers/net/wireless/ti/wl1251/sdio.c).
error: could not build fake ancestor
Applying: wl1251: remove ti,power-gpio for SDIO mode
Patch failed at 0001 wl1251: remove ti,power-gpio for SDIO mode
The copy of the patch that failed is found in: .git/rebase-apply/patch

2 patches set to Changes Requested.

11298403 [PATCH v2 1/2] DTS: bindings: wl1251: mark ti,power-gpio as optional
11298399 [v2,2/2] wl1251: remove ti,power-gpio for SDIO mode

-- 
https://patchwork.kernel.org/patch/11298403/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
