Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D142D214968
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 02:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728075AbgGEAzg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jul 2020 20:55:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727041AbgGEAzg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jul 2020 20:55:36 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 274A6C061794
        for <netdev@vger.kernel.org>; Sat,  4 Jul 2020 17:55:36 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 84697157A9D8D;
        Sat,  4 Jul 2020 17:55:35 -0700 (PDT)
Date:   Sat, 04 Jul 2020 17:55:34 -0700 (PDT)
Message-Id: <20200704.175534.184623092857758703.davem@davemloft.net>
To:     tannerlove.kernel@gmail.com
Cc:     netdev@vger.kernel.org, tannerlove@google.com, willemb@google.com
Subject: Re: [PATCH net-next] selftests/net: update initializer syntax to
 use c99 designators
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200704204514.3800450-1-tannerlove.kernel@gmail.com>
References: <20200704204514.3800450-1-tannerlove.kernel@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 04 Jul 2020 17:55:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tanner Love <tannerlove.kernel@gmail.com>
Date: Sat,  4 Jul 2020 16:45:14 -0400

> From: Tanner Love <tannerlove@google.com>
> 
> Before, clang version 9 threw errors such as: error:
> use of GNU old-style field designator extension [-Werror,-Wgnu-designator]
>                 { tstamp: true, swtstamp: true }
>                   ^~~~~~~
>                   .tstamp =
> Fix these warnings in tools/testing/selftests/net in the same manner as
> commit 121e357ac728 ("selftests/harness: Update named initializer syntax").
> N.B. rxtimestamp.c is the only affected file in the directory.
> 
> Signed-off-by: Tanner Love <tannerlove@google.com>
> Acked-by: Willem de Bruijn <willemb@google.com>

Applied.
