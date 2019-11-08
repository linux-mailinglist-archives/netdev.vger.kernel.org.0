Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D05DF3CA5
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 01:17:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbfKHARd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 19:17:33 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:50596 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725928AbfKHARd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 19:17:33 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1301D15385188;
        Thu,  7 Nov 2019 16:17:33 -0800 (PST)
Date:   Thu, 07 Nov 2019 16:17:32 -0800 (PST)
Message-Id: <20191107.161732.1974074514689745098.davem@davemloft.net>
To:     dsahern@kernel.org
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] selftests: Add source route tests to fib_tests
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191107183232.4510-1-dsahern@kernel.org>
References: <20191107183232.4510-1-dsahern@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 07 Nov 2019 16:17:33 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@kernel.org>
Date: Thu,  7 Nov 2019 18:32:32 +0000

> Add tests to verify routes with source address set are deleted when
> source address is deleted.
> 
> Signed-off-by: David Ahern <dsahern@kernel.org>
 ...
> +	$IP ro add vrf red unreachable default 
                                              ^

Trailing whitespace which I fixed up.

Applied, thanks David.
