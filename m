Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42FAE27352E
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 23:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728254AbgIUVu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 17:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727237AbgIUVu2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 17:50:28 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91547C061755;
        Mon, 21 Sep 2020 14:50:28 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A165011E49F62;
        Mon, 21 Sep 2020 14:33:40 -0700 (PDT)
Date:   Mon, 21 Sep 2020 14:50:27 -0700 (PDT)
Message-Id: <20200921.145027.665980802724044555.davem@davemloft.net>
To:     Jisheng.Zhang@synaptics.com
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next] net: phy: realtek: enable ALDPS to save
 power for RTL8211F
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200921091354.2bf0a039@xhacker.debian>
References: <20200921091354.2bf0a039@xhacker.debian>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 21 Sep 2020 14:33:40 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Date: Mon, 21 Sep 2020 09:13:54 +0800

> Enable ALDPS(Advanced Link Down Power Saving) to save power when
> link down.
> 
> Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
> ---
> Since v1:
>  - add what does ALDPS mean.
>  - replace magic number 0x18 with RTL8211F_PHYCR1 macro.

Applied, thanks.
