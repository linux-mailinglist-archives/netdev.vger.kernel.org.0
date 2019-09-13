Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19A08B2131
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 15:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389040AbfIMNi1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 09:38:27 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:57298 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387584AbfIMNi1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 09:38:27 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 187CC601C3; Fri, 13 Sep 2019 13:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1568381906;
        bh=8zCYlualNWwt8I4c0YzwmA3bS57xaqFYOUXdN0Z2JY8=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=otIhPvmT/CkIKYRegdd5jQHFa6MtrIpYXst0vtL8caJ8tl2GNAfl6UGWrI5blJOqi
         SMogT/zqPxH97TaYUD6HuRVi0Kld9ih52VqOCTex2abccfbjQggj/Nw00NAY/mhEgF
         vIhaWud1ZvfUhceWonA9DA1JJ8vSaOSxbfkCRSRY=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3D3546013C;
        Fri, 13 Sep 2019 13:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1568381905;
        bh=8zCYlualNWwt8I4c0YzwmA3bS57xaqFYOUXdN0Z2JY8=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=dFp1w25QSplRRswg7lguMThAJPTGvpfoErkH/2cdLU83vXGNRW6/kd2aLzeBKwjSQ
         FlC/Fz7GBQYn4RMC/70HGlds8kg5KrY8FKqw8oaFd52wGDiguiSLoNWjCK1m4+Vsp8
         wPJQ85BX4TPmOtjTnPoxRFUNSktauNwAVZiuuyXE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3D3546013C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 3/3] libertas: Remove unneeded variable and make function
 to be void
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1568306492-42998-4-git-send-email-zhongjiang@huawei.com>
References: <1568306492-42998-4-git-send-email-zhongjiang@huawei.com>
To:     zhong jiang <zhongjiang@huawei.com>
Cc:     <davem@davemloft.net>, <zhongjiang@huawei.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190913133826.187CC601C3@smtp.codeaurora.org>
Date:   Fri, 13 Sep 2019 13:38:26 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

zhong jiang <zhongjiang@huawei.com> wrote:

> lbs_process_event  do not need return value to cope with different
> cases. And change functon return type to void.
> 
> Signed-off-by: zhong jiang <zhongjiang@huawei.com>

Same here, I just don't see the benefit.

Patch set to Rejected.

-- 
https://patchwork.kernel.org/patch/11143397/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

