Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1351220447D
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 01:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730430AbgFVXeI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 19:34:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727028AbgFVXeI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 19:34:08 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF784C061573;
        Mon, 22 Jun 2020 16:34:07 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E26D112972187;
        Mon, 22 Jun 2020 16:34:06 -0700 (PDT)
Date:   Mon, 22 Jun 2020 16:34:06 -0700 (PDT)
Message-Id: <20200622.163406.1755086886045118386.davem@davemloft.net>
To:     alobakin@pm.me
Cc:     kuba@kernel.org, mkubecek@suse.cz, f.fainelli@gmail.com,
        andrew@lunn.ch, jiri@mellanox.com, antoine.tenart@bootlin.com,
        steffen.klassert@secunet.com, ayal@mellanox.com,
        therbert@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net 0/3] net: ethtool: netdev_features_strings[]
 cleanup
From:   David Miller <davem@davemloft.net>
In-Reply-To: <HPTrw9hrtm3e5151oH8oQfbr0HWTlzQ1n68bZn1hfd6yag38Tem57b4eTH-bhlaJgBxyhZb9U-qFFOafJoQqxcY-VX5fh5ZktTrnWhYeNB0=@pm.me>
References: <HPTrw9hrtm3e5151oH8oQfbr0HWTlzQ1n68bZn1hfd6yag38Tem57b4eTH-bhlaJgBxyhZb9U-qFFOafJoQqxcY-VX5fh5ZktTrnWhYeNB0=@pm.me>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 22 Jun 2020 16:34:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Lobakin <alobakin@pm.me>
Date: Sun, 21 Jun 2020 09:55:50 +0000

> This little series adds the last forgotten feature string for
> NETIF_F_GSO_TUNNEL_REMCSUM and attempts to prevent such losses
> in future.
> 
> Patches 2-3 seem more like net-next candidates rather than net-fixes,
> but for me it seems a bit more suitable to pull it during "quiet" RC
> windows, so any new related code could start from this base.
> 
> I was thinking about some kind of static assertion to have an early
> prevention mechanism for this, but the existing of 2 intended holes
> (former NO_CSUM and UFO) makes this problematic, at least at first
> sight.
> 
> v2:
>  - fix the "Fixes:" tag in the first patch;
>  - no functional changes.

Please do not mix bug fixes (missing netdev feature strings, etc.) with
cleanups (indentation changes).

Thank you.
