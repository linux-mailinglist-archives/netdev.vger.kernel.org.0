Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 436AE474B1B
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 19:43:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237124AbhLNSnW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 13:43:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231756AbhLNSnW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 13:43:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFE17C061574;
        Tue, 14 Dec 2021 10:43:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 859A6B81667;
        Tue, 14 Dec 2021 18:43:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33EFAC34600;
        Tue, 14 Dec 2021 18:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639507399;
        bh=4/c30TeGsRt1sdafdllfkIcLMtvejPrg+IRiDVok5js=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=JoK5wUvJ4fprKjnAEEjFdxtRxak66ZIkEhOGY/FT0h8PRqXOaX9/QpYNSp2tkiPWX
         M2kT9Sn3jMe6FaFZG1FwQQ2Fz6QQtzzq0U/Ne1x6EibJFuErgaW1FVTIAd8jrquSTI
         6A8eMNP6y56fiFumj1pliBjcfuLLXBP5f80HpjCZvzA/kkLzNtaNjwJbjHP/MYoACq
         90SSU4B9jjv5QeBsOZ28BNEGF5Wrabpo8nLC0f1Qmisi7w2P555HBcb1RNFDxGLg+0
         x2mbCyO0Lw2kLPb4k12zlmyx7z1xE+K1rIHshmIMpQ9vM7L+KqH/LTaRMevefLYVLI
         eRsUV1Y2wj6cQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/2] wilc1000: Fix copy-and-paste typo in
 wilc_set_mac_address
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20211206232709.3192856-2-davidm@egauge.net>
References: <20211206232709.3192856-2-davidm@egauge.net>
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
Message-ID: <163950739524.16030.13578810412841462678.kvalo@kernel.org>
Date:   Tue, 14 Dec 2021 18:43:17 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Mosberger-Tang <davidm@egauge.net> wrote:

> The messages appears to have been copied from wilc_get_mac_address and
> says "get" when it should say "set".
> 
> Signed-off-by: David Mosberger-Tang <davidm@egauge.net>

2 patches applied to wireless-drivers-next.git, thanks.

f92b9f967463 wilc1000: Fix copy-and-paste typo in wilc_set_mac_address
5ae660641db8 wilc1000: Fix missing newline in error message

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20211206232709.3192856-2-davidm@egauge.net/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

