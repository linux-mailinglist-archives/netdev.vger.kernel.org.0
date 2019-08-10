Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87EC3887A3
	for <lists+netdev@lfdr.de>; Sat, 10 Aug 2019 04:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725911AbfHJCyf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 22:54:35 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:41314 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbfHJCye (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 22:54:34 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3FD211540269F;
        Fri,  9 Aug 2019 19:54:34 -0700 (PDT)
Date:   Fri, 09 Aug 2019 19:54:29 -0700 (PDT)
Message-Id: <20190809.195429.334411908499132946.davem@davemloft.net>
To:     dsahern@kernel.org
Cc:     netdev@vger.kernel.org, dsahern@gmail.com
Subject: Re: [PATCH net-next] selftests: Fix detection of nettest command
 in fcnal-test
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190809231338.29105-1-dsahern@kernel.org>
References: <20190809231338.29105-1-dsahern@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 09 Aug 2019 19:54:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@kernel.org>
Date: Fri,  9 Aug 2019 16:13:38 -0700

> From: David Ahern <dsahern@gmail.com>
> 
> Most of the tests run by fcnal-test.sh relies on the nettest command.
> Rather than trying to cover all of the individual tests, check for the
> binary only at the beginning.
> 
> Also removes the need for log_error which is undefined.
> 
> Fixes: 6f9d5cacfe07 ("selftests: Setup for functional tests for fib and socket lookups")
> Signed-off-by: David Ahern <dsahern@gmail.com>

Applied, thanks David.
