Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A839748BFAF
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 09:17:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345499AbiALIRE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 03:17:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345740AbiALIRB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 03:17:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 507A9C06173F;
        Wed, 12 Jan 2022 00:17:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 19C50B81E14;
        Wed, 12 Jan 2022 08:17:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E673BC36AE9;
        Wed, 12 Jan 2022 08:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641975418;
        bh=n+MH7GlgxkHJXeKYXA60ySlv1AERDvP9u/5W7iSlzM8=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=KXWeXi1NXCXGNmMuf/e6kVBYORxLtBzG0CVD26dgnMCZ3m+BLvGKXtzBebTbMoowd
         V7QBxE8R8ittZThtWz86nSSKXPRR9TdN3tLR3xhOa+U28gDehYPyJYUSv0v676qu1r
         lMs2gwydkytv0btYh+wrfvaDABSkrgB+eakGOAkoVY+DWG+V/wgLas7rO9y6mcFXFv
         tyZGsQ0VngpIn+fJHzx72kmXOJED7+0AObTQfhgg2mp4kTLQU+VzRpxiyM1ex19foZ
         FZdAFcBASWUbXTqx2ifnR+giriVez+VwqSaGVy9fmBHuRdVdPMWoAmzbioxw6VUpqz
         E8jdgpHkYAX+g==
From:   Kalle Valo <kvalo@kernel.org>
To:     cgel.zte@gmail.com
Cc:     ath9k-devel@qca.qualcomm.com, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH] wireless/ath/ath9k: remove redundant status variable
References: <20220112080751.667316-1-chi.minghao@zte.com.cn>
Date:   Wed, 12 Jan 2022 10:16:54 +0200
In-Reply-To: <20220112080751.667316-1-chi.minghao@zte.com.cn> (cgel zte's
        message of "Wed, 12 Jan 2022 08:07:51 +0000")
Message-ID: <87o84htll5.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

cgel.zte@gmail.com writes:

> From: Minghao Chi <chi.minghao@zte.com.cn>
>
> Return value directly instead of taking this in another redundant
> variable.
>
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
> Signed-off-by: CGEL ZTE <cgel.zte@gmail.com>
> ---
>  drivers/net/wireless/ath/ath9k/eeprom.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)

The subject prefix should be "ath9k:", I can fix that.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
