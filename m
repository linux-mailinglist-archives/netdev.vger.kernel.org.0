Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C7E921BEC7
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 22:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727873AbgGJUyv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 16:54:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726832AbgGJUyv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 16:54:51 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F9C8C08C5DC
        for <netdev@vger.kernel.org>; Fri, 10 Jul 2020 13:54:51 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 76B4B12864334;
        Fri, 10 Jul 2020 13:54:50 -0700 (PDT)
Date:   Fri, 10 Jul 2020 13:54:49 -0700 (PDT)
Message-Id: <20200710.135449.2226923391986349797.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     netdev@vger.kernel.org, saeedm@mellanox.com,
        michael.chan@broadcom.com, emil.s.tantilov@intel.com,
        alexander.h.duyck@linux.intel.com, jeffrey.t.kirsher@intel.com,
        tariqt@mellanox.com, mkubecek@suse.cz
Subject: Re: [PATCH net-next v4 00/10] udp_tunnel: add NIC RX port offload
 infrastructure
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200710004253.211130-1-kuba@kernel.org>
References: <20200710004253.211130-1-kuba@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 10 Jul 2020 13:54:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Thu,  9 Jul 2020 17:42:43 -0700

 ...
> This work tries to improve the situation by pulling the UDP tunnel
> port table maintenance out of the drivers. It turns out that almost
> all drivers maintain a fixed size table of ports (in most cases one
> per tunnel type), so we can take care of all the refcounting in the
> core, and let the driver specify if they need to sleep in the
> callbacks or not. The new common implementation will also support
> replacing ports - when a port is removed from a full table it will
> try to find a previously missing port to take its place.
> 
> This patch only implements the core functionality along with a few
> drivers I was hoping to test manually [1] along with a test based
> on a netdevsim implementation. Following patches will convert all
> the drivers. Once that's complete we can remove the ndos, and rely
> directly on the new infrastrucutre.
> 
> Then after RSS (RXFH) is converted to netlink we can add the ability
> to configure the use of inner RSS headers for UDP tunnels.
 ...

Series applied, thanks Jakub.
