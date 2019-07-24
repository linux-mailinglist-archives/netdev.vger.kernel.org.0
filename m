Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA88F72E1A
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 13:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727892AbfGXLsn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 07:48:43 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:50762 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727570AbfGXLsn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 07:48:43 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id B38EA6055D; Wed, 24 Jul 2019 11:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1563968922;
        bh=jGsDu6EdcDY+L7ebpYITW9KbFRL/IJcnIJdP4CbFErg=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=XDMB8/47Cvw1uckrl+Ffshk9l4Dmw9eg5LUVdGaw85FsqNGe+LFsQ14VxQpaA8Hpq
         O5/FU+raj5gMqkNIVy43BBD3eYFaLYOdxG3Z08QctGrSTM067O8IojM3BAzq/+hVrX
         zfevYVfpvwA8kxaEKpSptWboUg+Qbw51IQqPua2M=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B7CC56055D;
        Wed, 24 Jul 2019 11:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1563968919;
        bh=jGsDu6EdcDY+L7ebpYITW9KbFRL/IJcnIJdP4CbFErg=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=WSJQF8WB+r913z10WNKs6zMvcopdd43IQPQ8Nuh8QwyrM//Lo5IYiVneGBJGlFqtv
         7n6yiCnIbJBixkfCnThkV/1dE8g8RdLtP1mcHj6RqM+8Ncnfd4jondFqtn/C+j7vfT
         owajRdp31lBBjscOsmO+zSK95PHnAYKGh2mrXB6E=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B7CC56055D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 09/12] rtw88: Fix misuse of GENMASK macro
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <0de52d891d7925b02f4f0fe2c750d076e55434d9.1562734889.git.joe@perches.com>
References: <0de52d891d7925b02f4f0fe2c750d076e55434d9.1562734889.git.joe@perches.com>
To:     Joe Perches <joe@perches.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190724114841.B38EA6055D@smtp.codeaurora.org>
Date:   Wed, 24 Jul 2019 11:48:40 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Joe Perches <joe@perches.com> wrote:

> Arguments are supposed to be ordered high then low.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> Acked-by: Yan-Hsuan Chuang <yhchuang@realtek.com>

Patch applied to wireless-drivers-next.git, thanks.

5ff29d836d1b rtw88: Fix misuse of GENMASK macro

-- 
https://patchwork.kernel.org/patch/11037805/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

