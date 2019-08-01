Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 143147E49C
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 23:05:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389045AbfHAVEJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 17:04:09 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:32830 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725846AbfHAVEJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 17:04:09 -0400
Received: from localhost (c-24-20-22-31.hsd1.or.comcast.net [24.20.22.31])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 360411540AD55;
        Thu,  1 Aug 2019 14:04:08 -0700 (PDT)
Date:   Thu, 01 Aug 2019 17:04:07 -0400 (EDT)
Message-Id: <20190801.170407.2164489969623955445.davem@davemloft.net>
To:     mka@chromium.org
Cc:     robh+dt@kernel.org, mark.rutland@arm.com, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        dianders@chromium.org
Subject: Re: [PATCH v4 4/4] net: phy: realtek: configure RTL8211E LEDs
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190801190759.28201-5-mka@chromium.org>
References: <20190801190759.28201-1-mka@chromium.org>
        <20190801190759.28201-5-mka@chromium.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 01 Aug 2019 14:04:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matthias Kaehlcke <mka@chromium.org>
Date: Thu,  1 Aug 2019 12:07:59 -0700

> +static int rtl8211e_config_leds(struct phy_device *phydev)
> +{
> +	int i, oldpage, ret;
> +	u16 lacr_bits = 0, lcr_bits = 0;
> +	u16 lacr_mask = RLT8211E_LACR_LEDACTCTRL_MASK;
> +	u16 lcr_mask = RTL8211E_LCR_LEDCTRL_MASK;
> +	bool eed_led_mode_disabled = false;

Please use reverse christmas tree ordering here.
