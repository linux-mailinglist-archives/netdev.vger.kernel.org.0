Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E47E010A17F
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 16:51:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727980AbfKZPv3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 10:51:29 -0500
Received: from a27-186.smtp-out.us-west-2.amazonses.com ([54.240.27.186]:33060
        "EHLO a27-186.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727309AbfKZPv3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 10:51:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1574783488;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:Message-ID:MIME-Version:Content-Type;
        bh=OZJTMwpsVQ23liobAV7+2B2ZxI/UOTY/zs9RL+K5fZo=;
        b=WzLM8aj/HH7Nyy0k28Ui2n4Wj/4tHKEbRRPRLRaIwuRXs4+mSvqFcIKWmgWibbyV
        H876WkHEgAqHBd2VZ4fqpnLCKOmDbog1pPaXeHCVG9/QrvJabCQ2upR6zrcFxh9QiQk
        VD//p+zAsQ6VMsGmIcFsFav00j9Tro62p/HP6ibg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1574783488;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:Message-ID:MIME-Version:Content-Type:Feedback-ID;
        bh=OZJTMwpsVQ23liobAV7+2B2ZxI/UOTY/zs9RL+K5fZo=;
        b=KnJdKpOtT8pczrzGcs5LLyui+Q7csaLksouPGaroAM9r/xvNlVinOZrOPJOoSHan
        VFKB42zARC8JkJimuiBzXr3IgBJpZ0ZeyJJ9iRikzYmtUjF4/9HLr8sqz3odKpherwt
        dfWzhbEiAxoiwjEEXDs0xVhd5rUe2prQhC1d71Cg=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: *
X-Spam-Status: No, score=1.3 required=2.0 tests=ALL_TRUSTED,SPF_NONE,
        TVD_SUBJ_WIPE_DEBT,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 55329C43383
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     "H. Nikolaus Schaller" <hns@goldelico.com>
Cc:     Ulf Hansson <ulf.hansson@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexios Zavras <alexios.zavras@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        letux-kernel@openphoenux.org, kernel@pyra-handheld.com
Subject: Re: [PATCH 0/2] net: wireless: ti: wl1251: sdio: remove ti,power-gpio
References: <cover.1574591746.git.hns@goldelico.com>
Date:   Tue, 26 Nov 2019 15:51:28 +0000
In-Reply-To: <cover.1574591746.git.hns@goldelico.com> (H. Nikolaus Schaller's
        message of "Sun, 24 Nov 2019 11:35:44 +0100")
Message-ID: <0101016ea8691216-b66b8927-1253-47c6-9c57-ec4d52776c7c-000000@us-west-2.amazonses.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-SES-Outgoing: 2019.11.26-54.240.27.186
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"H. Nikolaus Schaller" <hns@goldelico.com> writes:

> The driver has been updated to use the mmc/sdio core
> which does full power control. So we do no longer need
> the power control gipo.
>
> Note that it is still needed for the SPI based interface
> (N900).
>
> Suggested by: Ulf Hansson <ulf.hansson@linaro.org>
> Tested by: H. Nikolaus Schaller <hns@goldelico.com> # OpenPandora 600MHz
>
> H. Nikolaus Schaller (2):
>   DTS: bindings: wl1251: mark ti,power-gpio as optional
>   net: wireless: ti: wl1251: sdio: remove ti,power-gpio
>
>  .../bindings/net/wireless/ti,wl1251.txt       |  3 +-
>  drivers/net/wireless/ti/wl1251/sdio.c         | 30 -------------------
>  2 files changed, 2 insertions(+), 31 deletions(-)

Via which tree are these planned to go? Please always document that in
the cover letter so that maintainers don't need to guess.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
