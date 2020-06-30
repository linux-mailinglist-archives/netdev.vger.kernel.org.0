Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E75C620EA29
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 02:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbgF3AYt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 20:24:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726065AbgF3AYt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 20:24:49 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC4B1C061755
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 17:24:48 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3C8C5127BE225;
        Mon, 29 Jun 2020 17:24:48 -0700 (PDT)
Date:   Mon, 29 Jun 2020 17:24:47 -0700 (PDT)
Message-Id: <20200629.172447.1129902296805016837.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [pull request][net-next 00/15] mlx5 tls rx offload 2020-06-26
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200627211727.259569-1-saeedm@mellanox.com>
References: <20200627211727.259569-1-saeedm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 29 Jun 2020 17:24:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Sat, 27 Jun 2020 14:17:12 -0700

> This is a re-spin of the previous kernel cycle mlx5 rx tls submission, From Tariq
> and Boris.
> 
> Changes from previous iteration:
> 1) Better handling of error flows in the resyc procedure.
> 2) An improved TLS device API for Asynchronous Resync to replace "force resync"
> For this Tariq and Boris revert the old "force resync" API then add the new one,
> patch: ('Revert "net/tls: Add force_resync for driver resync"')
> Since there are no users for the "force resync" API it might be a good idea to also
> take this patch to net.
> 
> For more information please see tag log below.
> 
> Please pull and let me know if there is any problem.
> 
> Please note that the series starts with a merge of mlx5-next branch,
> to resolve and avoid dependency with rdma tree.

Pulled, thanks Saeed.
