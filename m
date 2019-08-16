Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B00690AEB
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 00:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727787AbfHPWZx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 18:25:53 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:41258 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727693AbfHPWZw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 18:25:52 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 34811140B0A1D;
        Fri, 16 Aug 2019 15:25:52 -0700 (PDT)
Date:   Fri, 16 Aug 2019 15:25:51 -0700 (PDT)
Message-Id: <20190816.152551.1881280267768446454.davem@davemloft.net>
To:     dsahern@kernel.org
Cc:     netdev@vger.kernel.org, dan.carpenter@oracle.com, dsahern@gmail.com
Subject: Re: [PATCH net-next] selftests: Fix get_ifidx and callers in
 nettest.c
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190814171151.27739-1-dsahern@kernel.org>
References: <20190814171151.27739-1-dsahern@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 16 Aug 2019 15:25:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@kernel.org>
Date: Wed, 14 Aug 2019 10:11:51 -0700

> From: David Ahern <dsahern@gmail.com>
> 
> Dan reported:
 ...
> Update get_ifidx to return -1 on errors and cleanup callers of it.
> 
> Fixes: acda655fefae ("selftests: Add nettest")
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: David Ahern <dsahern@gmail.com>

Applied, thanks David.
