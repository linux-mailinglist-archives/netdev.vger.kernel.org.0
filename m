Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B826247B389
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 20:13:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240570AbhLTTNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 14:13:40 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:36322 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234420AbhLTTNk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 14:13:40 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9DD8B8108B;
        Mon, 20 Dec 2021 19:13:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EA75C36AE7;
        Mon, 20 Dec 2021 19:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640027617;
        bh=EndenUleLx912elQEAFNcLtwinpgdbihZMGxoV4946c=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=XyRWTZXIGt5vp6SSo6un1R2GXoFSUGbPOBVkA2i1CuMZat7FSTKFQScMBIXGltC7R
         1kzi8RJf3C4M4goBsd/Y3+tdnoJSQOOCuA4dI2393ZoEschCuXp8UUiTd/PjyvRbSR
         MXe0gJ+MS8ik9cTRl3rtbnr5werdQIekn3uM3Kws7fpBsbM2C5BIven/3CLZhdimfs
         BbvDSZaw1XRkmRpA+AKvKzmJI1zLjb7kcDE7YJZvSmkkzGQAiafrQBtUUAnM/FPdVn
         +IBMBc0I10rxUDlkjffCXatRoUtO80KQHNo7slLVZo9J55rzaBQdshK0GMloNs2Xbs
         XTrSRm4Jz+dUg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 2/2] wireless: Initial driver submission for pureLiFi STA
 devices
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20211031131122.275386-3-srini.raju@purelifi.com>
References: <20211031131122.275386-3-srini.raju@purelifi.com>
To:     Srinivasan Raju <srini.raju@purelifi.com>
Cc:     mostafa.afgani@purelifi.com,
        Srinivasan Raju <srini.raju@purelifi.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org (open list),
        linux-wireless@vger.kernel.org (open list:NETWORKING DRIVERS (WIRELESS)),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS)
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164002761326.16553.16032698017276446966.kvalo@kernel.org>
Date:   Mon, 20 Dec 2021 19:13:35 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Srinivasan Raju <srini.raju@purelifi.com> wrote:

> This driver implementation has been based on the zd1211rw driver
> 
> Driver is based on 802.11 softMAC Architecture and uses
> native 802.11 for configuration and management
> 
> The driver is compiled and tested in ARM, x86 architectures and
> compiled in powerpc architecture
> 
> Signed-off-by: Srinivasan Raju <srini.raju@purelifi.com>

I pushed this to the pending branch for build testing:

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git/commit/?h=pending&id=9d71991ef3e8e4c2e49063c8fee446b9d20f4c7d

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20211031131122.275386-3-srini.raju@purelifi.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

