Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDF40474B28
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 19:47:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237146AbhLNSrC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 13:47:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbhLNSrB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 13:47:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F8C0C061574;
        Tue, 14 Dec 2021 10:47:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 19972B815B1;
        Tue, 14 Dec 2021 18:47:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD961C34600;
        Tue, 14 Dec 2021 18:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639507618;
        bh=/y3URU3ybZOaTzxWnYgazuNBxRzpiZ2eNPGd/nyB0WI=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=uXVweL9DJp2lNyMuvQRCujUU339aMCzMgkh9r3mgfvI4CKxw69epupNIlkrMlAy6/
         OIr5PbINXlzb0CFCmP0mY2cy9x+2KWi3EZAk1t80h7SArYPX1/QitRFEeOG/qbUph2
         fpC/oiS+VN3/66d0ARK3KxQ9buk+0WmxrZ1V5u5Ita1iDfVr9bAynl3mAYpdoU+HlN
         ZGXDWJKGrH7JihgCldik49T4bGYJ+liRZ+VKMW4rl0MXNYSLeFWRNckF6BCqtKiZnD
         3tIrUW5aRonCJdDUDRo2yKOp7hQjbf0O+YySq2HxAzcwfkNwuwslQGwZFswv6JrSBY
         HxzHfOvGJvg3g==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/4] wilc1000: Rename SPI driver from "WILC_SPI" to
 "wilc1000_spi"
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20211209044411.3482259-2-davidm@egauge.net>
References: <20211209044411.3482259-2-davidm@egauge.net>
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
Message-ID: <163950761371.16030.5876652454276387048.kvalo@kernel.org>
Date:   Tue, 14 Dec 2021 18:46:56 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Mosberger-Tang <davidm@egauge.net> wrote:

> The name "wilc1000_spi" follows normal Linux conventions and also is
> analogous to the SDIO driver, which uses "wilc1000_sdio".
> 
> Signed-off-by: David Mosberger-Tang <davidm@egauge.net>

4 patches applied to wireless-drivers-next.git, thanks.

4347d34e6a76 wilc1000: Rename SPI driver from "WILC_SPI" to "wilc1000_spi"
30e08bc0a94c wilc1000: Rename irq handler from "WILC_IRQ" to netdev name
3cc23932ba2a wilc1000: Rename tx task from "K_TXQ_TASK" to NETDEV-tx
09ed8bfc5215 wilc1000: Rename workqueue from "WILC_wq" to "NETDEV-wq"

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20211209044411.3482259-2-davidm@egauge.net/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

