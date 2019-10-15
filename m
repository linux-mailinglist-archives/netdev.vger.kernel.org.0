Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35E9AD6E86
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 07:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728254AbfJOFVY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 01:21:24 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:49296 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728152AbfJOFVX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 01:21:23 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 0040460A08; Tue, 15 Oct 2019 05:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571116883;
        bh=I9WghGtYVeVXJlrf61PEkCMhAN/CWWt9s6E+2MBmULs=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=hVK+F4j87QFPu8H0DZGTPMxOIoi/Pgr5d+Mn0NCwieNYN1K7Uv72nxfTRqWS/uGn2
         LadqbYPRTwrpLMSGeZHpT04abyU6lFTGDhlazzfSe6Ol1JWIqW7aODf374IQ5XjCT/
         Qx2Y8/MVzaa0P8KkM0iNQwt7a4u13JaqaKf5JMBw=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5D5BE60A08;
        Tue, 15 Oct 2019 05:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571116882;
        bh=I9WghGtYVeVXJlrf61PEkCMhAN/CWWt9s6E+2MBmULs=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=NnBS+7x4cXUBpHYlGfS2P9pXG0hRUwGdykafpD6XvkHSi6ZHk6Q5HEgtpQlPoNISP
         aNXuk0+bDPWjjMTMjqPcLketao2JjtarTtgLPEgooWF+xnYw2z4vdkhZL/2/QPRc2I
         e2Uvtqr11xwD/Wz+ObDG7J7LqU0OdjuQLAAMsqF4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5D5BE60A08
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 20/24] wireless: Remove call to memset after
 dma_alloc_coherent
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190715031941.7120-1-huangfq.daxian@gmail.com>
References: <20190715031941.7120-1-huangfq.daxian@gmail.com>
To:     Fuqian Huang <huangfq.daxian@gmail.com>
Cc:     unlisted-recipients:; (no To-header on input)
        "David S . Miller" <davem@davemloft.net>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Igor Mitsyanko <imitsyanko@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        Fuqian Huang <huangfq.daxian@gmail.com>
Illegal-Object: Syntax error in Cc: address found on vger.kernel.org:
        Cc:     unlisted-recipients:; (no To-header on input)"David S . Miller" <davem@davemloft.net>
                                                                     ^-missing end of address
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191015052123.0040460A08@smtp.codeaurora.org>
Date:   Tue, 15 Oct 2019 05:21:22 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fuqian Huang <huangfq.daxian@gmail.com> wrote:

> In commit 518a2f1925c3
> ("dma-mapping: zero memory returned from dma_alloc_*"),
> dma_alloc_coherent has already zeroed the memory.
> So memset is not needed.
> 
> Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

52d4261862ec wireless: Remove call to memset after dma_alloc_coherent

-- 
https://patchwork.kernel.org/patch/11043359/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

