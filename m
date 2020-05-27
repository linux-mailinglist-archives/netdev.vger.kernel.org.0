Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCB501E38F7
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 08:20:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728177AbgE0GTy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 02:19:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728084AbgE0GTx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 02:19:53 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0B7EC061A0F
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 23:19:53 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 73FF7127F35CB;
        Tue, 26 May 2020 23:19:53 -0700 (PDT)
Date:   Tue, 26 May 2020 23:19:52 -0700 (PDT)
Message-Id: <20200526.231952.313275088392613610.davem@davemloft.net>
To:     W_Armin@gmx.de
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next] ne2k-pci: Fix various coding-style issues
 and improve printk() usage
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200526180302.GA5340@mx-linux-amd>
References: <20200526180302.GA5340@mx-linux-amd>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 26 May 2020 23:19:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Armin Wolf <W_Armin@gmx.de>
Date: Tue, 26 May 2020 20:03:02 +0200

> Fixed a ton of minor checkpatch errors/warnings and remove version
> printing at module init/when device is found and use MODULE_VERSION
> instead. Also modifying the RTL8029 PCI string to include the compatible
> RTL8029AS nic.
> The only mayor issue remaining is the missing SPDX tag, but since the
> exact version of the GPL is not stated anywhere inside the file, its
> impossible to add such a tag at the moment.
> But maybe it is possible, since 8390.h states Donald Becker's 8390
> drivers are licensed under GPL 2.2 only (= GPL-2.0-only ?).
> The kernel module containing this patch compiles and runs without
> problems on a RTL8029AS-based NE2000 clone card with kernel 5.7.0-rc6.
> 
> Signed-off-by: Armin Wolf <W_Armin@gmx.de>

Applied, thank you.
