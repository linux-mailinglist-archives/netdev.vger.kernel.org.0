Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DECBB2625D0
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 05:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728297AbgIIDUf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 23:20:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726605AbgIIDUf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 23:20:35 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26C27C061573
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 20:20:35 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5062511E3E4C3;
        Tue,  8 Sep 2020 20:03:47 -0700 (PDT)
Date:   Tue, 08 Sep 2020 20:20:33 -0700 (PDT)
Message-Id: <20200908.202033.2148316088524232659.davem@davemloft.net>
To:     weiwan@google.com
Cc:     netdev@vger.kernel.org, edumazet@google.com
Subject: Re: [PATCH net] ip: fix tos reflection in ack and reset packets
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200908210934.3418765-1-weiwan@google.com>
References: <20200908210934.3418765-1-weiwan@google.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 08 Sep 2020 20:03:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Wang <weiwan@google.com>
Date: Tue,  8 Sep 2020 14:09:34 -0700

> Currently, in tcp_v4_reqsk_send_ack() and tcp_v4_send_reset(), we
> echo the TOS value of the received packets in the response.
> However, we do not want to echo the lower 2 ECN bits in accordance
> with RFC 3168 6.1.5 robustness principles.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> 
> Signed-off-by: Wei Wang <weiwan@google.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied and queued up for -stable, thanks.
