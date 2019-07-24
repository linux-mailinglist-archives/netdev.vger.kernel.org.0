Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2383A72E37
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 13:53:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727942AbfGXLw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 07:52:57 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:53196 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727453AbfGXLw5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 07:52:57 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 26C516053D; Wed, 24 Jul 2019 11:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1563969176;
        bh=UvvwSI4TZC8H4KA2TzQnIlCHIKjrbu/I6okunv1xr64=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=W63iyFKewHRGNxjtMVs/os01jFPH9YjsktdC43OfoEy1NQA75M/hQ/M04UegO6Iz7
         8nxJ8T6jyoFGb2fX9VMsEHoBt05BBxbbbCmUtY9Et6qzcfz6p5va6YWePxLKkT4Wec
         O7reSqnvhXe9z0pu25lUiCnz76/6zV90SoVtK8Bk=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3735A60214;
        Wed, 24 Jul 2019 11:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1563969175;
        bh=UvvwSI4TZC8H4KA2TzQnIlCHIKjrbu/I6okunv1xr64=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=NICTwjL/LD2KsnYZWDom16+DTY290VGBGmN6OJqszuW+dyhu+hBQeGJalsYz6QOWO
         4OPPRtWBbv0W4k3QA6JhNLdRcnVMJi7sKjhJstszHz4jcwrM57AxJcbwU+bzj5rfM8
         DNwwVDUJMphYj7X72WXSsyHQdL64xRD9gNlZVRTA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3735A60214
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtlwifi: btcoex: fix issue possible condition with no
 effect (if == else)
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190712191535.GA4215@hari-Inspiron-1545>
References: <20190712191535.GA4215@hari-Inspiron-1545>
To:     Hariprasad Kelam <hariprasad.kelam@gmail.com>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        YueHaibing <yuehaibing@huawei.com>,
        Hariprasad Kelam <hariprasad.kelam@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Nathan Chancellor <natechancellor@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190724115256.26C516053D@smtp.codeaurora.org>
Date:   Wed, 24 Jul 2019 11:52:56 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hariprasad Kelam <hariprasad.kelam@gmail.com> wrote:

> fix below issue reported by coccicheck
> drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c:514:1-3:
> WARNING: possible condition with no effect (if == else)
> 
> Signed-off-by: Hariprasad Kelam <hariprasad.kelam@gmail.com>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

Patch applied to wireless-drivers-next.git, thanks.

9a29f7d8476c rtlwifi: btcoex: fix issue possible condition with no effect (if == else)

-- 
https://patchwork.kernel.org/patch/11042665/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

