Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1270B83168
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 14:35:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730905AbfHFMez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 08:34:55 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:58136 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726373AbfHFMey (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 08:34:54 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id E807660907; Tue,  6 Aug 2019 12:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1565094893;
        bh=j3IQ8khHcAdJB6SI5pT6gGee/zo9CcFWWZR+13cdipw=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=FWKBS6ONTqycTpdUvDznP/W/W8n3FAZpYWWJSX8EGFMZR1FD787Xrk3qWT5pboN5t
         cP7Ix1Kt4RbKNlDndDSB3UUUYdy1g0bVqrdx2PcEkgj2G9FwkMTDXDMAv9tL8pTwXp
         XaEU9dVygJIW1K6C+frBI4e92cq2kFyItCGd8WjY=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9F2AE6038E;
        Tue,  6 Aug 2019 12:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1565094893;
        bh=j3IQ8khHcAdJB6SI5pT6gGee/zo9CcFWWZR+13cdipw=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=BfTgMDm82Kk71nxz6v6+Ttk1yGWKAow1KxtBYkNVcEKGpMNSTYP/eXpUEmLjFJY86
         y/1E6rpo3gRJ+1TGUYuD9cukkivkG2t6FwlNOttBa1xkWc+cPVMo9hXS6eT9WAZr1f
         BVHRVaGnU4t/6weyz51tWTCHEseCGK/0zObWW56Y=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9F2AE6038E
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtlwifi: remove unneeded function _rtl_dump_channel_map()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190724141020.58800-1-yuehaibing@huawei.com>
References: <20190724141020.58800-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <pkshih@realtek.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        <davem@davemloft.net>, YueHaibing <yuehaibing@huawei.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190806123453.E807660907@smtp.codeaurora.org>
Date:   Tue,  6 Aug 2019 12:34:53 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

YueHaibing <yuehaibing@huawei.com> wrote:

> Now _rtl_dump_channel_map() does not do any actual
> thing using the channel. So remove it.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

Patch applied to wireless-drivers-next.git, thanks.

a4a68f727fb8 rtlwifi: remove unneeded function _rtl_dump_channel_map()

-- 
https://patchwork.kernel.org/patch/11056997/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

