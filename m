Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD2D411BF0
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 16:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbfEBO6l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 10:58:41 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:39106 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726197AbfEBO6i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 10:58:38 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 0511B608D4; Thu,  2 May 2019 14:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556809117;
        bh=FEqQA6mURavj3aREhqTvLezlNLMBGSwPuDJJrCP+Ylo=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=RZ45vaZybJMHHvi0Lir6N+5+GOc+u7Mkr3v6Agzm4uG9AoXsGg2MA29I1+RZ0Bs2n
         wqixkVJ8d9wF2VF+eXjarlUst6rOUha4lKQMgdvkgurTQ1evbekQPEMeJvTjeV7Y/1
         WcE7MIUb4zo6NxB2XDvN1UmIrBb9E7k/Ce5G9/3I=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,MISSING_DATE,MISSING_MID autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2132060746;
        Thu,  2 May 2019 14:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556809116;
        bh=FEqQA6mURavj3aREhqTvLezlNLMBGSwPuDJJrCP+Ylo=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=Kr/TGZV/vjKi5YICmHMu1FNGw1iPCCSMCbytZ0nY5n85T18AJ6usNsf61l7PY9G8o
         gBrDFNNl/PfUMUGgOF+r8HnIQ8FzRlV/zRGtAI/kTid2cmasHcpNjmKcpKymYfvblO
         fMj9esuZgnQEd9dUbPOLu3xfiGPYp+3bkcpb36zc=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2132060746
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH][next] rtw88: fix shift of more than 32 bits of a integer
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190501141945.22522-1-colin.king@canonical.com>
References: <20190501141945.22522-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Yan-Hsuan Chuang <yhchuang@realtek.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190502145837.0511B608D4@smtp.codeaurora.org>
Date:   Thu,  2 May 2019 14:58:37 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently the shift of an integer value more than 32 bits can
> occur when nss is more than 32.  Fix this by making the integer
> constants unsigned long longs before shifting and bit-wise or'ing
> with the u64 ra_mask to avoid the undefined shift behaviour.
> 
> Addresses-Coverity: ("Bad shift operation")
> Fixes: e3037485c68e ("rtw88: new Realtek 802.11ac driver")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Patch applied to wireless-drivers-next.git, thanks.

b85bd9a14c4b rtw88: fix shift of more than 32 bits of a integer

-- 
https://patchwork.kernel.org/patch/10925147/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

