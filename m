Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 894C126D025
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 02:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726193AbgIQAr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 20:47:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726004AbgIQAr2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 20:47:28 -0400
X-Greylist: delayed 491 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Sep 2020 20:47:28 EDT
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62CFBC061355;
        Wed, 16 Sep 2020 17:47:27 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 975BB13CB9FBE;
        Wed, 16 Sep 2020 17:30:37 -0700 (PDT)
Date:   Wed, 16 Sep 2020 17:47:23 -0700 (PDT)
Message-Id: <20200916.174723.110340106752086972.davem@davemloft.net>
To:     matthias.schiffer@ew.tq-group.com
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        kuba@kernel.org, codrin.ciubotariu@microchip.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: microchip: ksz8795: really set the
 correct number of ports
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200916100839.843-1-matthias.schiffer@ew.tq-group.com>
References: <20200916100839.843-1-matthias.schiffer@ew.tq-group.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 16 Sep 2020 17:30:38 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Date: Wed, 16 Sep 2020 12:08:39 +0200

> The KSZ9477 and KSZ8795 use the port_cnt field differently: For the
> KSZ9477, it includes the CPU port(s), while for the KSZ8795, it doesn't.
> 
> It would be a good cleanup to make the handling of both drivers match,
> but as a first step, fix the recently broken assignment of num_ports in
> the KSZ8795 driver (which completely broke probing, as the CPU port
> index was always failing the num_ports check).
> 
> Fixes: af199a1a9cb0 ("net: dsa: microchip: set the correct number of
> ports")

Please do not a tag into multiple lines.  Especially do not do this
with Fixes tags as people will do string matching on it.

> Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>

Applied and queued up for -stable.

Thanks.
