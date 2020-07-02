Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95B43211762
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 02:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727917AbgGBAqu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 20:46:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726389AbgGBAqt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 20:46:49 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7C87C08C5C1
        for <netdev@vger.kernel.org>; Wed,  1 Jul 2020 17:46:49 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 583EF14E50EDC;
        Wed,  1 Jul 2020 17:46:49 -0700 (PDT)
Date:   Wed, 01 Jul 2020 17:46:48 -0700 (PDT)
Message-Id: <20200701.174648.1223650355222385804.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: [PATCH net] tcp: fix SO_RCVLOWAT possible hangs under high mem
 pressure
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200630205128.3162961-1-edumazet@google.com>
References: <20200630205128.3162961-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 01 Jul 2020 17:46:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Tue, 30 Jun 2020 13:51:28 -0700

> Whenever tcp_try_rmem_schedule() returns an error, we are under
> trouble and should make sure to wakeup readers so that they
> can drain socket queues and eventually make room.
> 
> Fixes: 03f45c883c6f ("tcp: avoid extra wakeups for SO_RCVLOWAT users")
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied and queued up for -stable, thanks Eric.
