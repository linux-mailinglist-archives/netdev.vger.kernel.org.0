Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF6EF792B9
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 19:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729069AbfG2R7N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 13:59:13 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36870 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726167AbfG2R7N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 13:59:13 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E119C1401D962;
        Mon, 29 Jul 2019 10:59:12 -0700 (PDT)
Date:   Mon, 29 Jul 2019 10:59:12 -0700 (PDT)
Message-Id: <20190729.105912.372124003186607133.davem@davemloft.net>
To:     colin.king@canonical.com
Cc:     dsahern@gmail.com, jiri@resnulli.us, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rocker: fix memory leaks of fib_work on two error
 return paths
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190727233726.3121-1-colin.king@canonical.com>
References: <20190727233726.3121-1-colin.king@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 29 Jul 2019 10:59:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Sun, 28 Jul 2019 00:37:26 +0100

> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently there are two error return paths that leak memory allocated
> to fib_work. Fix this by kfree'ing fib_work before returning.
> 
> Addresses-Coverity: ("Resource leak")
> Fixes: 19a9d136f198 ("ipv4: Flag fib_info with a fib_nh using IPv6 gateway")
> Fixes: dbcc4fa718ee ("rocker: Fail attempts to use routes with nexthop objects")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied.
