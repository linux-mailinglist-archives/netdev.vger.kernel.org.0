Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B432C1DFBEF
	for <lists+netdev@lfdr.de>; Sun, 24 May 2020 01:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388123AbgEWXjb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 19:39:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388094AbgEWXjb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 May 2020 19:39:31 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25477C061A0E
        for <netdev@vger.kernel.org>; Sat, 23 May 2020 16:39:31 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7BD6F1286F3B3;
        Sat, 23 May 2020 16:39:30 -0700 (PDT)
Date:   Sat, 23 May 2020 16:39:29 -0700 (PDT)
Message-Id: <20200523.163929.1475905667820070698.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [pull request][net-next 00/10] mlx5 updates 2020-05-22
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200522235148.28987-1-saeedm@mellanox.com>
References: <20200522235148.28987-1-saeedm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 23 May 2020 16:39:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Fri, 22 May 2020 16:51:38 -0700

> This series adds misc updates to mlx5 driver.
> For more information please see tag log below.
> 
> Please pull and let me know if there is any problem.

Pulled, thank you.
