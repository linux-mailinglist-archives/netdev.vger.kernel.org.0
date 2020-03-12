Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0459183BE7
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 23:06:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbgCLWGE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 18:06:04 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35560 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726514AbgCLWGE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 18:06:04 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 922C415825FF4;
        Thu, 12 Mar 2020 15:06:03 -0700 (PDT)
Date:   Thu, 12 Mar 2020 15:06:00 -0700 (PDT)
Message-Id: <20200312.150600.667394309882963148.davem@davemloft.net>
To:     paulb@mellanox.com
Cc:     saeedm@mellanox.com, ozsh@mellanox.com,
        jakub.kicinski@netronome.com, vladbu@mellanox.com,
        netdev@vger.kernel.org, jiri@mellanox.com, roid@mellanox.com
Subject: Re: [PATCH net-next ct-offload v4 00/15] Introduce connection
 tracking offload
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1584008597-15875-1-git-send-email-paulb@mellanox.com>
References: <1584008597-15875-1-git-send-email-paulb@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 12 Mar 2020 15:06:03 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@mellanox.com>
Date: Thu, 12 Mar 2020 12:23:02 +0200

 ...
> Applying this patchset
> --------------------------
> 
> On top of current net-next ("r8169: simplify getting stats by using netdev_stats_to_stats64"),
> pull Saeed's ct-offload branch, from git git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git
> and fix the following non trivial conflict in fs_core.c as follows:
> #define OFFLOADS_MAX_FT 2
> #define OFFLOADS_NUM_PRIOS 2
> #define OFFLOADS_MIN_LEVEL (ANCHOR_MIN_LEVEL + OFFLOADS_NUM_PRIOS)

Done.

> Then apply this patchset.
> 
> Changelog:
>   v2->v3:
>     Added the first two patches needed after rebasing on net-next:
>      "net/mlx5: E-Switch, Enable reg c1 loopback when possible"
>      "net/mlx5e: en_rep: Create uplink rep root table after eswitch offloads table"

Applied and queued up for -stable.
