Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 871A7228DAA
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 03:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731614AbgGVBcz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 21:32:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727953AbgGVBcz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 21:32:55 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67AC3C061794;
        Tue, 21 Jul 2020 18:32:55 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5A47F11DB315F;
        Tue, 21 Jul 2020 18:16:09 -0700 (PDT)
Date:   Tue, 21 Jul 2020 18:32:53 -0700 (PDT)
Message-Id: <20200721.183253.1398564714625464228.davem@davemloft.net>
To:     grygorii.strashko@ti.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, m-karicheri2@ti.com,
        nsekhar@ti.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ethernet: ti: add NETIF_F_HW_TC hw feature flag
 for taprio offload
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200717121932.26649-1-grygorii.strashko@ti.com>
References: <20200717121932.26649-1-grygorii.strashko@ti.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 21 Jul 2020 18:16:09 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>
Date: Fri, 17 Jul 2020 15:19:32 +0300

> From: Murali Karicheri <m-karicheri2@ti.com>
> 
> Currently drive supports taprio offload which is a tc feature offloaded
> to cpsw hardware. So driver has to set the hw feature flag, NETIF_F_HW_TC
> in the net device to be compliant. This patch adds the flag.
> 
> Fixes: 8127224c2708 ("ethernet: ti: am65-cpsw-qos: add TAPRIO offload support")
> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>

Applied.
