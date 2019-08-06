Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61A458316E
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 14:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731053AbfHFMfX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 08:35:23 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:59124 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726711AbfHFMfX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 08:35:23 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id F14306038E; Tue,  6 Aug 2019 12:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1565094922;
        bh=gv40czC8W7p7170bItve1hV5D8Z0t1kPRZSMBfNrcGo=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=EUXGgH2QkjXnt3ijggDZdhN+N9C0v+TiljDYA1om2F4u9QATJF9nJc5vlbv0E13yn
         psUAHhpnY0NCdqIjBhI6BeEkqrhrXtCh7RJDepwirBo4jDNGl2fTo5FlDYkQQg8n9X
         UzgWqPzW4vOXMzNoZb9xBF+8V4do8jqDiUvVpRMo=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D57FB608BA;
        Tue,  6 Aug 2019 12:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1565094920;
        bh=gv40czC8W7p7170bItve1hV5D8Z0t1kPRZSMBfNrcGo=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=SEEExJRBr1twUsdRIbOGgUBC6KsjR/2zkAI0mffL/9C1kFpG4lVNYLtB4nAhogNIF
         H1s/zI8HHqbM7T+V7Egd5XFqj9eUCqGNhuxzcyOtIyq6lDUnVD37EjIFz7FlhM8+8o
         NibXTHVbWw/YW71sviiePrWqKQYrKvsCwgh+ykw4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D57FB608BA
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] brcmfmac: remove set but not used variable 'dtim_period'
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190724141201.59640-1-yuehaibing@huawei.com>
References: <20190724141201.59640-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <arend.vanspriel@broadcom.com>, <franky.lin@broadcom.com>,
        <hante.meuleman@broadcom.com>, <chi-hsien.lin@cypress.com>,
        <wright.feng@cypress.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        <brcm80211-dev-list@cypress.com>,
        YueHaibing <yuehaibing@huawei.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190806123521.F14306038E@smtp.codeaurora.org>
Date:   Tue,  6 Aug 2019 12:35:21 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

YueHaibing <yuehaibing@huawei.com> wrote:

> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c: In function brcmf_update_bss_info:
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c:2962:5: warning: variable dtim_period set but not used [-Wunused-but-set-variable]
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c: In function brcmf_update_bss_info:
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c:2961:6: warning: variable beacon_interval set but not used [-Wunused-but-set-variable]
> 
> They are never used so can be removed.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

cddecd92d1ec brcmfmac: remove set but not used variable 'dtim_period'

-- 
https://patchwork.kernel.org/patch/11056999/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

