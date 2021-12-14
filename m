Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 087CA474B24
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 19:45:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234276AbhLNSpj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 13:45:39 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47518 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbhLNSpi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 13:45:38 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0627EB815AE;
        Tue, 14 Dec 2021 18:45:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1B0FC34600;
        Tue, 14 Dec 2021 18:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639507535;
        bh=ovqxrOFYWO5Mzd+9e/wEQv7xNWP82Hzz1BIXqnyZTQM=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=R2371Y6NFJns3Pl/xET1ts0oEbhgLjyY8634sxrU+UViSrRdLbdZLmnRohmvIYDh6
         4f2fvthJcS5q/j3DeIo5dXhc/nXTjbjp2tfw6voUun2kR/AB70m5A2Ms7PnUa61od3
         m0B39efzaYXljoPZOIEDeFEsl+ZD5Rt7Ns2S711oo3EOs98kkJRWsjXp1FzFbXrmD+
         BhUCalG+zR44fHVfBBRKObCoLZ3G0L8dxyrT7+kIPahm5hWTeuRteAt8OwLBDCtbHd
         PsrdfNU2c3ViWcknVorv3IVG8dENEFCdMUjztN6iP/7OJ5VzEd2EZUEsbNyq28Sez2
         bXS9tZk5xwpkw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wilc1000: Fix spurious "FW not responding" error
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20211208062747.3405221-1-davidm@egauge.net>
References: <20211208062747.3405221-1-davidm@egauge.net>
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
Message-ID: <163950753207.16030.1779636824058150904.kvalo@kernel.org>
Date:   Tue, 14 Dec 2021 18:45:33 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Mosberger-Tang <davidm@egauge.net> wrote:

> When deinitializing the driver, one or more "FW not responding" error
> appears on the console.  This appears to be due to wilc_wlan_stop()
> disabling host/WILC1000 communication, but then right afterwards, it
> tries to release the bus with chip-sleep enabled.  The problem is
> enabling the chip-sleep cannot success once host/WILC1000
> communication is disabled.  Fix by only releasing the bus.
> 
> Signed-off-by: David Mosberger-Tang <davidm@egauge.net>

Patch applied to wireless-drivers-next.git, thanks.

73bbef64bca7 wilc1000: Fix spurious "FW not responding" error

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20211208062747.3405221-1-davidm@egauge.net/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

