Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D78ED7D182
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 00:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729353AbfGaWsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 18:48:52 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44994 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726755AbfGaWsw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 18:48:52 -0400
Received: from localhost (c-24-20-22-31.hsd1.or.comcast.net [24.20.22.31])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E8C8A1264D981;
        Wed, 31 Jul 2019 15:48:51 -0700 (PDT)
Date:   Wed, 31 Jul 2019 18:48:49 -0400 (EDT)
Message-Id: <20190731.184849.40667279510959463.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     netdev@vger.kernel.org
Subject: Re: [pull request][net-next 00/13] Mellanox, mlx5 tc flow handling
 for concurrent execution (Part 1)
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190729234934.23595-1-saeedm@mellanox.com>
References: <20190729234934.23595-1-saeedm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 31 Jul 2019 15:48:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Mon, 29 Jul 2019 23:50:14 +0000

> This series, mostly from Vlad, is the first part of ongoing work to
> improve mlx5 tc flow handling by removing dependency on rtnl_lock and
> providing a more fine-grained locking and rcu safe data structures.
> 
> For more information please see tag log below.
> 
> Please pull and let me know if there is any problem.

Pulled, thanks Saeed.

I will push this back out after a build test (which will take a while
since I am on my laptop).  So please be patient.

Thanks.
