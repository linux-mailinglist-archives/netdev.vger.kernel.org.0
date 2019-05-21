Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6127925954
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 22:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727376AbfEUUob (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 16:44:31 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:45010 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726907AbfEUUoa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 16:44:30 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4F8BF14CCED30;
        Tue, 21 May 2019 13:44:30 -0700 (PDT)
Date:   Tue, 21 May 2019 13:44:29 -0700 (PDT)
Message-Id: <20190521.134429.12952058168907111.davem@davemloft.net>
To:     liuhangbin@gmail.com
Cc:     netdev@vger.kernel.org, dsahern@gmail.com
Subject: Re: [PATCH net] selftests: fib_rule_tests: use pre-defined DEV_ADDR
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190521064047.10002-1-liuhangbin@gmail.com>
References: <20190521064047.10002-1-liuhangbin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 21 May 2019 13:44:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>
Date: Tue, 21 May 2019 14:40:47 +0800

> DEV_ADDR is defined but not used. Use it in address setting.
> Do the same with IPv6 for consistency.
> 
> Reported-by: David Ahern <dsahern@gmail.com>
> Fixes: fc82d93e57e3 ("selftests: fib_rule_tests: fix local IPv4 address typo")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Applied.
