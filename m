Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E2E1ABA5B
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 16:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394056AbfIFOK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 10:10:29 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:44702 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728978AbfIFOK3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 10:10:29 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 898D76115B; Fri,  6 Sep 2019 14:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567779028;
        bh=feH1EvpOenhl2IGvjR9dljrk5cvxpWB/HARVbpGVAN0=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Ez1yUFu1Fgmpvd5G6H+wdWAIcs5EaWqKd8arPaUpsDc2kk47aAZU6kKvAGW3bdwZk
         4CXbQHg6GT0Vcbvycc8WQrxLLN3TqLNRk7K7DmWSsVku1CZW3LMnzMgdvui3m+dYLw
         BE8GTmWGOrVXZ9UbomOl/7E26webKgg73eG0cvRs=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 53CBD607F4;
        Fri,  6 Sep 2019 14:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567779027;
        bh=feH1EvpOenhl2IGvjR9dljrk5cvxpWB/HARVbpGVAN0=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=ZUGx+jQAkcNoXXo+DGw9/K6eTWQoqojqiFVvT2e3u5/fhjpS6EqcNmJLcaLpmY3Qm
         yxrfOCRE+3VNgEx91mn/dBdlU+lpPBEiJWyN29nMpZ9XB0ez6iCZgBZJQ2/p2TkLZ/
         Q2L/yYjB+Sy/Wy4jzqIuMtVaKEJhF4PRJ4MG7r2k=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 53CBD607F4
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] hostap: remove set but not used variable 'copied' in
 prism2_io_debug_proc_read
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1567497430-22539-1-git-send-email-zhongjiang@huawei.com>
References: <1567497430-22539-1-git-send-email-zhongjiang@huawei.com>
To:     zhong jiang <zhongjiang@huawei.com>
Cc:     <davem@davemloft.net>, <zhongjiang@huawei.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190906141028.898D76115B@smtp.codeaurora.org>
Date:   Fri,  6 Sep 2019 14:10:28 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

zhong jiang <zhongjiang@huawei.com> wrote:

> Obviously, variable 'copied' is initialized to zero. But it is not used.
> hence just remove it.
> 
> Signed-off-by: zhong jiang <zhongjiang@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

64827a6ac049 hostap: remove set but not used variable 'copied' in prism2_io_debug_proc_read

-- 
https://patchwork.kernel.org/patch/11127357/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

