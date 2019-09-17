Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DC2CB5000
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 16:09:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727172AbfIQOJc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 10:09:32 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:49054 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726545AbfIQOJb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Sep 2019 10:09:31 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 11D9260790; Tue, 17 Sep 2019 14:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1568729370;
        bh=gBMlUc2ziFwwtkVc/AsmGn1pJDa0q/Stf70aBdLPBd0=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=ENoPz9V/EUR9xMEjpu5jhWFcAZGMhHzu3OF6NNmlH5IGWVOIneDSHxmwDdjvMJaG/
         2I8SdG6j/A/b5QMFo3OeY9k3JwNIsMtf38s8oFO0fEVbRo+iqJBXsDvpT+eTk9sWhM
         AznzzYSSwMCudu+CL1F0g444vWBAnYJncH7u9mX0=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6339E60790;
        Tue, 17 Sep 2019 14:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1568729369;
        bh=gBMlUc2ziFwwtkVc/AsmGn1pJDa0q/Stf70aBdLPBd0=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=nkafxI/YQMTakw7G3IJW0qA5pVwufvAyGJj3sqmfN3g0p9mNpKnCaX+sQJOpBxCHh
         fuG7TZCBTTjEY7XUxjGU3d6l4w3ZP9/IaBK6OafIqSRKQ+FdULbcLDB3i7HDuYh+GV
         oEZpN6arv8Zy23eEAQvZk7Pi1FA16FBEDVmc9s3I=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6339E60790
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: Use ARRAY_SIZE
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190718203032.15528-1-gomonovych@gmail.com>
References: <20190718203032.15528-1-gomonovych@gmail.com>
To:     Vasyl Gomonovych <gomonovych@gmail.com>
Cc:     davem@davemloft.net, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org,
        Vasyl Gomonovych <gomonovych@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190917140930.11D9260790@smtp.codeaurora.org>
Date:   Tue, 17 Sep 2019 14:09:29 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vasyl Gomonovych <gomonovych@gmail.com> wrote:

> fix coccinelle warning, use ARRAY_SIZE
> 
> Signed-off-by: Vasyl Gomonovych <gomonovych@gmail.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

7921ae091907 ath10k: Use ARRAY_SIZE

-- 
https://patchwork.kernel.org/patch/11049553/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

