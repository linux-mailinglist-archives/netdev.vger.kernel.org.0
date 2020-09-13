Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BEAD268166
	for <lists+netdev@lfdr.de>; Sun, 13 Sep 2020 23:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725980AbgIMVVZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Sep 2020 17:21:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725940AbgIMVVY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Sep 2020 17:21:24 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC0EBC06174A;
        Sun, 13 Sep 2020 14:21:24 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4627F127F71DE;
        Sun, 13 Sep 2020 14:04:36 -0700 (PDT)
Date:   Sun, 13 Sep 2020 14:21:22 -0700 (PDT)
Message-Id: <20200913.142122.633959947177815577.davem@davemloft.net>
To:     christophe.jaillet@wanadoo.fr
Cc:     kuba@kernel.org, hkallweit1@gmail.com, gustavoars@kernel.org,
        vaibhavgupta40@gmail.com, mst@redhat.com, leon@kernel.org,
        linux-parisc@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] tulip: windbond-840: switch from 'pci_' to 'dma_' API
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200913065711.351802-1-christophe.jaillet@wanadoo.fr>
References: <20200913065711.351802-1-christophe.jaillet@wanadoo.fr>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Sun, 13 Sep 2020 14:04:36 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Date: Sun, 13 Sep 2020 08:57:11 +0200

> The wrappers in include/linux/pci-dma-compat.h should go away.
> 
> The patch has been generated with the coccinelle script below and has been
> hand modified to replace GFP_ with a correct flag.
> It has been compile tested.
> 
> When memory is allocated in 'alloc_ringdesc()' GFP_KERNEL can be used
> because it is only called from 'netdev_open()' which is a '.ndo_open'
> function. Such functions are synchronized using the rtnl_lock() semaphore
> and no lock is taken in the between.
 ...
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Applied.
