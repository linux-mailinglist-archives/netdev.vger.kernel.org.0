Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C93C1FA1DA
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 22:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731625AbgFOUmZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 16:42:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728346AbgFOUmY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 16:42:24 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B607AC061A0E;
        Mon, 15 Jun 2020 13:42:24 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4A28F120ED49B;
        Mon, 15 Jun 2020 13:42:24 -0700 (PDT)
Date:   Mon, 15 Jun 2020 13:42:23 -0700 (PDT)
Message-Id: <20200615.134223.983361696577901385.davem@davemloft.net>
To:     navid.emamdoost@gmail.com
Cc:     nicolas.ferre@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, emamd001@umn.edu, wu000273@umn.edu,
        kjlu@umn.edu, smccaman@umn.edu
Subject: Re: [PATCH] net: macb: fix ref count leaking via
 pm_runtime_get_sync
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200614054803.26757-1-navid.emamdoost@gmail.com>
References: <20200614054803.26757-1-navid.emamdoost@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 15 Jun 2020 13:42:24 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>
Date: Sun, 14 Jun 2020 00:48:03 -0500

> in macb_mdio_write, macb_mdio_read, and at91ether_open,
> pm_runtime_get_sync is called which increments the counter even in case of
> failure, leading to incorrect ref count.
> In case of failure, decrement the ref count before returning.
> 
> Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>

This does not apply to the net tree.
