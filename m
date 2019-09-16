Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C6B3B3CB8
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 16:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728837AbfIPOjs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 10:39:48 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47940 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726649AbfIPOjr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 10:39:47 -0400
Received: from localhost (80-167-222-154-cable.dk.customer.tdc.net [80.167.222.154])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5597E153CB38A;
        Mon, 16 Sep 2019 07:39:45 -0700 (PDT)
Date:   Mon, 16 Sep 2019 16:39:32 +0200 (CEST)
Message-Id: <20190916.163932.682237439904998758.davem@davemloft.net>
To:     tph@fb.com
Cc:     netdev@vger.kernel.org, jonathan.lemon@gmail.com, dsj@fb.com,
        edumazet@google.com, ncardwell@google.com, dave.taht@gmail.com,
        ycheng@google.com, soheil@google.com
Subject: Re: [PATCH v5 1/2] tcp: Add TCP_INFO counter for packets received
 out-of-order
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190913232332.44036-1-tph@fb.com>
References: <20190913232332.44036-1-tph@fb.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 16 Sep 2019 07:39:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Higdon <tph@fb.com>
Date: Fri, 13 Sep 2019 23:23:34 +0000

> For receive-heavy cases on the server-side, we want to track the
> connection quality for individual client IPs. This counter, similar to
> the existing system-wide TCPOFOQueue counter in /proc/net/netstat,
> tracks out-of-order packet reception. By providing this counter in
> TCP_INFO, it will allow understanding to what degree receive-heavy
> sockets are experiencing out-of-order delivery and packet drops
> indicating congestion.
> 
> Please note that this is similar to the counter in NetBSD TCP_INFO, and
> has the same name.
> 
> Also note that we avoid increasing the size of the tcp_sock struct by
> taking advantage of a hole.
> 
> Signed-off-by: Thomas Higdon <tph@fb.com>

Applied.
