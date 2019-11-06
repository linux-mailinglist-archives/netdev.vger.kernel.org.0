Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C987CF1CD7
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 18:53:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732268AbfKFRxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 12:53:06 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:33636 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726963AbfKFRxG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 12:53:06 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 9444760A50; Wed,  6 Nov 2019 17:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573062784;
        bh=FBAsM4UfKbF/1hIsSiGDVdA7NGJpS4niuM43oKzw4ro=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=H0i959ZT7rH3cLBqeSKBNY46+MGS5vFlWMiLHtDbuXT2q2dxl/NvR9G1S4aXsKs0T
         Tb1hhMW9OnAjN7S16ZS0GB/qttw/5N+ElZQ/E/RisRpnJTxFIk/eQME2EvUDNmh/bi
         BgHzUadts1k7nkzbyo6ZOG4p8iJDct6loIvuZq18=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6869C6087D;
        Wed,  6 Nov 2019 17:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573062783;
        bh=FBAsM4UfKbF/1hIsSiGDVdA7NGJpS4niuM43oKzw4ro=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=UxGOxDobUkVusZ6wyY2xLGZrU0IDCcbaBAdCQqzmKH23lnk/a/s2N+pvxpnxKHEc/
         0Z9ZhJjoZaYb47Sx2zAci364IRCxZXb5a+34qGnroxjlXciZfOBhytnqutOsBu/AxM
         5ThkCUOJZYqwH/nbTwlgxDUHjoMAI35tGbLSsNwM=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6869C6087D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 1/2] ipw2x00: Remove redundant variable "rc"
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1572684922-61805-2-git-send-email-zhongjiang@huawei.com>
References: <1572684922-61805-2-git-send-email-zhongjiang@huawei.com>
To:     zhong jiang <zhongjiang@huawei.com>
Cc:     <stas.yakovlev@gmail.com>, <simon.horman@netronome.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <zhongjiang@huawei.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191106175304.9444760A50@smtp.codeaurora.org>
Date:   Wed,  6 Nov 2019 17:53:04 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

zhong jiang <zhongjiang@huawei.com> wrote:

> local variable "rc" is not used. It is safe to remove and
> There is only one caller of libipw_qos_convert_ac_to_parameters().
> hence make it void
> 
> Signed-off-by: zhong jiang <zhongjiang@huawei.com>

2 patches applied to wireless-drivers-next.git, thanks.

e310813279b7 ipw2x00: Remove redundant variable "rc"
ea7ad5f12ca2 iwlegacy: Remove redundant variable "ret"

-- 
https://patchwork.kernel.org/patch/11224069/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

