Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3EC552260
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 07:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727600AbfFYFAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 01:00:32 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:59880 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727542AbfFYFAc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 01:00:32 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 781D36019D; Tue, 25 Jun 2019 05:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1561438831;
        bh=498LlqTssMTOzihdZR45pUM/6FzdK0i56t9QeeZDj7A=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=L85uM5o9ga4HKblcNDEEZ8YTUYLVZYxdxhgqqJImurGXGjhF20mZTrznLyjVbKpVR
         jvE4FcGnLoSEhtgq0sSE6UizmETVRHKufVFzTKy55jRqAl+x9B7WuaQR4h/NQX71fb
         oGNoDbn8QjC00JoPC3f0C4qtq5V5xKW5ImW5Gksk=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6899A6019D;
        Tue, 25 Jun 2019 05:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1561438830;
        bh=498LlqTssMTOzihdZR45pUM/6FzdK0i56t9QeeZDj7A=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=Wg6hs+RIxPJlxgxiPTYN0GuOKMbZoPMNx6mZUxT4wNCNwGok241O7TuNod07pRG16
         E0O+pZB8SGxJML16RN1dvRjelfaz9npL/+E5oAZyyhn90N89Pkv3g4SD8TEzR4ROlq
         g0Wd8uM0xXj5I4l+b9CC4xLU1fitUWqy1nyor/aI=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6899A6019D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtlwifi: remove redundant assignment to variable k
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190531141412.18632-1-colin.king@canonical.com>
References: <20190531141412.18632-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190625050031.781D36019D@smtp.codeaurora.org>
Date:   Tue, 25 Jun 2019 05:00:31 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> The assignment of 0 to variable k is never read once we break out of
> the loop, so the assignment is redundant and can be removed.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Patch applied to wireless-drivers-next.git, thanks.

f0822dfc5887 rtlwifi: remove redundant assignment to variable k

-- 
https://patchwork.kernel.org/patch/10970261/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

