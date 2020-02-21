Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30494168A7C
	for <lists+netdev@lfdr.de>; Sat, 22 Feb 2020 00:46:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729309AbgBUXqg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 18:46:36 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:42514 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726802AbgBUXqg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 18:46:36 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CAD23158261AD;
        Fri, 21 Feb 2020 15:46:35 -0800 (PST)
Date:   Fri, 21 Feb 2020 15:46:35 -0800 (PST)
Message-Id: <20200221.154635.692434123240057337.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next V2 0/7] mlxfw: Improve error reporting and FW
 reactivate support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200221214536.20265-1-saeedm@mellanox.com>
References: <20200221214536.20265-1-saeedm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 21 Feb 2020 15:46:35 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Fri, 21 Feb 2020 21:45:56 +0000

> This patchset improves mlxfw error reporting to netlink and to
> kernel log.
> 
> V2:
>  - Use proper err codes, EBUSY/EIO instead of EALREADY/EREMOTEIO
>  - Fix typo.
> 
> From Eran and me.
> 
> 1) patch #1, Make mlxfw/mlxsw fw flash devlink status notify generic,
>    and enable it for mlx5.
> 
> 2) patches #2..#5 are improving mlxfw flash error messages by
> reporting detailed mlxfw FSM error messages to netlink and kernel log.
> 
> 3) patches #6,7 From Eran: Add FW reactivate flow to  mlxfw and mlx5

Series applied, thanks.
