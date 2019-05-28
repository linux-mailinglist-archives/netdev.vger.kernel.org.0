Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B65D92C6B7
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 14:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727338AbfE1Mh5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 08:37:57 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:48414 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726933AbfE1Mh5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 08:37:57 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 1967C602FA; Tue, 28 May 2019 12:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1559047076;
        bh=tOV1/SreqL/7ZwdpcWvgymFJBmwH1p/BIr0czREP/1g=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=b7g6fMAxRWSd7m7QkCLv64qZTAVxO2gE+uTiBk9PggtpLxX2TeqPr1X9DqxfGUjdS
         R8ChfGwTFwMpGBOh/Z0kvsQZZqnzrSovKkxFWqCzaW11S/5RSZQxJXLDBGOP5+5FBe
         JZz0/4jLMTlPqyikxXjBPRXowhKsdK28Jo34kL9o=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7BE2860A42;
        Tue, 28 May 2019 12:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1559047074;
        bh=tOV1/SreqL/7ZwdpcWvgymFJBmwH1p/BIr0czREP/1g=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=DJKsrr9DNHCWppYWzDGpf3P1lY64A+4vwNr3m7Z6jiDimme7BCX7t7CJE9Cnsz6sg
         MguNPiEjmXvDx47Ecgjn/f/P7BaT17atXjXSkKbwq8CuMKlFM9N62+X5CWb2XDJ6Yn
         n2SmH/47Ny/WG55oAMhvt+t0COyvXB29EagrYS/w=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7BE2860A42
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtlwifi: btcoex: Remove set but not used variable 'len'
 and 'asso_type_v2'
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190525144634.10696-1-yuehaibing@huawei.com>
References: <20190525144634.10696-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <pkshih@realtek.com>, <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190528123756.1967C602FA@smtp.codeaurora.org>
Date:   Tue, 28 May 2019 12:37:55 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

YueHaibing <yuehaibing@huawei.com> wrote:

> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c: In function rtl_btc_btmpinfo_notify:
> drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c:319:17: warning: variable len set but not used [-Wunused-but-set-variable]
> drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c: In function exhalbtc_connect_notify:
> drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c:1581:16: warning: variable asso_type_v2 set but not used [-Wunused-but-set-variable]
> 
> 'len' is never used since commit 6aad6075ccd5 ("rtlwifi:
> Add BT_MP_INFO to c2h handler.") so can be removed.
> 
> 'asso_type_v2' is not used since introduction in
> commit 0843e98a3b9a ("rtlwifi: btcoex: add assoc
> type v2 to connection notify")
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

d477a4856aec rtlwifi: btcoex: Remove set but not used variable 'len' and 'asso_type_v2'

-- 
https://patchwork.kernel.org/patch/10960843/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

