Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 178FE202797
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 02:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728673AbgFUA1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 20:27:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728641AbgFUA1h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 20:27:37 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 076D7C061794
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 17:27:37 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A7BA3120ED49C;
        Sat, 20 Jun 2020 17:27:36 -0700 (PDT)
Date:   Sat, 20 Jun 2020 17:27:36 -0700 (PDT)
Message-Id: <20200620.172736.1432215291509651158.davem@davemloft.net>
To:     snelson@pensando.io
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net] ionic: tame the watchdog timer on reconfig
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200618172904.53814-1-snelson@pensando.io>
References: <20200618172904.53814-1-snelson@pensando.io>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 20 Jun 2020 17:27:36 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>
Date: Thu, 18 Jun 2020 10:29:04 -0700

> Even with moving netif_tx_disable() to an earlier point when
> taking down the queues for a reconfiguration, we still end
> up with the occasional netdev watchdog Tx Timeout complaint.
> The old method of using netif_trans_update() works fine for
> queue 0, but has no effect on the remaining queues.  Using
> netif_device_detach() allows us to signal to the watchdog to
> ignore us for the moment.
> 
> Fixes: beead698b173 ("ionic: Add the basic NDO callbacks for netdev support")
> Signed-off-by: Shannon Nelson <snelson@pensando.io>

Applied and queued up for -stable, thanks.
