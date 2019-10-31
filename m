Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7CCAEAB4F
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 09:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726922AbfJaIHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 04:07:51 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:42824 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726776AbfJaIHv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 04:07:51 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 38A6B609CA; Thu, 31 Oct 2019 08:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572509270;
        bh=tecBCzRev0wId8FRA31CVuEhKSpiMtEzf7LYR2PrivA=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=GK6kx2SHv8lW4sShv24hmEqjrZWflLcUBPukwIvrgM4euUyzZ5IxT4Fa2e6Icdv7l
         1QdpLkEk9wssuZ1S2puZcoJ0CGROLFpne+M8JIOLSiyYPeRZJkfmhDGTxyDQ20+7Q9
         evvzhpEO6uSKagA7iaVypoRFF64BLDZI/S1qXMzM=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D6A54609CA;
        Thu, 31 Oct 2019 08:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572509269;
        bh=tecBCzRev0wId8FRA31CVuEhKSpiMtEzf7LYR2PrivA=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=MhspxZ3NdajuTh7idtQvFjVoF+7V+ZqmvfCc8vkBhh/w+UzmPU6Xr1H3MZCXxHtro
         nTA1FBkaJ6XvO/L1Xa4TZQlrH7gT7xvTXiOqAEOBq7FJxhbhAfldF5obGTdEsRYtim
         ttP6HhLEJTKFvqdoc9k/zxoGSay+D/TIvhDzchKs=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D6A54609CA
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] b43: main: Fix use true/false for bool type
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20191028190204.GA27248@saurav>
References: <20191028190204.GA27248@saurav>
To:     Saurav Girepunje <saurav.girepunje@gmail.com>
Cc:     davem@davemloft.net, swinslow@gmail.com, will@kernel.org,
        opensource@jilayne.com, saurav.girepunje@gmail.com,
        baijiaju1990@gmail.com, tglx@linutronix.de,
        linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        saurav.girepunje@hotmail.com
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191031080750.38A6B609CA@smtp.codeaurora.org>
Date:   Thu, 31 Oct 2019 08:07:50 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Saurav Girepunje <saurav.girepunje@gmail.com> wrote:

> use true/false on bool type variable assignment.
> 
> Signed-off-by: Saurav Girepunje <saurav.girepunje@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

6db774c17250 b43: main: Fix use true/false for bool type

-- 
https://patchwork.kernel.org/patch/11216303/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

