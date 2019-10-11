Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E83E0D3F17
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 13:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727896AbfJKL5d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 07:57:33 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:37928 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727198AbfJKL5d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 07:57:33 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 173FC60ADE; Fri, 11 Oct 2019 11:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570795052;
        bh=EPYe5kTBBGci2tg48EPs5GLHdxzLBPQNaqpnWCbvN0A=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=dcyAOLXlc63HacOqTCRkTOezC44jm2EsyeUorxd4Y2Czh0nylMKLnukFv2yIPyDC6
         gSEkVyhOQ9ZCuAADkDBMe2oepgpoWIS6GeGE5xrcy8lb2+J7dP2OL3jy6rJbjCP01C
         +IHbZyPOYgUzaj0GS9Nt+pRHzcpRXpJGfgV2qm1w=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B19BB602EE;
        Fri, 11 Oct 2019 11:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570795051;
        bh=EPYe5kTBBGci2tg48EPs5GLHdxzLBPQNaqpnWCbvN0A=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=eCT6yiCW4z23JIr4WE8iA1QhYZu/HoLLv/OdH8G5QEa5TVLcY4VigfBIS5uGhmp5d
         ds0tQP+w3Vc91Niy04tYYt51RBcWIsQeY182WQVCX9JPWZIQEo5T4etyqE2VxVguwl
         07Ii9gVVw/vvgqEa50iIDZK8TnIqgB7yHP0PYHaI=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B19BB602EE
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: Correct error check of dma_map_single()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20191010162653.141303-1-bjorn.andersson@linaro.org>
References: <20191010162653.141303-1-bjorn.andersson@linaro.org>
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Niklas Cassel <niklas.cassel@linaro.org>,
        stable@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191011115732.173FC60ADE@smtp.codeaurora.org>
Date:   Fri, 11 Oct 2019 11:57:32 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bjorn Andersson <bjorn.andersson@linaro.org> wrote:

> The return value of dma_map_single() should be checked for errors using
> dma_mapping_error(), rather than testing for NULL. Correct this.
> 
> Fixes: 1807da49733e ("ath10k: wmi: add management tx by reference support over wmi")
> Cc: stable@vger.kernel.org
> Reported-by: Niklas Cassel <niklas.cassel@linaro.org>
> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>

Did this fix any real bug? Or is this just something found during code review?

-- 
https://patchwork.kernel.org/patch/11183923/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

