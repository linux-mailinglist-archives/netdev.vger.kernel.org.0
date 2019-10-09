Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CAA0D098D
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 10:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730059AbfJIIWV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 04:22:21 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:54612 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725962AbfJIIWV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 04:22:21 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 689FD61B7E; Wed,  9 Oct 2019 08:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570609340;
        bh=3q49RChPIeodm8hyvkPcXxTSL3F6hIu9tGu6GIDDsS8=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=ebsvAaCszp4jdvGOByOF0zAp4vZiCSUYQPpUtFvsP/22RqbFQTTo0BpGJxekbtLF7
         JHIlPlHQ9gEA4jfX6nvDXfQTMny+E0iOQLF49ZciqWq6+YyhWPt9k0PXaKJEwkG7Mj
         6jufeExlKx5zasIZiGxR+d3XcP3SlOGsTcJS5StM=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7BEC561B4A;
        Wed,  9 Oct 2019 08:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570609318;
        bh=3q49RChPIeodm8hyvkPcXxTSL3F6hIu9tGu6GIDDsS8=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=cSbPKbmfiu0KG18184qCjFxc3EzegzAgaPo0JA8OPd7M2EanJHBsB+m+qNFyBK6La
         ZLxJEcU8wc5oHd/5bYbsXjyxMXvkrXsO31EnkFM+K00jcisy3zdtFArD0ff90iZ+q3
         W8PGiZNqhMgchDuy6sjY8Uch4526lFi0AdnBMVKU=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7BEC561B4A
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] rtlwifi: rtl8192ee: Remove set but not used variable
 'err'
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <2ca176f2-e9ef-87cd-7f7d-cd51c67da38b@huawei.com>
References: <2ca176f2-e9ef-87cd-7f7d-cd51c67da38b@huawei.com>
To:     "zhengbin (A)" <zhengbin13@huawei.com>
Cc:     <pkshih@realtek.com>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <zhengbin13@huawei.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191009082220.689FD61B7E@smtp.codeaurora.org>
Date:   Wed,  9 Oct 2019 08:21:59 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"zhengbin (A)" <zhengbin13@huawei.com> wrote:

> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c: In function rtl92ee_download_fw:
> drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c:111:6: warning: variable err set but not used [-Wunused-but-set-variable]
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: zhengbin <zhengbin13@huawei.com>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

Failed to apply:

fatal: corrupt patch at line 13
error: could not build fake ancestor
Applying: rtlwifi: rtl8192ee: Remove set but not used variable 'err'
Patch failed at 0001 rtlwifi: rtl8192ee: Remove set but not used variable 'err'
The copy of the patch that failed is found in: .git/rebase-apply/patch

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/patch/11173619/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

