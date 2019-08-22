Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07FC1989CA
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 05:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729303AbfHVDYC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 23:24:02 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37580 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726785AbfHVDYC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 23:24:02 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E5D8815064084;
        Wed, 21 Aug 2019 20:24:01 -0700 (PDT)
Date:   Wed, 21 Aug 2019 20:23:59 -0700 (PDT)
Message-Id: <20190821.202359.1847426570667026964.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     netdev@vger.kernel.org
Subject: Re: [pull request][net-next 00/11] Mellanox, mlx5 tc flow handling
 for concurrent execution (Part 3/3)
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190821232806.21847-1-saeedm@mellanox.com>
References: <20190821232806.21847-1-saeedm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 21 Aug 2019 20:24:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Wed, 21 Aug 2019 23:28:31 +0000

> This series, mostly from Vlad, is the 3rd and last part of 3 part series
> to improve mlx5 tc flow handling by removing dependency on rtnl_lock and
> providing a more fine-grained locking and rcu safe data structures to
> allow tc flow handling for concurrent execution.
> 
> 2) In this part Vlad handles mlx5e neigh offloads for concurrent
> execution.
> 
> 2) Vlad with Dmytro's help, They add 3 new mlx5 tracepoints to track mlx5
>  tc flower requests and neigh updates.
> 
> 3) Added mlx5 documentation for the new tracepoints.
> 
> For more information please see tag log below.
> 
> Please pull and let me know if there is any problem.

I reviewed this a few times, looks good.

Pulled, thanks.
