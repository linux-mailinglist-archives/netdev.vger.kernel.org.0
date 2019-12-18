Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49724125152
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 20:08:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727176AbfLRTIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 14:08:21 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:37146 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726977AbfLRTIV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 14:08:21 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1576696101; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=qQSpG31J9fgt1SjmqMtElSf39s1qpOaYfUBbH0rizn8=;
 b=jOe21twmOQfXRv7o6zsqeuSyE5thcaazTiblGjvg6xnFBNwom7Uvsopd2atX9mE9TCkNsTqV
 OtUiAABSnzSehWz1czQorPPg2Q8dDPH3UYcC72gRIY+q+ZG2CVXqa+koEckzbrXoWgfzi+Z3
 Erg9coVaBGXVx35rHNff+tgvad0=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5dfa7923.7f71602adf80-smtp-out-n03;
 Wed, 18 Dec 2019 19:08:19 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id A35BAC4479F; Wed, 18 Dec 2019 19:08:18 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C3B31C43383;
        Wed, 18 Dec 2019 19:08:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C3B31C43383
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 1/9] brcmfmac: reset two D11 cores if chip has two D11
 cores
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20191211235253.2539-2-smoch@web.de>
References: <20191211235253.2539-2-smoch@web.de>
To:     Soeren Moch <smoch@web.de>
Cc:     Heiko Stuebner <heiko@sntech.de>,
        Wright Feng <wright.feng@cypress.com>,
        Soeren Moch <smoch@web.de>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191218190818.A35BAC4479F@smtp.codeaurora.org>
Date:   Wed, 18 Dec 2019 19:08:18 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Soeren Moch <smoch@web.de> wrote:

> From: Wright Feng <wright.feng@cypress.com>
> 
> There are two D11 cores in RSDB chips like 4359. We have to reset two
> D11 cores simutaneously before firmware download, or the firmware may
> not be initialized correctly and cause "fw initialized failed" error.
> 
> Signed-off-by: Wright Feng <wright.feng@cypress.com>
> Signed-off-by: Soeren Moch <smoch@web.de>
> Reviewed-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>

7 patches applied to wireless-drivers-next.git, thanks.

1b8d2e0a9e42 brcmfmac: reset two D11 cores if chip has two D11 cores
172f6854551d brcmfmac: set F2 blocksize and watermark for 4359
6647274ed995 brcmfmac: fix rambase for 4359/9
c12c8913d79c brcmfmac: make errors when setting roaming parameters non-fatal
d4aef159394d brcmfmac: add support for BCM4359 SDIO chipset
837482e69a3f brcmfmac: add RSDB condition when setting interface combinations
2635853ce4ab brcmfmac: not set mbss in vif if firmware does not support MBSS

-- 
https://patchwork.kernel.org/patch/11286565/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
