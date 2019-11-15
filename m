Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E684CFE68F
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 21:46:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbfKOUqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 15:46:21 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:40918 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726766AbfKOUqV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 15:46:21 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7428D14E14FEC;
        Fri, 15 Nov 2019 12:46:20 -0800 (PST)
Date:   Fri, 15 Nov 2019 12:46:19 -0800 (PST)
Message-Id: <20191115.124619.733082184859795989.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: [PATCH net-next] selftests: net: tcp_mmap should create
 detached threads
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191114164327.171997-1-edumazet@google.com>
References: <20191114164327.171997-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 15 Nov 2019 12:46:20 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Thu, 14 Nov 2019 08:43:27 -0800

> Since we do not plan using pthread_join() in the server do_accept()
> loop, we better create detached threads, or risk increasing memory
> footprint over time.
> 
> Fixes: 192dc405f308 ("selftests: net: add tcp_mmap program")
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied.
