Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 547B43553E
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 04:27:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726502AbfFEC1o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 22:27:44 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55970 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726354AbfFEC1o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 22:27:44 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E737615045645;
        Tue,  4 Jun 2019 19:27:43 -0700 (PDT)
Date:   Tue, 04 Jun 2019 19:27:41 -0700 (PDT)
Message-Id: <20190604.192741.471970699001122583.davem@davemloft.net>
To:     dsahern@kernel.org
Cc:     netdev@vger.kernel.org, idosch@mellanox.com, saeedm@mellanox.com,
        kafai@fb.com, weiwan@google.com, dsahern@gmail.com
Subject: Re: [PATCH v3 net-next 0/7] net: add struct nexthop to fib{6}_info
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190604031955.26949-1-dsahern@kernel.org>
References: <20190604031955.26949-1-dsahern@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 04 Jun 2019 19:27:44 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@kernel.org>
Date: Mon,  3 Jun 2019 20:19:48 -0700

> Set 10 of 11 to improve route scalability via support for nexthops as
> standalone objects for fib entries.
>     https://lwn.net/Articles/763950/

Series applied, thanks David.
