Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F02CC47C605
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 19:12:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241021AbhLUSMP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 13:12:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233449AbhLUSMP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 13:12:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68479C061574;
        Tue, 21 Dec 2021 10:12:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 05A0861718;
        Tue, 21 Dec 2021 18:12:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4793DC36AE8;
        Tue, 21 Dec 2021 18:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640110334;
        bh=z1E1/wAJJGrH0x8EU8kQ64U1z7glpRBR+FXEjx7aNLA=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=VQ+rmdOvukFuL6yp+nAFR9p/t+aEhBBhUz+LBV4O/4TWR8XpUEvlJ1IHK5W0PE4eE
         9ynJ99JtByrYvuBEzHowiJ2nqzRpPjgOkTWdf/8bvl83/ev4Z54y36ecT3Zh3qJnS2
         xDodcCMgjSsBFjRzW9d2bIf5810Bp2e1d8VGv3fEJmj9yxKLheUplXUFYRw1F8bxig
         U8fUm0lGVIbAyoCrVS/lkw9M41h2Cul8wM1kn1q5HMt2Bc7HhmZFNPyCjl+IgmexEj
         iZ2sagGfZnqf+WQU1QdZFDO79akW5SoqSjgaR+t39Au7ISETq420X7E0s4wFbfQlzx
         hWT228FN+xlBg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wilc1000: Convert static "chipid" variable to
 device-local
 variable
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20211216032612.3798573-1-davidm@egauge.net>
References: <20211216032612.3798573-1-davidm@egauge.net>
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
Message-ID: <164011033066.7951.14633765796539711427.kvalo@kernel.org>
Date:   Tue, 21 Dec 2021 18:12:12 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Mosberger-Tang <davidm@egauge.net> wrote:

> Move "chipid" variable into the per-driver structure so the code
> doesn't break if more than one wilc1000 module is present.
> 
> Signed-off-by: David Mosberger-Tang <davidm@egauge.net>

Failed to apply, please rebase on top of wireless-drivers-next.

Recorded preimage for 'drivers/net/wireless/microchip/wilc1000/netdev.h'
error: Failed to merge in the changes.
hint: Use 'git am --show-current-patch' to see the failed patch
Applying: wilc1000: Convert static "chipid" variable to device-local variable
Using index info to reconstruct a base tree...
M	drivers/net/wireless/microchip/wilc1000/netdev.h
M	drivers/net/wireless/microchip/wilc1000/wlan.c
Falling back to patching base and 3-way merge...
Auto-merging drivers/net/wireless/microchip/wilc1000/wlan.c
Auto-merging drivers/net/wireless/microchip/wilc1000/netdev.h
CONFLICT (content): Merge conflict in drivers/net/wireless/microchip/wilc1000/netdev.h
Patch failed at 0001 wilc1000: Convert static "chipid" variable to device-local variable

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20211216032612.3798573-1-davidm@egauge.net/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

