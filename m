Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 792B720EA2C
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 02:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728147AbgF3AZK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 20:25:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726065AbgF3AZJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 20:25:09 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCEB6C061755
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 17:25:08 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 11ADE127BE230;
        Mon, 29 Jun 2020 17:25:07 -0700 (PDT)
Date:   Mon, 29 Jun 2020 17:25:07 -0700 (PDT)
Message-Id: <20200629.172507.776962546270147766.davem@davemloft.net>
To:     baruch@tkos.co.il
Cc:     linux@armlinux.org.uk, netdev@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, sh@tkos.co.il
Subject: Re: [PATCH v2] net: phy: marvell10g: support XFI rate matching mode
From:   David Miller <davem@davemloft.net>
In-Reply-To: <76ee08645fd35182911fd2bac2546e455c4b662c.1593327891.git.baruch@tkos.co.il>
References: <76ee08645fd35182911fd2bac2546e455c4b662c.1593327891.git.baruch@tkos.co.il>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 29 Jun 2020 17:25:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baruch Siach <baruch@tkos.co.il>
Date: Sun, 28 Jun 2020 10:04:51 +0300

> When the hardware MACTYPE hardware configuration pins are set to "XFI
> with Rate Matching" the PHY interface operate at fixed 10Gbps speed. The
> MAC buffer packets in both directions to match various wire speeds.
> 
> Read the MAC Type field in the Port Control register, and set the MAC
> interface speed accordingly.
> 
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> ---
> v2: Move rate matching state read to config_init (RMK)

Applied to net-next, thanks.
