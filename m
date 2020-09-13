Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6EA7267D18
	for <lists+netdev@lfdr.de>; Sun, 13 Sep 2020 03:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725937AbgIMB1N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Sep 2020 21:27:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725918AbgIMB1F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Sep 2020 21:27:05 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6F07C061573;
        Sat, 12 Sep 2020 18:27:04 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 14B0512905EEE;
        Sat, 12 Sep 2020 18:10:14 -0700 (PDT)
Date:   Sat, 12 Sep 2020 18:27:00 -0700 (PDT)
Message-Id: <20200912.182700.120125082750514250.davem@davemloft.net>
To:     christophe.jaillet@wanadoo.fr
Cc:     kuba@kernel.org, hkallweit1@gmail.com, mst@redhat.com,
        mhabets@solarflare.com, vaibhavgupta40@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] sc92031: switch from 'pci_' to 'dma_' API
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200912112858.339548-1-christophe.jaillet@wanadoo.fr>
References: <20200912112858.339548-1-christophe.jaillet@wanadoo.fr>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Sat, 12 Sep 2020 18:10:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Date: Sat, 12 Sep 2020 13:28:58 +0200

> The wrappers in include/linux/pci-dma-compat.h should go away.
> 
> The patch has been generated with the coccinelle script below and has been
> hand modified to replace GFP_ with a correct flag.
> It has been compile tested.
> 
> When memory is allocated in 'sc92031_open()' GFP_KERNEL can be used
> because it is a '.ndo_open' function and no lock is taken in the between.
> '.ndo_open' functions are synchronized with the rtnl_lock() semaphore.
 ...
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Applied.
