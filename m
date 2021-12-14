Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43D1B474B21
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 19:45:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237141AbhLNSo5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 13:44:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231756AbhLNSo4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 13:44:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC7CEC061574;
        Tue, 14 Dec 2021 10:44:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 94BA2B81212;
        Tue, 14 Dec 2021 18:44:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23500C34604;
        Tue, 14 Dec 2021 18:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639507493;
        bh=eMz9Iy3nzlmmh4TRRgI9bv4NJObcqSAkTmHiRf6Ubnc=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=VW4DXBeo5cLk21kzn5cmQifjKS6U+Z/egMMlo/Ln2w0sshfuZGGgAhGp86jO+YVtQ
         SrEz/J8P5dPH3qPKcClX7oJIACk3aUz5hCNOuLXMKfT6jgxTtU8IzaHtZE105s5aKa
         dgI0MU9pK7+IWNTHroxyplzpck4Y23yPsaf7OHJMsd6xUDFW+Dd34vNqYcLS0O9mTC
         HNz6RVFkcGjLK6tneFYjunAyE7h6ywF+Z6cs1ctFGNRl5F7x8DBFj+BpiQNYS/zjeH
         W03vCxzmfjn0iDkk3433deTOvm0DCaYWTDUg+JMRyDrfMu4Nve30/+CQhnyw98AmLk
         8AEzjJojL798A==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wilc1000: Remove misleading USE_SPI_DMA macro
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20211207002453.3193737-1-davidm@egauge.net>
References: <20211207002453.3193737-1-davidm@egauge.net>
To:     David Mosberger-Tang <davidm@egauge.net>
Cc:     Ajay Singh <ajay.kathat@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        David Mosberger-Tang <davidm@egauge.net>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <163950748948.16030.12912996854726800768.kvalo@kernel.org>
Date:   Tue, 14 Dec 2021 18:44:50 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Mosberger-Tang <davidm@egauge.net> wrote:

> The USE_SPI_DMA macro name suggests that it could be set to 1 to
> control whether or not SPI DMA should be used.  However, that's not
> what it does.  If set to 1, it'll set the SPI messages'
> "is_dma_mapped" flag to true, even though the tx/rx buffers aren't
> actually DMA mapped by the driver.  In other words, setting this flag
> to 1 will break the driver.
> 
> Best to clean up this confusion by removing the macro altogether.
> There is no need to explicitly initialize "is_dma_mapped" because the
> message is cleared to zero anyhow, so "is_dma_mapped" is set to false
> by default.
> 
> Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
> Acked-by: Ajay Singh <ajay.kathat@microchip.com>

Patch applied to wireless-drivers-next.git, thanks.

dde02213fa64 wilc1000: Remove misleading USE_SPI_DMA macro

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20211207002453.3193737-1-davidm@egauge.net/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

