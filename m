Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 794ABB501B
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 16:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727495AbfIQONY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 10:13:24 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:52182 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727091AbfIQONY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Sep 2019 10:13:24 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id B2985614C3; Tue, 17 Sep 2019 14:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1568729603;
        bh=nygaNAFH+ev6zR6raMph5QsZh51rzlyXoTBYZ7ezi0s=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=TyxHS84J0LVs6uKu2x/96A1NBbOHucFy9z1MEbZVgEtufLEH+/klGZcqu3cEEmlKL
         prXwZzdp/5AOPuhodA1Z3BfWWiQZGf03pTNlk9E5s/TgRJNNA8D5vhhXfMN40yav4Z
         RkshsVCgMLPTk2onBf4LylmvuL1ljq2lvyfGbHOQ=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2B967611BF;
        Tue, 17 Sep 2019 14:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1568729601;
        bh=nygaNAFH+ev6zR6raMph5QsZh51rzlyXoTBYZ7ezi0s=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=U1nFWR9dKL+uNg7wiQvjjSsNeTauoJmAjipVIVyLb80hSh1/BUoqprh9EWldEZH2x
         WUu8uz67T0ldqKkNz805djBC5JidEa5jktVdIOvCioWIUpoIKJjK8dUGExQZcAwMC+
         Y+tLHbqzsAiBC4/bBBNpgNi8Eqmm+5dNfJQF+Dog=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2B967611BF
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: fix spelling mistake "eanble" -> "enable"
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190913074339.27280-1-colin.king@canonical.com>
References: <20190913074339.27280-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190917141322.B2985614C3@smtp.codeaurora.org>
Date:   Tue, 17 Sep 2019 14:13:22 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin King <colin.king@canonical.com> wrote:

> There is a spelling mistake in a ath10k_warn warning message. Fix it.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

09764659003d ath10k: fix spelling mistake "eanble" -> "enable"

-- 
https://patchwork.kernel.org/patch/11144035/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

