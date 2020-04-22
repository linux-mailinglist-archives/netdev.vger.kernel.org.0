Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C9051B4DEE
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 22:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbgDVUDJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 16:03:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726475AbgDVUDJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 16:03:09 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C5BCC03C1A9
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 13:03:09 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 673D1120ED578;
        Wed, 22 Apr 2020 13:03:08 -0700 (PDT)
Date:   Wed, 22 Apr 2020 13:03:07 -0700 (PDT)
Message-Id: <20200422.130307.1217791246385366813.davem@davemloft.net>
To:     dsahern@kernel.org
Cc:     kuba@kernel.org, netdev@vger.kernel.org, dsahern@gmail.com,
        Jason@zx2c4.com
Subject: Re: [PATCH net] selftests: Fix suppress test in fib_tests.sh
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200421144724.54859-1-dsahern@kernel.org>
References: <20200421144724.54859-1-dsahern@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 Apr 2020 13:03:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@kernel.org>
Date: Tue, 21 Apr 2020 08:47:24 -0600

> From: David Ahern <dsahern@gmail.com>
> 
> fib_tests is spewing errors:
>     ...
>     Cannot open network namespace "ns1": No such file or directory
>     Cannot open network namespace "ns1": No such file or directory
>     Cannot open network namespace "ns1": No such file or directory
>     Cannot open network namespace "ns1": No such file or directory
>     ping: connect: Network is unreachable
>     Cannot open network namespace "ns1": No such file or directory
>     Cannot open network namespace "ns1": No such file or directory
>     ...
> 
> Each test entry in fib_tests is supposed to do its own setup and
> cleanup. Right now the $IP commands in fib_suppress_test are
> failing because there is no ns1. Add the setup/cleanup and logging
> expected for each test.
> 
> Fixes: ca7a03c41753 ("ipv6: do not free rt if FIB_LOOKUP_NOREF is set on suppress rule")
> Signed-off-by: David Ahern <dsahern@gmail.com>

Applied, thanks.
