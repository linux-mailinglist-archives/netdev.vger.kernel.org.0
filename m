Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 553C99724F
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 08:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728019AbfHUGgv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 02:36:51 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:58236 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727841AbfHUGgv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 02:36:51 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E160E15061485;
        Tue, 20 Aug 2019 23:36:50 -0700 (PDT)
Date:   Tue, 20 Aug 2019 23:36:48 -0700 (PDT)
Message-Id: <20190820.233648.871541755175605072.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     netdev@vger.kernel.org
Subject: Re: [pull request][net-next v2 00/16] Mellanox, mlx5 devlink RX
 health reporters
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190820202352.2995-1-saeedm@mellanox.com>
References: <20190820202352.2995-1-saeedm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 20 Aug 2019 23:36:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Tue, 20 Aug 2019 20:24:10 +0000

> This series is adding a new devlink health reporter for RX related
> errors from Aya.
> 
> Last two patches from Vlad and Gavi, are trivial fixes for previously
> submitted patches on this release cycle.
> 
> v1->v2:
>  - Improve reversed xmas tree variable declaration.
>  - Rebase on top of net-next to avoid a new conflict due to latest 
>    merge with net.
> 
> For more information please see tag log below.
> 
> Please pull and let me know if there is any problem.

Pulled, thanks Saeed.
