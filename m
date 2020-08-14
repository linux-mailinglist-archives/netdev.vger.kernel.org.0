Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1313244F63
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 22:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727830AbgHNU6d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 16:58:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726623AbgHNU6d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 16:58:33 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8299DC061385;
        Fri, 14 Aug 2020 13:58:33 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 47FD7127471FA;
        Fri, 14 Aug 2020 13:41:47 -0700 (PDT)
Date:   Fri, 14 Aug 2020 13:58:32 -0700 (PDT)
Message-Id: <20200814.135832.2261260970311651260.davem@davemloft.net>
To:     mkl@pengutronix.de
Cc:     netdev@vger.kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: pull-request: can 2020-08-14
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200814110428.405051-1-mkl@pengutronix.de>
References: <20200814110428.405051-1-mkl@pengutronix.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 14 Aug 2020 13:41:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>
Date: Fri, 14 Aug 2020 13:04:22 +0200

> this is a pull request of 6 patches for net/master. All patches fix problems in
> the j1939 CAN networking stack.
> 
> The first patch is by Eric Dumazet fixes a kernel-infoleak in
> j1939_sk_sock2sockaddr_can().
> 
> The remaining 5 patches are by Oleksij Rempel and fix recption of j1939
> messages not orginated by the stack, a use-after-free in j1939_tp_txtimer(),
> ensure that the CAN driver has a ml_priv allocated. These problem were found by
> google's syzbot. Further ETP sessions with block size of less than 255 are
> fixed and a sanity check was added to j1939_xtp_rx_dat_one() to detect packet
> corruption.

Pulled, thank you Marc.
