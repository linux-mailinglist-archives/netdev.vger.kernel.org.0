Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48DFB11C9B5
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 10:42:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728510AbfLLJm2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 04:42:28 -0500
Received: from a27-187.smtp-out.us-west-2.amazonses.com ([54.240.27.187]:35576
        "EHLO a27-187.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728465AbfLLJm1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 04:42:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1576143747;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:Message-ID:MIME-Version:Content-Type;
        bh=i0FaJubDuJMbNyKma+XSBPHXvIJXRnamxfGjizAg5l4=;
        b=l6UWAlhp4c1UwRAEsKPYS9QnBRUEkx/w2+EVBieXW4IiBtpBy+VndLMdbW3FFWHK
        IzXWPGjL3WQIn0i6Gp9S6s6jbngXQljN6ohlPolATAsdyqGQEn+3i2BzpUKyoYz1Can
        j/5w6AhVlHl89RkqyK98ETEwSM0/v+fjjCr8A04E=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1576143747;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:Message-ID:MIME-Version:Content-Type:Feedback-ID;
        bh=i0FaJubDuJMbNyKma+XSBPHXvIJXRnamxfGjizAg5l4=;
        b=VIapSaIOD9gR0F643X35qyagMez8wyq0TokCOAYxrW9AqbB3Ru4cMfr9GBm5smQ/
        cotETLB8vlaaW0Trcn45UuFfoj7YESB0tUpaZi64lg3ezJpppRaLA4actkNWjYcukeL
        FPvZ8KCcc4A88+CQ8t6tx/ot4TVajtfwU/z01H/Q=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 06A7FC433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Soeren Moch <smoch@web.de>
Cc:     Heiko Stuebner <heiko@sntech.de>, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/9] brcmfmac: add support for BCM4359 SDIO chipset
References: <20191211235253.2539-1-smoch@web.de>
Date:   Thu, 12 Dec 2019 09:42:26 +0000
In-Reply-To: <20191211235253.2539-1-smoch@web.de> (Soeren Moch's message of
        "Thu, 12 Dec 2019 00:52:44 +0100")
Message-ID: <0101016ef97cf78e-0df078ae-914e-42f3-9657-3fa4845357bc-000000@us-west-2.amazonses.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-SES-Outgoing: 2019.12.12-54.240.27.187
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Soeren Moch <smoch@web.de> writes:

> Add support for the BCM4359 chipset with SDIO interface and RSDB support
> to the brcmfmac wireless network driver in patches 1-7.
>
> Enhance devicetree of the RockPro64 arm64/rockchip board to use an
> AP6359SA based wifi/bt combo module with this chipset in patches 8-9.
>
>
> Chung-Hsien Hsu (1):
>   brcmfmac: set F2 blocksize and watermark for 4359
>
> Soeren Moch (5):
>   brcmfmac: fix rambase for 4359/9
>   brcmfmac: make errors when setting roaming parameters non-fatal
>   brcmfmac: add support for BCM4359 SDIO chipset
>   arm64: dts: rockchip: RockPro64: enable wifi module at sdio0
>   arm64: dts: rockchip: RockPro64: hook up bluetooth at uart0
>
> Wright Feng (3):
>   brcmfmac: reset two D11 cores if chip has two D11 cores
>   brcmfmac: add RSDB condition when setting interface combinations
>   brcmfmac: not set mbss in vif if firmware does not support MBSS
>
>  .../boot/dts/rockchip/rk3399-rockpro64.dts    | 50 +++++++++++---
>  .../broadcom/brcm80211/brcmfmac/bcmsdh.c      |  8 ++-
>  .../broadcom/brcm80211/brcmfmac/cfg80211.c    | 68 +++++++++++++++----
>  .../broadcom/brcm80211/brcmfmac/chip.c        | 54 ++++++++++++++-
>  .../broadcom/brcm80211/brcmfmac/chip.h        |  1 +
>  .../broadcom/brcm80211/brcmfmac/pcie.c        |  2 +-
>  .../broadcom/brcm80211/brcmfmac/sdio.c        | 17 +++++
>  include/linux/mmc/sdio_ids.h                  |  2 +
>  8 files changed, 176 insertions(+), 26 deletions(-)

Just to make sure we are on the same page, I will apply patches 1-7 to
wireless-drivers-next and patches 8-9 go to some other tree? And there
are no dependencies between the brcmfmac patches and dts patches?

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
