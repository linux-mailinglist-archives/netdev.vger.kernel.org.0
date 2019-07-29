Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA97D79239
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 19:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727724AbfG2Rdv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 13:33:51 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36494 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726709AbfG2Rdv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 13:33:51 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 214C2133F3B28;
        Mon, 29 Jul 2019 10:33:49 -0700 (PDT)
Date:   Mon, 29 Jul 2019 10:33:48 -0700 (PDT)
Message-Id: <20190729.103348.1922379438002470144.davem@davemloft.net>
To:     marex@denx.de
Cc:     netdev@vger.kernel.org, Tristram.Ha@microchip.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        woojung.huh@microchip.com
Subject: Re: [PATCH V3 2/3] net: dsa: ksz: Add KSZ8795 tag code
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190726162308.16764-3-marex@denx.de>
References: <20190726162308.16764-1-marex@denx.de>
        <20190726162308.16764-3-marex@denx.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 29 Jul 2019 10:33:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marek Vasut <marex@denx.de>
Date: Fri, 26 Jul 2019 18:23:07 +0200

> @@ -77,6 +77,13 @@ config NET_DSA_TAG_KSZ_COMMON
>  	tristate
>  	default n
>  
> +config NET_DSA_TAG_KSZ8795
> +	tristate "Tag driver for Microchip 8795 family of switches"
> +	select NET_DSA_TAG_KSZ_COMMON
> +	help
> +	  Say Y if you want to enable support for tagging frames for the
> +	  Microchip 8795 family of switches.

This Kconfig knob doesn't control the inclusion of code at all.

It's only use is in patch #3 where it is selected for the new
NET_DSA_MICROCHIP_KSZ8795.

Therefore it isn't doing anything.

So please either make it control code inclusion or remove it.

Thank you.
