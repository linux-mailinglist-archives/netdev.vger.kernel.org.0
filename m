Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E370B5010
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 16:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727394AbfIQOLj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 10:11:39 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:50526 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726307AbfIQOLj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Sep 2019 10:11:39 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 840AD61418; Tue, 17 Sep 2019 14:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1568729498;
        bh=Ib/FvgQ2ADDvprAwRsFZqAQkW3IWp5fSPoW7OmmKSnU=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=jD4E16+BkVqM5IcIZlvyCCN7ZNf07d2/5wCgyMthRAVjhsV2hCaihdV/snWPFRD4Q
         +smS/OF/mA5oL2JTyXAJ21334QjKuNqGUsRhAqx4d6fKwdyB3PFN6lC2l+OBl2jZlK
         7HZy/plHOMrrW5YwWPCdAmX74XrP4h7Ffak/X0c4=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 54BAE6133A;
        Tue, 17 Sep 2019 14:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1568729498;
        bh=Ib/FvgQ2ADDvprAwRsFZqAQkW3IWp5fSPoW7OmmKSnU=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=JhGTzmD9Ycd2rsNEvNriEf+tda2DZrO1vItX7RTj20lrjJ1mEhTjMRlRb9KmCvEwx
         Nk/X2iEucNcxMpDDj3ksuRJypTpr/zYR8TwxffkC4ogB4rqzVyFNafaI/NNLhsU53O
         5okBnKZ6j5/XQmXd5npqeLg3O9DNqbuVKXz+weSo=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 54BAE6133A
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: add cleanup in ath10k_sta_state()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1565903072-3948-1-git-send-email-wenwen@cs.uga.edu>
References: <1565903072-3948-1-git-send-email-wenwen@cs.uga.edu>
To:     Wenwen Wang <wenwen@cs.uga.edu>
Cc:     Wenwen Wang <wenwen@cs.uga.edu>,
        "David S. Miller" <davem@davemloft.net>,
        ath10k@lists.infradead.org (open list:QUALCOMM ATHEROS ATH10K WIRELESS
        DRIVER),
        linux-wireless@vger.kernel.org (open list:NETWORKING DRIVERS (WIRELESS)),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190917141138.840AD61418@smtp.codeaurora.org>
Date:   Tue, 17 Sep 2019 14:11:38 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wenwen Wang <wenwen@cs.uga.edu> wrote:

> If 'sta->tdls' is false, no cleanup is executed, leading to memory/resource
> leaks, e.g., 'arsta->tx_stats'. To fix this issue, perform cleanup before
> go to the 'exit' label.
> 
> Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

334f5b61a6f2 ath10k: add cleanup in ath10k_sta_state()

-- 
https://patchwork.kernel.org/patch/11096481/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

