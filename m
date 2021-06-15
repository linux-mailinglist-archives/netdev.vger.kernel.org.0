Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20EDC3A80E7
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 15:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231716AbhFONms (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 09:42:48 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:19245 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231661AbhFONm2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 09:42:28 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1623764423; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=a1WlzaO82iLMRE52JxldZdL+R8HjpJo5eZ9dZVqlH+E=;
 b=cnhx2AHuTObxhiHLMjy6XEyAXQLqb7jzWwHSQ9DVDtxo+b5qFxfvBdS+oZr3qjKqOikr+uXz
 VTEeTimtlzzpp3UTBhSZQH3MFOKgID05K0FOmKaGI0anIpBBAVE6nzBo2AlmYF7/TR0vV1OV
 4GSygjdw0z1Bw/tM9EMMTAsfq4c=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-east-1.postgun.com with SMTP id
 60c8adb7e27c0cc77f2475bf (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 15 Jun 2021 13:40:07
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 5EC85C43144; Tue, 15 Jun 2021 13:40:06 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL autolearn=no autolearn_force=no
        version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6BB2AC43460;
        Tue, 15 Jun 2021 13:40:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6BB2AC43460
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtlwifi: Remove redundant assignments to ul_enc_algo
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1621303199-1542-1-git-send-email-yang.lee@linux.alibaba.com>
References: <1621303199-1542-1-git-send-email-yang.lee@linux.alibaba.com>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     pkshih@realtek.com, davem@davemloft.net, kuba@kernel.org,
        nathan@kernel.org, ndesaulniers@google.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        Yang Li <yang.lee@linux.alibaba.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-Id: <20210615134006.5EC85C43144@smtp.codeaurora.org>
Date:   Tue, 15 Jun 2021 13:40:06 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yang Li <yang.lee@linux.alibaba.com> wrote:

> Variable ul_enc_algo is being initialized with a value that is never
> read, it is being set again in the following switch statements in
> all of the case and default paths. Hence the unitialization is
> redundant and can be removed.
> 
> Clean up clang warning:
> 
> drivers/net/wireless/realtek/rtlwifi/cam.c:170:6: warning: Value stored
> to 'ul_enc_algo' during its initialization is never read
> [clang-analyzer-deadcode.DeadStores]
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>

Patch applied to wireless-drivers-next.git, thanks.

a99086057e03 rtlwifi: Remove redundant assignments to ul_enc_algo

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/1621303199-1542-1-git-send-email-yang.lee@linux.alibaba.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

