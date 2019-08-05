Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A10A7825EC
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 22:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730590AbfHEURZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 16:17:25 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33632 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727460AbfHEURY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 16:17:24 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7A1F6154316E6;
        Mon,  5 Aug 2019 13:17:24 -0700 (PDT)
Date:   Mon, 05 Aug 2019 13:17:24 -0700 (PDT)
Message-Id: <20190805.131724.1845867601454307764.davem@davemloft.net>
To:     dsahern@kernel.org
Cc:     netdev@vger.kernel.org, dsahern@gmail.com
Subject: Re: [PATCH net] ipv6: Fix unbalanced rcu locking in
 rt6_update_exception_stamp_rt
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190801213635.9278-1-dsahern@kernel.org>
References: <20190801213635.9278-1-dsahern@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 05 Aug 2019 13:17:24 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@kernel.org>
Date: Thu,  1 Aug 2019 14:36:35 -0700

> From: David Ahern <dsahern@gmail.com>
> 
> The nexthop path in rt6_update_exception_stamp_rt needs to call
> rcu_read_unlock if it fails to find a fib6_nh match rather than
> just returning.
> 
> Fixes: e659ba31d806 ("ipv6: Handle all fib6_nh in a nexthop in exception handling")
> Signed-off-by: David Ahern <dsahern@gmail.com>

Applied.
