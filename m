Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7333D274D83
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 01:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726979AbgIVXuk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 19:50:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726641AbgIVXuh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 19:50:37 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1344C061755;
        Tue, 22 Sep 2020 16:50:36 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4A6F113BF8150;
        Tue, 22 Sep 2020 16:33:46 -0700 (PDT)
Date:   Tue, 22 Sep 2020 16:50:30 -0700 (PDT)
Message-Id: <20200922.165030.2291105439162323404.davem@davemloft.net>
To:     morbo@google.com
Cc:     linux-kbuild@vger.kernel.org, yamada.masahiro@socionext.com,
        luto@kernel.org, michal.lkml@markovi.net, catalin.marinas@arm.com,
        will@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        sparclinux@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        tglx@linutronix.de, natechancellor@gmail.com
Subject: Re: [PATCH] kbuild: explicitly specify the build id style
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200922232140.1994390-1-morbo@google.com>
References: <20200922232140.1994390-1-morbo@google.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 22 Sep 2020 16:33:47 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bill Wendling <morbo@google.com>
Date: Tue, 22 Sep 2020 16:21:40 -0700

> ld's --build-id defaults to "sha1" style, while lld defaults to "fast".
> The build IDs are very different between the two, which may confuse
> programs that reference them.
> 
> Signed-off-by: Bill Wendling <morbo@google.com>

Acked-by: David S. Miller <davem@davemloft.net>
