Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49CE3164DDC
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 19:45:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbgBSSpA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 13:45:00 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:46198 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726613AbgBSSpA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 13:45:00 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 00BD515AD196D;
        Wed, 19 Feb 2020 10:44:59 -0800 (PST)
Date:   Wed, 19 Feb 2020 10:44:59 -0800 (PST)
Message-Id: <20200219.104459.1114218705483242564.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [pull request][net-next V4 00/13] Mellanox, mlx5 updates
 2020-01-24
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200219032205.15264-1-saeedm@mellanox.com>
References: <20200219032205.15264-1-saeedm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Feb 2020 10:45:00 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Wed, 19 Feb 2020 03:22:58 +0000

> This series adds some updates to mlx5 driver
> 1) Devlink health dump support for both rx and tx health reporters.
> 2) FEC modes supports.
> 3) two misc small patches.
> 
> V4:
>  - Resend after net-next is open and rebased
>  - Added Reviewed-by: Andrew Lunn, to the ethtool patch
> 
> V3: 
>  - Improve ethtool patch "FEC LLRS" commit message as requested by
>    Andrew Lunn.
>  - Since we've missed the last cycle, dropped two small fixes patches,
>    as they should go to net now.
> 
> V2:
>  - Remove "\n" from snprintf, happened due to rebase with a conflicting
>    feature, Thanks Joe for spotting this.
> 
> For more information please see tag log below.
> 
> Please pull and let me know if there is any problem.
> 
> Note about non-mlx5 change:
> For the FEC link modes support, Aya added the define for
> low latency Reed Solomon FEC as LLRS, in: include/uapi/linux/ethtool.h

Pulled, thank you.
