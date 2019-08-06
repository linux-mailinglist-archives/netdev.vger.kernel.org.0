Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CBEF83183
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 14:38:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731272AbfHFMiF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 08:38:05 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:33056 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726963AbfHFMiF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 08:38:05 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 045FC60867; Tue,  6 Aug 2019 12:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1565095084;
        bh=MxZhSS0UWUmECTjQ0ibmB7ZYrZbDHvCAoNBYCGsedcY=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=fFf05Ghd1HjbOOk90sDs68AkTudhUvAB6VHZaXgqcBoXIIVpaoyaTBIhdOAqTzWLc
         YIIzoGwfiB49I9dScLnopeLIcEtYeTCLOf2T9Z7sY1yXBnj6QGSK+ekadenRDXJqzg
         wCg+v1wCA2K2vHj3RHEY7Ipi15OVZ2v4X/E2hWMA=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1843F60590;
        Tue,  6 Aug 2019 12:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1565095083;
        bh=MxZhSS0UWUmECTjQ0ibmB7ZYrZbDHvCAoNBYCGsedcY=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=BTWajMH4jO+v9S+Qy4uvvdRI7OKpKCIbvAy3fzTBuUv8G12OXRed6//7q4y9tB1hM
         AnMGUCnqG1bhEi5jDf+hAILcwoDpoNGlEkYdV1irlhPhw2IHSRyiCQLBjRT4YwyilM
         Tu9ZUlLQIoKhKEkwm0xtuHkkVrr7u7auuJOKswjY=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 1843F60590
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] brcmsmac: remove three set but not used variables
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190726141535.33212-1-yuehaibing@huawei.com>
References: <20190726141535.33212-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <arend.vanspriel@broadcom.com>, <franky.lin@broadcom.com>,
        <hante.meuleman@broadcom.com>, <chi-hsien.lin@cypress.com>,
        <wright.feng@cypress.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        <brcm80211-dev-list@cypress.com>,
        YueHaibing <yuehaibing@huawei.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190806123804.045FC60867@smtp.codeaurora.org>
Date:   Tue,  6 Aug 2019 12:38:03 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

YueHaibing <yuehaibing@huawei.com> wrote:

> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c: In function 'brcms_c_set_gmode':
> drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c:5257:7: warning: variable 'preamble_restrict' set but not used [-Wunused-but-set-variable]
> drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c:5256:6: warning: variable 'preamble' set but not used [-Wunused-but-set-variable]
> drivers/net/wireless/broadcom/brcm80211/brcmsmac/main.c:5251:7: warning: variable 'shortslot_restrict' set but not used [-Wunused-but-set-variable]
> 
> They are never used so can be removed.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

de019a3bdd6e brcmsmac: remove three set but not used variables

-- 
https://patchwork.kernel.org/patch/11061171/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

