Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4D32149BDA
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 17:16:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727235AbgAZQQp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 11:16:45 -0500
Received: from mail25.static.mailgun.info ([104.130.122.25]:62191 "EHLO
        mail25.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726382AbgAZQQn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 11:16:43 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1580055403; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=lr+xGq2cRABIFvF1CRWE8np6LPQFBquD6OYJy0WT20Q=; b=pDunXXotn1DM9ipzNQA3MY0TxVWHwAdDr5iZXNs6DSlXJ1yWHUWKkgASQtm/9Ma5z9QNlpcd
 ibbTYl9PwIAYxjjS9/KK8GXjrO6Yy8urMZu07/w+JO66zWvj1kaLKGVhFNDte+sJ04iYKuvB
 ArHcQzWKD16x8n+JxLDClRA6Rkk=
X-Mailgun-Sending-Ip: 104.130.122.25
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e2dbb66.7f2292cc4538-smtp-out-n03;
 Sun, 26 Jan 2020 16:16:38 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id DA6DDC4479C; Sun, 26 Jan 2020 16:16:36 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id EB0FAC43383;
        Sun, 26 Jan 2020 16:16:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org EB0FAC43383
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     "H. Nikolaus Schaller" <hns@goldelico.com>
Cc:     Ulf Hansson <ulf.hansson@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexios Zavras <alexios.zavras@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        letux-kernel@openphoenux.org, kernel@pyra-handheld.com
Subject: Re: ***UNCHECKED*** Re: [PATCH v2 1/2] DTS: bindings: wl1251: mark ti, power-gpio as optional
References: <de42cdd5c5d2c46978c15cd2f27b49fa144ae6a7.1576606020.git.hns@goldelico.com>
        <20200126153116.2E6E8C433A2@smtp.codeaurora.org>
        <8FB64063-5DE1-4C13-8647-F3C5B0D3E999@goldelico.com>
Date:   Sun, 26 Jan 2020 18:16:30 +0200
In-Reply-To: <8FB64063-5DE1-4C13-8647-F3C5B0D3E999@goldelico.com> (H. Nikolaus
        Schaller's message of "Sun, 26 Jan 2020 17:03:36 +0100")
Message-ID: <87ftg2chwh.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"H. Nikolaus Schaller" <hns@goldelico.com> writes:

> Hi,
>
>> Am 26.01.2020 um 16:31 schrieb Kalle Valo <kvalo@codeaurora.org>:
>> 
>> "H. Nikolaus Schaller" <hns@goldelico.com> wrote:
>> 
>>> It is now only useful for SPI interface.
>>> Power control of SDIO mode is done through mmc core.
>>> 
>>> Suggested by: Ulf Hansson <ulf.hansson@linaro.org>
>>> Acked-by: Rob Herring <robh@kernel.org>
>>> Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
>> 
>> Failed to apply to wireless-drivers-next, please rebase and resend.
>
> On which commit and/or tree do you want to apply it?

I said it above, wireless-drivers-next:

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git/

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
