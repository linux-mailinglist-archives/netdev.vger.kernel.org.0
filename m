Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2C6346DB27
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 19:33:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238976AbhLHShD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 13:37:03 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:45012 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238962AbhLHShB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 13:37:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E4F4DCE2033;
        Wed,  8 Dec 2021 18:33:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B184C341C8;
        Wed,  8 Dec 2021 18:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638988406;
        bh=IcuKnQleuYG1JCOQ8yF0rJR0KfoG234u39zEPO2nxhM=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=P/Vy0IFyL5DR1lESTbGVKO2KNnsfl0+Do6oWKXYdQ92LyM4/pve4wM5ZL/xJtJ0ZO
         S/rAJgZmc11UnI0DPiVir/gqaxzeWQWCw4nB4h/Uz/JUle05aHD9Qv05jiJ/0X/OG4
         uFar3YwoUGlMlQ5TlKAFDF5Gcv9pAEWMDRrsSMqvKkok7dgiANSC+vMPzMCI2mjDZF
         wwSukwJ1Zt5BuCBXaE8krFHqCqN/2g/79KW9uME2TOmdbtj2IMUiM9W02PO4DJEslI
         nb6CLid2u5hTmnLqbB2nI9keRVAbriaRO7QpjXpXU4CdqGwR84XCUl6mI3iaN1nClz
         6wNGnFaSWIPAA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wilc1000: Add id_table to spi_driver
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20211202045001.2901903-1-davidm@egauge.net>
References: <20211202045001.2901903-1-davidm@egauge.net>
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
Message-ID: <163898840113.25635.6371266090909098470.kvalo@kernel.org>
Date:   Wed,  8 Dec 2021 18:33:23 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Mosberger-Tang <davidm@egauge.net> wrote:

> This eliminates warning message:
> 
> 	SPI driver WILC_SPI has no spi_device_id for microchip,wilc1000
> 
> and makes device-tree autoloading work.
> 
> Signed-off-by: David Mosberger-Tang <davidm@egauge.net>

Patch applied to wireless-drivers-next.git, thanks.

f2f16ae9cc9c wilc1000: Add id_table to spi_driver

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20211202045001.2901903-1-davidm@egauge.net/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

