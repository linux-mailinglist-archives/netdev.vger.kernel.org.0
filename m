Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D618D204418
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 00:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731217AbgFVWyx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 18:54:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730934AbgFVWyw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 18:54:52 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92AA6C061573;
        Mon, 22 Jun 2020 15:54:52 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A9FA41296CF90;
        Mon, 22 Jun 2020 15:54:51 -0700 (PDT)
Date:   Mon, 22 Jun 2020 15:54:50 -0700 (PDT)
Message-Id: <20200622.155450.499971025775558599.davem@davemloft.net>
To:     noodles@earth.li
Cc:     linux@armlinux.org.uk, andrew@lunn.ch, f.fainelli@gmail.com,
        olteanv@gmail.com, vivien.didelot@gmail.com, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v5 0/3] net: dsa: qca8k: Improve SGMII
 interface handling
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1592648711.git.noodles@earth.li>
References: <cover.1591816172.git.noodles@earth.li>
        <cover.1592648711.git.noodles@earth.li>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 22 Jun 2020 15:54:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonathan McDowell <noodles@earth.li>
Date: Sat, 20 Jun 2020 11:30:03 +0100

> This 3 patch series migrates the qca8k switch driver over to PHYLINK,
> and then adds the SGMII clean-ups (i.e. the missing initialisation) on
> top of that as a second patch. The final patch is a simple spelling fix
> in a comment.
> 
> As before, tested with a device where the CPU connection is RGMII (i.e.
> the common current use case) + one where the CPU connection is SGMII. I
> don't have any devices where the SGMII interface is brought out to
> something other than the CPU.
 ...

Series applied, thanks.
