Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16E48D0F47
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 14:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731147AbfJIM6I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 08:58:08 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:57470 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730765AbfJIM6I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 08:58:08 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id E715160AA8; Wed,  9 Oct 2019 12:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570625886;
        bh=Ey3JcADzZq0JNAquPvYQB5wL7Yp4FKioADNOOeAivCk=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=N60HIJMEuGZWALQrRHiB1H5B4nw14VAadR00WEljjgHMmhw7qShXBWSzTKFB8jTDY
         gyX2BV5nV3uwEjrTKAFYKCoPe2977qUK1LhOhrCyKI0sZgQ6wNT5d6vjwLsGcD28+N
         ChrbB++alstlU/8G0lcjRMfQOlvfWoeVjm0Amyhs=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from x230.qca.qualcomm.com (85-76-42-199-nat.elisa-mobile.fi [85.76.42.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id EF8CA601E7;
        Wed,  9 Oct 2019 12:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570625886;
        bh=Ey3JcADzZq0JNAquPvYQB5wL7Yp4FKioADNOOeAivCk=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=N60HIJMEuGZWALQrRHiB1H5B4nw14VAadR00WEljjgHMmhw7qShXBWSzTKFB8jTDY
         gyX2BV5nV3uwEjrTKAFYKCoPe2977qUK1LhOhrCyKI0sZgQ6wNT5d6vjwLsGcD28+N
         ChrbB++alstlU/8G0lcjRMfQOlvfWoeVjm0Amyhs=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org EF8CA601E7
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     zhengbin <zhengbin13@huawei.com>
Cc:     <pkshih@realtek.com>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH RESEND] rtlwifi: rtl8192ee: Remove set but not used variable 'err'
References: <1570612107-13286-1-git-send-email-zhengbin13@huawei.com>
Date:   Wed, 09 Oct 2019 15:58:01 +0300
In-Reply-To: <1570612107-13286-1-git-send-email-zhengbin13@huawei.com>
        (zhengbin's message of "Wed, 9 Oct 2019 17:08:27 +0800")
Message-ID: <8736g2rs86.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

zhengbin <zhengbin13@huawei.com> writes:

> Fixes gcc '-Wunused-but-set-variable' warning:
>
> drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c: In function rtl92ee_download_fw:
> drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c:111:6: warning: variable err set but not used [-Wunused-but-set-variable]
>
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: zhengbin <zhengbin13@huawei.com>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

There's no changelog, why did you resend? Document clearly the changes
so that maintainers don't need to guess what has changed:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#changelog_missing

-- 
Kalle Valo
