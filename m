Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B7B31A8F4A
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 01:53:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731537AbgDNXtS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 19:49:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2634403AbgDNXs1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 19:48:27 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2580CC061A0E
        for <netdev@vger.kernel.org>; Tue, 14 Apr 2020 16:48:27 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 51C4C1280FBFE;
        Tue, 14 Apr 2020 16:48:26 -0700 (PDT)
Date:   Tue, 14 Apr 2020 16:48:25 -0700 (PDT)
Message-Id: <20200414.164825.457585417402726076.davem@davemloft.net>
To:     linux@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        mcroce@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH net v2 0/2] Fix 88x3310 leaving power save mode
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200414194753.GB25745@shell.armlinux.org.uk>
References: <20200414194753.GB25745@shell.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 14 Apr 2020 16:48:26 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Date: Tue, 14 Apr 2020 20:47:53 +0100

> This series fixes a problem with the 88x3310 PHY on Macchiatobin
> coming out of powersave mode noticed by Matteo Croce.  It seems
> that certain PHY firmwares do not properly exit powersave mode,
> resulting in a fibre link not coming up.
> 
> The solution appears to be to soft-reset the PHY after clearing
> the powersave bit.
> 
> We add support for reporting the PHY firmware version to the kernel
> log, and use it to trigger this new behaviour if we have v0.3.x.x
> or more recent firmware on the PHY.  This, however, is a guess as
> the firmware revision documentation does not mention this issue,
> and we know that v0.2.1.0 works without this fix but v0.3.3.0 and
> later does not.

Series applied, thanks.
