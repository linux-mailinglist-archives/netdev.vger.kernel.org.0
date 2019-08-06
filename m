Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C9138318F
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 14:41:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731142AbfHFMlW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 08:41:22 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:34380 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726036AbfHFMlV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 08:41:21 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id B1BF7608CE; Tue,  6 Aug 2019 12:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1565095280;
        bh=fgx4S3VsNeqoBxzMBueE0V0h8oVwiKEK6AqHo9b4zo4=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=LDELQCSF07ezwfSJiYcrgCro16eVV5F0GKWXu6PsBIDVqqn72dzraspe+w49hIC5/
         0qdHR6mzQxK4LgyMsnZWirKhc7nH3ckHjxn/8RnL2ncLYzXYq2fKCLL8/Ahwh+qAsN
         2OGqDzFSrecnL+z89KkSE3WNY78ED1M0WWOhi3eI=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3B1C16038E;
        Tue,  6 Aug 2019 12:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1565095280;
        bh=fgx4S3VsNeqoBxzMBueE0V0h8oVwiKEK6AqHo9b4zo4=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=Qz+p71eeoK4FFC3HLr4FrwVSR66Y7U8HR3j+ZDePZPY99Nq96c1xtTeKfIO9FZtqf
         dLU1DPrBBFxZc8JUcjk/XPybUyXQdsRt9WRKl4RT/ToJLT3blYIKuNEN7UfuHISjFd
         rUDJEiErVgSwaMjmkNNc4iSKO0Z0f3JsJt1H3n20=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3B1C16038E
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rsi: return explicit error values
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1564413872-10720-1-git-send-email-info@metux.net>
References: <1564413872-10720-1-git-send-email-info@metux.net>
To:     "Enrico Weigelt, metux IT consult" <info@metux.net>
Cc:     linux-kernel@vger.kernel.org, amitkarwar@gmail.com,
        siva8118@gmail.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190806124120.B1BF7608CE@smtp.codeaurora.org>
Date:   Tue,  6 Aug 2019 12:41:20 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Enrico Weigelt, metux IT consult" <info@metux.net> wrote:

> From: Enrico Weigelt <info@metux.net>
> 
> Explicitly return constants instead of variable (and rely on
> it to be explicitly initialized), if the value is supposed
> to be fixed anyways. Align it with the rest of the driver,
> which does it the same way.
> 
> Signed-off-by: Enrico Weigelt <info@metux.net>

Patch applied to wireless-drivers-next.git, thanks.

706f0182b1ad rt2800usb: Add new rt2800usb device PLANEX GW-USMicroN

-- 
https://patchwork.kernel.org/patch/11064039/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

