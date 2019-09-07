Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 240E5AC74D
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 17:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390962AbfIGPkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Sep 2019 11:40:47 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46308 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389207AbfIGPkr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Sep 2019 11:40:47 -0400
Received: from localhost (unknown [88.214.184.0])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2463C152EFC55;
        Sat,  7 Sep 2019 08:40:45 -0700 (PDT)
Date:   Sat, 07 Sep 2019 17:40:44 +0200 (CEST)
Message-Id: <20190907.174044.1392894436355272262.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     netdev@vger.kernel.org
Subject: Re: [pull request][net-next 00/14] Mellanox, mlx5 cleanups & port
 congestion stats
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190905215034.22713-1-saeedm@mellanox.com>
References: <20190905215034.22713-1-saeedm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 07 Sep 2019 08:40:46 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Thu, 5 Sep 2019 21:50:52 +0000

> This series provides 12 mlx5 cleanup patches and last 2 patches provide
> port congestion stats to ethtool.
> 
> For more information please see tag log below.
> 
> Please pull and let me know if there is any problem.

Pulled, thanks Saeed.
