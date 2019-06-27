Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BCFF581B8
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 13:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbfF0LiS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 07:38:18 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:41828 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726375AbfF0LiS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 07:38:18 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 8D32E6085C; Thu, 27 Jun 2019 11:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1561635497;
        bh=4hOE5ZThruSSEEWDMxq0Dt5OhPpzapnURhse53Dk5WQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=lwil+HeSAfxdGvKxmoaw6YeXNX2Q6NsLoqoEDS2MzGNzNbTjbxtsj5ZSKe071yz8+
         hyf1zP2isDURMIa6B6KhpnJdWBdqoJI5vJYGkmrDnNZvBXxn9Xq90CG+oNS+NLgya4
         IM0mZAdpURaPL2Vh6j2KJaA1mMAVEpRmnxmRFGOY=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8D560602F8;
        Thu, 27 Jun 2019 11:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1561635496;
        bh=4hOE5ZThruSSEEWDMxq0Dt5OhPpzapnURhse53Dk5WQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=nbJM51t6Tkkmm0S+B5u4FYHEfiaoABBMPuYY4uR2R7uqpVDXOdrr0Tp50RYv1K9Wq
         W6QKiDH7waGw/3JhH8TaOkNXVPzfTHhAguI8BNznqvS6DAox6ihC4kcqsg0mz2VDfM
         a2a1iDrEdiP3KKigYv8nZO561Vzt7TWeF0LrkYHE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8D560602F8
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/4] b43legacy: remove b43legacy_dma_set_mask
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190625102932.32257-2-hch@lst.de>
References: <20190625102932.32257-2-hch@lst.de>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Larry Finger <Larry.Finger@lwfinger.net>,
        b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190627113817.8D32E6085C@smtp.codeaurora.org>
Date:   Thu, 27 Jun 2019 11:38:17 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christoph Hellwig <hch@lst.de> wrote:

> These days drivers are not required to fallback to smaller DMA masks,
> but can just set the largest mask they support, removing the need for
> this trial and error logic.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Tested-by: Larry Finger <Larry.Finger@lwfinger.net>

4 patches applied to wireless-drivers-next.git, thanks.

258989000849 b43legacy: remove b43legacy_dma_set_mask
80372782e4cb b43legacy: simplify engine type / DMA mask selection
c897523febae b43: remove b43_dma_set_mask
288aa4ee7acf b43: simplify engine type / DMA mask selection

-- 
https://patchwork.kernel.org/patch/11015245/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

