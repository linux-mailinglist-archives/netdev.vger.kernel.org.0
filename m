Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64551EAB46
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 09:05:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726963AbfJaIFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 04:05:17 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:41816 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726747AbfJaIFR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 04:05:17 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id BFC5360907; Thu, 31 Oct 2019 08:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572509116;
        bh=zfPjYfxYvEa2P4UUr9Y4+q9hJp/scBvnbb1Oc55091Q=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=d8lMcHEv5opneU5qnfD78MRDQahkaNJtov+IHjpZi56KOctkfOgtrVehjPKWLDluz
         YSS4hkBehXaHPDxSG9wDcxG9riOCtwB4A4RQtp/2QB/IAP3ecYkBnmHeB4lCpuQaBU
         xjyCGg7y5xFry1aT8569H/moL8naxk0rZJNMn7Vk=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1C5B9603A3;
        Thu, 31 Oct 2019 08:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572509116;
        bh=zfPjYfxYvEa2P4UUr9Y4+q9hJp/scBvnbb1Oc55091Q=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=kDdIjhGZm21VV7lsdD7YeP4MWS3CAtGS6K5qfASN2fPkwVFs6SB4IxuVKZPRglqSw
         EA0qA5gHnjDJ5QCPg3SOX0qcFFMMa4wm87QJ/MtHPbF18aU1xHly1saNnH4HBsmHLa
         PXhQMk82D0HWcSICCdKQCS7thWFvMCf4NM3fqbZw=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 1C5B9603A3
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH][next] rtw88: remove redundant null pointer check on arrays
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20191025113056.19167-1-colin.king@canonical.com>
References: <20191025113056.19167-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Yan-Hsuan Chuang <yhchuang@realtek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Chris Chiu <chiu@endlessm.com>,
        Tzu-En Huang <tehuang@realtek.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191031080516.BFC5360907@smtp.codeaurora.org>
Date:   Thu, 31 Oct 2019 08:05:16 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> The checks to see if swing_table->n or swing_table->p are null are
> redundant since n and p are arrays and can never be null if
> swing_table is non-null.  I believe these are redundant checks
> and can be safely removed, especially the checks implies that these
> are not arrays which can lead to confusion.
> 
> Addresses-Coverity: ("Array compared against 0")
> Fixes: c97ee3e0bea2 ("rtw88: add power tracking support")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Patch applied to wireless-drivers-next.git, thanks.

baff8da6e163 rtw88: remove redundant null pointer check on arrays

-- 
https://patchwork.kernel.org/patch/11212093/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

