Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 235DE1C7CEF
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 00:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729759AbgEFWCB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 18:02:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728851AbgEFWCA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 18:02:00 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F35F5C061A0F
        for <netdev@vger.kernel.org>; Wed,  6 May 2020 15:02:00 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7DEC61273C096;
        Wed,  6 May 2020 15:02:00 -0700 (PDT)
Date:   Wed, 06 May 2020 15:01:59 -0700 (PDT)
Message-Id: <20200506.150159.1761695149307486444.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com, soheil@google.com,
        arjunroy@google.com
Subject: Re: [PATCH net] selftests: net: tcp_mmap: fix SO_RCVLOWAT setting
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200506162115.172485-1-edumazet@google.com>
References: <20200506162115.172485-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 06 May 2020 15:02:00 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Wed,  6 May 2020 09:21:15 -0700

> Since chunk_size is no longer an integer, we can not
> use it directly as an argument of setsockopt().
> 
> This patch should fix tcp_mmap for Big Endian kernels.
> 
> Fixes: 597b01edafac ("selftests: net: avoid ptl lock contention in tcp_mmap")
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied, thanks Eric.
