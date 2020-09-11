Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06BCA266A4A
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 23:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725856AbgIKVub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 17:50:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725847AbgIKVu2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 17:50:28 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79B6CC061573
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 14:50:28 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 457041366B446;
        Fri, 11 Sep 2020 14:33:40 -0700 (PDT)
Date:   Fri, 11 Sep 2020 14:50:25 -0700 (PDT)
Message-Id: <20200911.145025.2133088801719324101.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        kuba@kernel.org, roopa@nvidia.com, nikolay@nvidia.com,
        jiri@nvidia.com, mlxsw@nvidia.com, idosch@nvidia.com
Subject: Re: [PATCH net-next] bridge: mcast: Fix incomplete MDB dump
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200911132447.3158141-1-idosch@idosch.org>
References: <20200911132447.3158141-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 11 Sep 2020 14:33:40 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Fri, 11 Sep 2020 16:24:47 +0300

> From: Ido Schimmel <idosch@nvidia.com>
> 
> Each MDB entry is encoded in a nested netlink attribute called
> 'MDBA_MDB_ENTRY'. In turn, this attribute contains another nested
> attributed called 'MDBA_MDB_ENTRY_INFO', which encodes a single port
> group entry within the MDB entry.
> 
> The cited commit added the ability to restart a dump from a specific
> port group entry. However, on failure to add a port group entry to the
> dump the entire MDB entry (stored in 'nest2') is removed, resulting in
> missing port group entries.
> 
> Fix this by finalizing the MDB entry with the partial list of already
> encoded port group entries.
> 
> Fixes: 5205e919c9f0 ("net: bridge: mcast: add support for src list and filter mode dumping")
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>

Applied, thank you.
