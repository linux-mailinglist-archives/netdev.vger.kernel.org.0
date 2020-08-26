Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B83D5253A6A
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 00:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726444AbgHZW4R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 18:56:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726071AbgHZW4P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 18:56:15 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90443C061574
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 15:56:15 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 49B331294A78F;
        Wed, 26 Aug 2020 15:39:28 -0700 (PDT)
Date:   Wed, 26 Aug 2020 15:56:13 -0700 (PDT)
Message-Id: <20200826.155613.1810338086699793488.davem@davemloft.net>
To:     tariqt@mellanox.com
Cc:     netdev@vger.kernel.org, moshe@mellanox.com, saeedm@mellanox.com,
        kuba@kernel.org
Subject: Re: [PATCH net-next 0/3] net_prefetch API
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200826125418.11379-1-tariqt@mellanox.com>
References: <20200826125418.11379-1-tariqt@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Aug 2020 15:39:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>
Date: Wed, 26 Aug 2020 15:54:15 +0300

> This patchset adds a common net API for L1 cacheline size-aware prefetch.
> 
> Patch 1 introduces the common API in net and aligns the drivers to use it.
> Patches 2 and 3 add usage in mlx4 and mlx5 Eth drivers.
> 
> Series generated against net-next commit:
> 079f921e9f4d Merge tag 'batadv-next-for-davem-20200824' of git://git.open-mesh.org/linux-merge

Effectively a nice little cleanup, series applied, thanks.
