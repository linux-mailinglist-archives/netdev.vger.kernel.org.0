Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95259280827
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 21:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733127AbgJATyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 15:54:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730045AbgJATyB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 15:54:01 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EF02C0613D0;
        Thu,  1 Oct 2020 12:54:01 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 921AB147DE1D2;
        Thu,  1 Oct 2020 12:37:12 -0700 (PDT)
Date:   Thu, 01 Oct 2020 12:53:59 -0700 (PDT)
Message-Id: <20201001.125359.1752693461501787622.davem@davemloft.net>
To:     geert+renesas@glider.be
Cc:     kuba@kernel.org, robh+dt@kernel.org, sergei.shtylyov@gmail.com,
        f.fainelli@gmail.com, andrew@lunn.ch, linux@rempel-privat.de,
        philippe.schenker@toradex.com, hkallweit1@gmail.com,
        dmurphy@ti.com, kazuya.mizuguchi.ks@renesas.com,
        wsa+renesas@sang-engineering.com, magnus.damm@gmail.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v4 resend 0/5] net/ravb: Add support for
 explicit internal clock delay configuration
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201001101008.14365-1-geert+renesas@glider.be>
References: <20201001101008.14365-1-geert+renesas@glider.be>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 01 Oct 2020 12:37:13 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>
Date: Thu,  1 Oct 2020 12:10:03 +0200

> Some Renesas EtherAVB variants support internal clock delay
> configuration, which can add larger delays than the delays that are
> typically supported by the PHY (using an "rgmii-*id" PHY mode, and/or
> "[rt]xc-skew-ps" properties).
> 
> Historically, the EtherAVB driver configured these delays based on the
> "rgmii-*id" PHY mode.  This caused issues with PHY drivers that
> implement PHY internal delays properly[1].  Hence a backwards-compatible
> workaround was added by masking the PHY mode[2].
> 
> This patch series implements the next step of the plan outlined in [3],
> and adds proper support for explicit configuration of the MAC internal
> clock delays using new "[rt]x-internal-delay-ps" properties.  If none of
> these properties is present, the driver falls back to the old handling.
 ...

Series applied, thank you.
