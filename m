Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D83330279
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 20:57:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbfE3S51 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 14:57:27 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57644 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbfE3S51 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 14:57:27 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EF1B014D9FA44;
        Thu, 30 May 2019 11:57:26 -0700 (PDT)
Date:   Thu, 30 May 2019 11:57:26 -0700 (PDT)
Message-Id: <20190530.115726.2295852303789730642.davem@davemloft.net>
To:     dsahern@gmail.com
Cc:     alexei.starovoitov@gmail.com, dsahern@kernel.org,
        netdev@vger.kernel.org, idosch@mellanox.com, saeedm@mellanox.com,
        kafai@fb.com, weiwan@google.com
Subject: Re: [PATCH net-next 0/7] net: add struct nexthop to fib{6}_info
From:   David Miller <davem@davemloft.net>
In-Reply-To: <65320e39-8ea2-29d8-b5f9-2de0c0c7e689@gmail.com>
References: <20190530.110149.956896317988019526.davem@davemloft.net>
        <CAADnVQJT8UJntO=pSYGN-eokuWGP_6jEeLkFgm2rmVvxmGtUCg@mail.gmail.com>
        <65320e39-8ea2-29d8-b5f9-2de0c0c7e689@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 May 2019 11:57:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>
Date: Thu, 30 May 2019 12:52:43 -0600

> The nexthop code paths are not live yet. More changes are needed before
> that can happen. I have been sending the patches in small, reviewable
> increments to be kind to reviewers than a single 27 patch set with
> everything (the remaining set which is over the limit BTW).

We definitely need tests using the new netlink attributes even if the
code paths aren't live yet.
