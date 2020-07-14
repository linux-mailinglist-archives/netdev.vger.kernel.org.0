Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D95121E481
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 02:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726782AbgGNAaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 20:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726347AbgGNAaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 20:30:23 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBA30C061755
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 17:30:23 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 32B03129835B0;
        Mon, 13 Jul 2020 17:30:23 -0700 (PDT)
Date:   Mon, 13 Jul 2020 17:30:22 -0700 (PDT)
Message-Id: <20200713.173022.1980178714052891828.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, jiri@mellanox.com,
        moshe@mellanox.com, vladyslavt@mellanox.com, cai@lca.pw,
        mlxsw@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH net-next] devlink: Fix use-after-free when destroying
 health reporters
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200713152014.244936-1-idosch@idosch.org>
References: <20200713152014.244936-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 13 Jul 2020 17:30:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Mon, 13 Jul 2020 18:20:14 +0300

> From: Ido Schimmel <idosch@mellanox.com>
> 
> Dereferencing the reporter after it was destroyed in order to unlock the
> reporters lock results in a use-after-free [1].
> 
> Fix this by storing a pointer to the lock in a local variable before
> destroying the reporter.
> 
> [1]
 ...
> Fixes: 3c5584bf0a04 ("devlink: Rework devlink health reporter destructor")
> Fixes: 15c724b997a8 ("devlink: Add devlink health port reporters API")
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>

Applied to net-next, thanks.
