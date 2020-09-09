Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7C622625DC
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 05:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728363AbgIIDZ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 23:25:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbgIIDZ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 23:25:27 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82B0CC061573;
        Tue,  8 Sep 2020 20:25:26 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 983FE11E3E4C3;
        Tue,  8 Sep 2020 20:08:38 -0700 (PDT)
Date:   Tue, 08 Sep 2020 20:25:24 -0700 (PDT)
Message-Id: <20200908.202524.1861811044367438406.davem@davemloft.net>
To:     yoshihiro.shimoda.uh@renesas.com
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        kuba@kernel.org, Jisheng.Zhang@synaptics.com,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2] net: phy: call phy_disable_interrupts() in
 phy_attach_direct() instead
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1599609338-17732-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
References: <1599609338-17732-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 08 Sep 2020 20:08:38 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Date: Wed,  9 Sep 2020 08:55:38 +0900

>  Changes from v1:
>  - Fix build error.

When such a fundamental build failure is fixed (it could never have
built for anyone, even you), I want it explained why this happened
and how this was functionally tested if it did not even compile.

I'm not applying this patch, you must resubmit it again after
explaining what happened here instead of just quietly fixing
the build failure.

Thank you.
