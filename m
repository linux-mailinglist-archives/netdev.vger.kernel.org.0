Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBEADAC743
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 17:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389384AbfIGP2l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Sep 2019 11:28:41 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46136 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730957AbfIGP2k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Sep 2019 11:28:40 -0400
Received: from localhost (unknown [88.214.184.0])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F3DA91528CDC7;
        Sat,  7 Sep 2019 08:28:38 -0700 (PDT)
Date:   Sat, 07 Sep 2019 17:28:37 +0200 (CEST)
Message-Id: <20190907.172837.1868098969790314376.davem@davemloft.net>
To:     jiri@resnulli.us
Cc:     netdev@vger.kernel.org, idosch@mellanox.com, dsahern@gmail.com,
        mlxsw@mellanox.com
Subject: Re: [patch net-next] net: fib_notifier: move fib_notifier_ops from
 struct net into per-net struct
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190905180656.4756-1-jiri@resnulli.us>
References: <20190905180656.4756-1-jiri@resnulli.us>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 07 Sep 2019 08:28:40 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@resnulli.us>
Date: Thu,  5 Sep 2019 20:06:56 +0200

> From: Jiri Pirko <jiri@mellanox.com>
> 
> No need for fib_notifier_ops to be in struct net. It is used only by
> fib_notifier as a private data. Use net_generic to introduce per-net
> fib_notifier struct and move fib_notifier_ops there.
> 
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>

Applied.
