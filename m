Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAC50243074
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 23:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbgHLVZf convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 12 Aug 2020 17:25:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbgHLVZe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Aug 2020 17:25:34 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5C00C061383
        for <netdev@vger.kernel.org>; Wed, 12 Aug 2020 14:25:34 -0700 (PDT)
Received: from localhost (50-47-102-2.evrt.wa.frontiernet.net [50.47.102.2])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 541A412A01946;
        Wed, 12 Aug 2020 14:08:46 -0700 (PDT)
Date:   Wed, 12 Aug 2020 14:25:28 -0700 (PDT)
Message-Id: <20200812.142528.2245824208221453574.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com, maze@google.com,
        abelits@marvell.com, nitesh@redhat.com, peterz@infradead.org
Subject: Re: [PATCH net] net: accept an empty mask in
 /sys/class/net/*/queues/rx-*/rps_cpus
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200812013440.851707-1-edumazet@google.com>
References: <20200812013440.851707-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 12 Aug 2020 14:08:46 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Tue, 11 Aug 2020 18:34:40 -0700

> We must accept an empty mask in store_rps_map(), or we are not able
> to disable RPS on a queue.
> 
> Fixes: 07bbecb34106 ("net: Restrict receive packets queuing to housekeeping CPUs")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Maciej ¯enczykowski <maze@google.com>

Applied, thanks Eric.
