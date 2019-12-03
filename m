Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6203110504
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 20:25:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727321AbfLCTZ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 14:25:27 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:51772 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726932AbfLCTZ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 14:25:26 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3F26515103719;
        Tue,  3 Dec 2019 11:25:26 -0800 (PST)
Date:   Tue, 03 Dec 2019 11:25:25 -0800 (PST)
Message-Id: <20191203.112525.1355112486657071939.davem@davemloft.net>
To:     leon@kernel.org
Cc:     dsahern@gmail.com, danitg@mellanox.com, netdev@vger.kernel.org,
        leonro@mellanox.com
Subject: Re: [PATCH net] net/core: Populate VF index in struct ifla_vf_guid
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191203154337.42422-1-leon@kernel.org>
References: <20191203154337.42422-1-leon@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 03 Dec 2019 11:25:26 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leon@kernel.org>
Date: Tue,  3 Dec 2019 17:43:36 +0200

> From: Danit Goldberg <danitg@mellanox.com>
> 
> In addition to filling the node_guid and port_guid attributes,
> there is a need to populate VF index too, otherwise users of netlink
> interface will see same VF index for all VFs.
> 
> Fixes: 30aad41721e0 ("net/core: Add support for getting VF GUIDs")
> Signed-off-by: Danit Goldberg <danitg@mellanox.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>

Applied, thank you.
