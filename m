Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23117263606
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 20:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbgIISaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 14:30:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725772AbgIISa3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 14:30:29 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 389B7C061573
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 11:30:29 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D774E1295A9F8;
        Wed,  9 Sep 2020 11:13:40 -0700 (PDT)
Date:   Wed, 09 Sep 2020 11:30:26 -0700 (PDT)
Message-Id: <20200909.113026.2174580610754325741.davem@davemloft.net>
To:     ayush.sawal@chelsio.com
Cc:     herbert@gondor.apana.org.au, netdev@vger.kernel.org,
        secdev@chelsio.com
Subject: Re: [PATCH net-next] cxgb4/ch_ipsec: Registering xfrmdev_ops with
 cxgb4
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200909103620.30210-1-ayush.sawal@chelsio.com>
References: <20200909103620.30210-1-ayush.sawal@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 09 Sep 2020 11:13:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ayush Sawal <ayush.sawal@chelsio.com>
Date: Wed,  9 Sep 2020 16:06:20 +0530

> As ch_ipsec was removed without clearing xfrmdev_ops and netdev
> feature(esp-hw-offload). When a recalculation of netdev feature is
> triggered by changing tls feature(tls-hw-tx-offload) from user
> request, it causes a page fault due to absence of valid xfrmdev_ops.
> 
> Fixes: 6dad4e8ab3ec ("chcr: Add support for Inline IPSec")
> Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>

Applied, thank you.
