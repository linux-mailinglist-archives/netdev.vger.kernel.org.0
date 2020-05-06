Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F1051C7B7A
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 22:47:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729194AbgEFUrE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 16:47:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729162AbgEFUrD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 16:47:03 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E4B3C061A0F
        for <netdev@vger.kernel.org>; Wed,  6 May 2020 13:47:03 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 24AE3120F5281;
        Wed,  6 May 2020 13:47:03 -0700 (PDT)
Date:   Wed, 06 May 2020 13:47:02 -0700 (PDT)
Message-Id: <20200506.134702.1167164917896533316.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        arjunroy@google.com, soheil@google.com
Subject: Re: [PATCH net] selftests: net: tcp_mmap: clear whole
 tcp_zerocopy_receive struct
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200506035106.187948-1-edumazet@google.com>
References: <20200506035106.187948-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 06 May 2020 13:47:03 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Tue,  5 May 2020 20:51:06 -0700

> We added fields in tcp_zerocopy_receive structure,
> so make sure to clear all fields to not pass garbage to the kernel.
> 
> We were lucky because recent additions added 'out' parameters,
> still we need to clean our reference implementation, before folks
> copy/paste it.
> 
> Fixes: c8856c051454 ("tcp-zerocopy: Return inq along with tcp receive zerocopy.")
> Fixes: 33946518d493 ("tcp-zerocopy: Return sk_err (if set) along with tcp receive zerocopy.")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Arjun Roy <arjunroy@google.com>
> Cc: Soheil Hassas Yeganeh <soheil@google.com>

Applied, thanks Eric.
