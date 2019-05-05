Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE57D13E3C
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 09:47:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727312AbfEEHrh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 03:47:37 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46458 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725792AbfEEHrh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 03:47:37 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7FF0C14C048B3;
        Sun,  5 May 2019 00:47:36 -0700 (PDT)
Date:   Sun, 05 May 2019 00:47:36 -0700 (PDT)
Message-Id: <20190505.004736.1929754545979778466.davem@davemloft.net>
To:     dsahern@kernel.org
Cc:     netdev@vger.kernel.org, idosch@mellanox.com, dsahern@gmail.com
Subject: Re: [PATCH v4 net-next 0/3] ipv4: Move location of pcpu route
 cache and exceptions
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190430144550.15033-1-dsahern@kernel.org>
References: <20190430144550.15033-1-dsahern@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 05 May 2019 00:47:36 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@kernel.org>
Date: Tue, 30 Apr 2019 07:45:47 -0700

> This series moves IPv4 pcpu cached routes from fib_nh to fib_nh_common
> to make the caches available for IPv6 nexthops (fib6_nh) with IPv4
> routes. This allows a fib6_nh struct to be used with both IPv4 and
> and IPv6 routes.
 ...

Series applied, thanks David.
