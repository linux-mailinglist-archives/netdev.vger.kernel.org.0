Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18B991C207B
	for <lists+netdev@lfdr.de>; Sat,  2 May 2020 00:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726405AbgEAWUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 18:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726318AbgEAWUR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 18:20:17 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F3BEC061A0C
        for <netdev@vger.kernel.org>; Fri,  1 May 2020 15:20:17 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A9E5314F2D944;
        Fri,  1 May 2020 15:20:16 -0700 (PDT)
Date:   Fri, 01 May 2020 15:20:15 -0700 (PDT)
Message-Id: <20200501.152015.1993781585716424031.davem@davemloft.net>
To:     brouer@redhat.com
Cc:     netdev@vger.kernel.org, me@tobin.cc
Subject: Re: [PATCH net-next] net: fix skb_panic to output real address
From:   David Miller <davem@davemloft.net>
In-Reply-To: <158800546361.1962096.4535216438507756179.stgit@firesoul>
References: <158800546361.1962096.4535216438507756179.stgit@firesoul>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 01 May 2020 15:20:16 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>
Date: Mon, 27 Apr 2020 18:37:43 +0200

> In skb_panic() the real pointer values are really needed to diagnose
> issues, e.g. data and head are related (to calculate headroom). The
> hashed versions of the addresses doesn't make much sense here. The
> patch use the printk specifier %px to print the actual address.
> 
> The printk documentation on %px:
> https://www.kernel.org/doc/html/latest/core-api/printk-formats.html#unmodified-addresses
> 
> Fixes: ad67b74d2469 ("printk: hash addresses printed with %p")
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>

Applied.
