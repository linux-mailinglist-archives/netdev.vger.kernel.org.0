Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 893FB2244BB
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 22:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728623AbgGQT5n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 15:57:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726771AbgGQT5m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 15:57:42 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDD0BC0619D2;
        Fri, 17 Jul 2020 12:57:42 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5B9D211E4592D;
        Fri, 17 Jul 2020 12:57:42 -0700 (PDT)
Date:   Fri, 17 Jul 2020 12:57:41 -0700 (PDT)
Message-Id: <20200717.125741.1362531111425041030.davem@davemloft.net>
To:     christophe.jaillet@wanadoo.fr
Cc:     kuba@kernel.org, jes@trained-monkey.org, linux-acenic@sunsite.dk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] net: alteon: switch from 'pci_' to 'dma_' API
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200716204802.326057-1-christophe.jaillet@wanadoo.fr>
References: <20200716204802.326057-1-christophe.jaillet@wanadoo.fr>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 17 Jul 2020 12:57:42 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Date: Thu, 16 Jul 2020 22:48:02 +0200

> The wrappers in include/linux/pci-dma-compat.h should go away.
> 
> The patch has been generated with the coccinelle script below and has been
> hand modified to replace GFP_ with a correct flag.
> It has been compile tested.
> 
> When memory is allocated in 'ace_allocate_descriptors()' and
> 'ace_init()' GFP_KERNEL can be used because both functions are called from
> the probe function and no lock is acquired.
 ...
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Applied.
