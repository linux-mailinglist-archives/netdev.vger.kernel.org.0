Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8EA01D6409
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 22:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbgEPUkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 16:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726460AbgEPUkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 May 2020 16:40:20 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB830C061A0C;
        Sat, 16 May 2020 13:40:19 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 56B301194479F;
        Sat, 16 May 2020 13:40:19 -0700 (PDT)
Date:   Sat, 16 May 2020 13:40:18 -0700 (PDT)
Message-Id: <20200516.134018.1760282800329273820.davem@davemloft.net>
To:     shakeelb@google.com
Cc:     edumazet@google.com, willemb@google.com, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/packet: simply allocations in alloc_one_pg_vec_page
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200516021736.226222-1-shakeelb@google.com>
References: <20200516021736.226222-1-shakeelb@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 16 May 2020 13:40:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shakeel Butt <shakeelb@google.com>
Date: Fri, 15 May 2020 19:17:36 -0700

> and thus there is no need to have any fallback after vzalloc.

This statement is false.

The virtual mapping allocation or the page table allocations can fail.

A fallback is therefore indeed necessary.
