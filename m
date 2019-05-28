Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89C9A2C6BB
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 14:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727356AbfE1Mi2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 08:38:28 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:48864 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726592AbfE1Mi2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 08:38:28 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 729F16070D; Tue, 28 May 2019 12:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1559047107;
        bh=mizDFRaVoA1mbgxe7i0WEaL04QzUW2dApqTQldnf7o0=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=BPVaEybwexgzyWEQCkMWRGdWybllPvcQ5lYH714eSQZ6cz8QiFMZHPBdPIv26L4YE
         xzugIAgt0OwN1ha/57R1eeX0cqId3oL2LszWfFzFgaSi22L0/qDYFzZXVRUtFOqZ0H
         6NHzrc0feRrHYGEmQVJ4TBusTnHdlgNIFgP+Q3x0=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8731B6034D;
        Tue, 28 May 2019 12:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1559047107;
        bh=mizDFRaVoA1mbgxe7i0WEaL04QzUW2dApqTQldnf7o0=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=VtnzKg2w9GSsbCCOhG+xdUZ5LqmmAU8idYgs8XfwtTJzRMcrRa3GvCP3VhCO7gdr9
         DwAaaHLH276U4IMUqX2bqPpTcQ5Op3xShCzyxC1sekkKk2oCgs0KvZAskvugKCgDSr
         kAfVKJYMnGxevtpVy7vRb6MVM6MJv07tw0POVEwg=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8731B6034D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtlwifi: btcoex: remove unused function
 exhalbtc_stack_operation_notify
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190525144844.16976-1-yuehaibing@huawei.com>
References: <20190525144844.16976-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <pkshih@realtek.com>, <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190528123827.729F16070D@smtp.codeaurora.org>
Date:   Tue, 28 May 2019 12:38:27 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

YueHaibing <yuehaibing@huawei.com> wrote:

> There is no callers in tree, so can be removed.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Patch applied to wireless-drivers-next.git, thanks.

dfbe36197dbc rtlwifi: btcoex: remove unused function exhalbtc_stack_operation_notify

-- 
https://patchwork.kernel.org/patch/10960845/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

