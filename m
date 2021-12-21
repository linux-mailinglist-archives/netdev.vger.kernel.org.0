Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6EFD47C5FE
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 19:11:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241002AbhLUSLY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 13:11:24 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:40970 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233449AbhLUSLX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 13:11:23 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 588786171A;
        Tue, 21 Dec 2021 18:11:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7805C36AE9;
        Tue, 21 Dec 2021 18:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640110282;
        bh=7ezUXDCpzUX86IBuxs4d3ZAJp0n6hwwofR+D+8ceuW4=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=hucdRqR5W0X5UXLZbnLopw3wMx2rmIBkTz3XiMlHCvu+G5azjzhCB5lES3Ix0nqGK
         KMcbL5At6410aQEw4fCja1mAfNCsqsFo/KI8/LDRboQlIIECdXhOWshSJttNP1rimv
         1fWQln4hr1dZY2k6H6DuXDpJLH0LjXZHdNl43ttGbNvgSdWpJeRM3DWxryrLD0104j
         kfv73BFjCezBuYP09mHG6uZwm46/s/Oz5XiEWoermMcox5H0OTigfNUPf4+la7hZtd
         Rw5RUnZp9z8JYgE+j4ZqRVsz4iBW0qjbir/cl7DquxgqSNUuKn8P+CBDVFrqmx4HBr
         7kpX9Ony7OsZA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v6 1/2] wilc1000: Add reset/enable GPIO support to SPI
 driver
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20211220180334.3990693-2-davidm@egauge.net>
References: <20211220180334.3990693-2-davidm@egauge.net>
To:     David Mosberger-Tang <davidm@egauge.net>
Cc:     Ajay Singh <ajay.kathat@microchip.com>,
        Adham Abozaeid <adham.abozaeid@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        David Mosberger-Tang <davidm@egauge.net>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164011027826.7951.6332452994063982868.kvalo@kernel.org>
Date:   Tue, 21 Dec 2021 18:11:19 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Mosberger-Tang <davidm@egauge.net> wrote:

> For the SDIO driver, the RESET/ENABLE pins of WILC1000 are controlled
> through the SDIO power sequence driver.  This commit adds analogous
> support for the SPI driver.  Specifically, during initialization, the
> chip will be ENABLEd and taken out of RESET and during
> deinitialization, the chip will be placed back into RESET and disabled
> (both to reduce power consumption and to ensure the WiFi radio is
> off).
> 
> Both RESET and ENABLE GPIOs are optional.  However, if the ENABLE GPIO
> is specified, then the RESET GPIO should normally also be specified as
> otherwise there is no way to ensure proper timing of the ENABLE/RESET
> sequence.
> 
> Signed-off-by: David Mosberger-Tang <davidm@egauge.net>

Failed to apply, please rebase on top of wireless-drivers-next.

error: sha1 information is lacking or useless (drivers/net/wireless/microchip/wilc1000/wlan.c).
error: could not build fake ancestor
hint: Use 'git am --show-current-patch' to see the failed patch
Applying: wilc1000: Add reset/enable GPIO support to SPI driver
Patch failed at 0001 wilc1000: Add reset/enable GPIO support to SPI driver

2 patches set to Changes Requested.

12688345 [v6,1/2] wilc1000: Add reset/enable GPIO support to SPI driver
12688343 [v6,2/2] wilc1000: Document enable-gpios and reset-gpios properties

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20211220180334.3990693-2-davidm@egauge.net/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

