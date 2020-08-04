Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CA7623B240
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 03:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729028AbgHDBYx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 21:24:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbgHDBYx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 21:24:53 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14337C06174A
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 18:24:53 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4740A1278B06D;
        Mon,  3 Aug 2020 18:08:07 -0700 (PDT)
Date:   Mon, 03 Aug 2020 18:24:52 -0700 (PDT)
Message-Id: <20200803.182452.945111224129612591.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [pull request][net-next 0/5] Mellanox, mlx5 updates 2020-08-03
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200803204151.120802-1-saeedm@mellanox.com>
References: <20200803204151.120802-1-saeedm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 03 Aug 2020 18:08:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Mon,  3 Aug 2020 13:41:46 -0700

> This patchset adds misc updates to mlx5.
> 
> Please note there is one non-mlx5 patch from Jakub that adds support
> for static vxlan port configuration in udp tunnel infrastructure.
> 
> For more information please see tag log below.
> 
> Please pull and let me know if there is any problem.

Pulled, thanks Saeed.
