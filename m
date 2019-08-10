Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24C1B887B2
	for <lists+netdev@lfdr.de>; Sat, 10 Aug 2019 05:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726047AbfHJDLy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 23:11:54 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:41454 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725927AbfHJDLx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 23:11:53 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6D26915404F50;
        Fri,  9 Aug 2019 20:11:53 -0700 (PDT)
Date:   Fri, 09 Aug 2019 20:11:52 -0700 (PDT)
Message-Id: <20190809.201152.259218526870781824.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     netdev@vger.kernel.org
Subject: Re: [pull request][net-next 00/15] Mellanox, mlx5 tc flow handling
 for concurrent execution (Part 2)
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190809220359.11516-1-saeedm@mellanox.com>
References: <20190809220359.11516-1-saeedm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 09 Aug 2019 20:11:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Fri, 9 Aug 2019 22:04:17 +0000

> This series, mostly from Vlad, is the 2nd part of 3 part series to
> improve mlx5 tc flow handling by removing dependency on rtnl_lock and
> providing a more fine-grained locking and rcu safe data structures to
> allow tc flow handling for concurrent execution.
> 
> In this part Vlad handles hairpin, header rewrite and encapsulation
> offloads.
> 
> For more information please see tag log below.
> 
> Please pull and let me know if there is any problem.

Looks good, pulled, thanks.
