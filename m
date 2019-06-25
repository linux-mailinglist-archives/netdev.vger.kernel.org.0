Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67EE2559B1
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 23:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726354AbfFYVIj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 17:08:39 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:51260 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726040AbfFYVIj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 17:08:39 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BE8C413411C14;
        Tue, 25 Jun 2019 14:08:38 -0700 (PDT)
Date:   Tue, 25 Jun 2019 14:08:38 -0700 (PDT)
Message-Id: <20190625.140838.717376362398793833.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     jes.sorensen@gmail.com, kernel-team@fb.com, jsorensen@fb.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] mlx5: Fix build when CONFIG_MLX5_EN_RXNFC is
 disabled
From:   David Miller <davem@davemloft.net>
In-Reply-To: <91260adb2227e477647afda66fdff9d9a9f52c60.camel@mellanox.com>
References: <20190625152708.23729-2-Jes.Sorensen@gmail.com>
        <20190625.133404.1626801368802216614.davem@davemloft.net>
        <91260adb2227e477647afda66fdff9d9a9f52c60.camel@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 25 Jun 2019 14:08:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Tue, 25 Jun 2019 21:01:58 +0000

> BTW is there a way to clear up "Awaiting Upstream" clutter [1] for mlx5
> patches that are already pulled ?
> 
> [1] 
> https://patchwork.ozlabs.org/project/netdev/list/?series=&submitter=&state=8&q=mlx5&archive=&delegate=

I don't understand what the problem is.  Everything there is in the
appropriate state.

When something hits netdev that doesn't go directly to my tree, that's
the approprate state forever.

