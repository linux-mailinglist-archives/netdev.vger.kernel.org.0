Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 173871C9C04
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 22:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728126AbgEGUR3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 16:17:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726514AbgEGUR3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 16:17:29 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 383ADC05BD43
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 13:17:29 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7651E1195050D;
        Thu,  7 May 2020 13:17:28 -0700 (PDT)
Date:   Thu, 07 May 2020 13:17:27 -0700 (PDT)
Message-Id: <20200507.131727.907589220898369492.davem@davemloft.net>
To:     geert+renesas@glider.be
Cc:     linux@prisktech.co.nz, arnd@arndb.de, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] via-rhine: Add platform dependencies
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200507114205.24621-1-geert+renesas@glider.be>
References: <20200507114205.24621-1-geert+renesas@glider.be>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 07 May 2020 13:17:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>
Date: Thu,  7 May 2020 13:42:05 +0200

> The VIA Rhine Ethernet interface is only present on PCI devices or
> VIA/WonderMedia VT8500/WM85xx SoCs.  Add platform dependencies to the
> VIA_RHINE config symbol, to avoid asking the user about it when
> configuring a kernel without PCI or VT8500/WM85xx support.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Applied to net-next.

Although I hope that the COMPILE_TEST guard is not too loose and
now we'll have randconfig build failures for some reason.
