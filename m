Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 973B047D613
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 18:52:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344434AbhLVRwC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 12:52:02 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58050 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234375AbhLVRwB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 12:52:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B926B81DCC;
        Wed, 22 Dec 2021 17:52:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AC77C36AE5;
        Wed, 22 Dec 2021 17:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640195519;
        bh=sx7hXrnqkBfQsuaWS5i96aHg5G2GtdDiKAALnb3Wd+g=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=RTtUDWTwcKlw2xMYW/yYmq/w8VHhu+pJqH3aqYUJtrhXMeWPsOG7xubVmKCLk6ycz
         2F/eLR8fZr7pTMItLLBrQL9qiFUjXdP8KaLNXsJeWTj8H+hk8Aa7aRAzO6QtNAN5zf
         a4sxfVNxvR7evy/DBYNkwU44RNE1VU5UzR0RP8qQdD4p113VHTTQUsCQbL0obKVDW7
         stuKeeF3hWFxEwlRMw5e6/GTltWh3WyZNEwLrByV4zXOfkXUmZEAFIbBlx2NfF/0gE
         zJeoqHrSSphJB2V5zrOAPabqb35Sje9WVf0TM2k0nTLaX/7Sx/CRZNdvLq1fGCRJlp
         ZXKC9cnh/1gxw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v7 1/2] wilc1000: Add reset/enable GPIO support to SPI
 driver
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20211221212531.4011609-2-davidm@egauge.net>
References: <20211221212531.4011609-2-davidm@egauge.net>
To:     David Mosberger-Tang <davidm@egauge.net>
Cc:     Ajay Singh <ajay.kathat@microchip.com>,
        Adham Abozaeid <adham.abozaeid@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        David Mosberger-Tang <davidm@egauge.net>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164019551477.12144.8431352283963793868.kvalo@kernel.org>
Date:   Wed, 22 Dec 2021 17:51:56 +0000 (UTC)
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
> Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>

2 patches applied to wireless-drivers-next.git, thanks.

ec031ac4792c wilc1000: Add reset/enable GPIO support to SPI driver
f31ee3c0a555 wilc1000: Document enable-gpios and reset-gpios properties

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20211221212531.4011609-2-davidm@egauge.net/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

