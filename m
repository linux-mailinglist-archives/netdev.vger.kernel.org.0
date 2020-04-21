Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8527B1B32B6
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 00:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726116AbgDUWnS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 18:43:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725850AbgDUWnS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 18:43:18 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3BC1C0610D5
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 15:43:18 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3B167128E9274;
        Tue, 21 Apr 2020 15:43:18 -0700 (PDT)
Date:   Tue, 21 Apr 2020 15:43:17 -0700 (PDT)
Message-Id: <20200421.154317.1266224820418902580.davem@davemloft.net>
To:     baruch@tkos.co.il
Cc:     linux@armlinux.org.uk, netdev@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com
Subject: Re: [PATCH net-next v2] net: phy: marvell10g: add firmware load
 support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <31f9d27ed19e074db87307c319c4d07309acecae.1587363707.git.baruch@tkos.co.il>
References: <31f9d27ed19e074db87307c319c4d07309acecae.1587363707.git.baruch@tkos.co.il>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 21 Apr 2020 15:43:18 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baruch Siach <baruch@tkos.co.il>
Date: Mon, 20 Apr 2020 09:21:47 +0300

> Kernel Ethernet PHY maintainers are unlikely to take this patch
> upstream. This is because the linux-firmware repository can not accept
> the firmware files since they are not legally distributable. I post the
> code here as reference to anyone who needs firmware load functionality
> to make this hardware design work.

If you are going to post changes that are like this, please say "RFC"
or "DO NOT APPLY" in the Subject line so that it is clear.

Thank you.
