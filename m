Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E689226E994
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 01:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726192AbgIQXnt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 19:43:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726104AbgIQXnt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 19:43:49 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C27BC06174A;
        Thu, 17 Sep 2020 16:43:49 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8878713662ADD;
        Thu, 17 Sep 2020 16:27:01 -0700 (PDT)
Date:   Thu, 17 Sep 2020 16:43:47 -0700 (PDT)
Message-Id: <20200917.164347.604470783719487724.davem@davemloft.net>
To:     mkubecek@suse.cz
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] ethtool: add and use message type for tunnel info
 reply
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200916230410.34FCE6074F@lion.mk-sys.cz>
References: <20200916230410.34FCE6074F@lion.mk-sys.cz>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 17 Sep 2020 16:27:01 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Kubecek <mkubecek@suse.cz>
Date: Thu, 17 Sep 2020 01:04:10 +0200 (CEST)

> Tunnel offload info code uses ETHTOOL_MSG_TUNNEL_INFO_GET message type (cmd
> field in genetlink header) for replies to tunnel info netlink request, i.e.
> the same value as the request have. This is a problem because we are using
> two separate enums for userspace to kernel and kernel to userspace message
> types so that this ETHTOOL_MSG_TUNNEL_INFO_GET (28) collides with
> ETHTOOL_MSG_CABLE_TEST_TDR_NTF which is what message type 28 means for
> kernel to userspace messages.
> 
> As the tunnel info request reached mainline in 5.9 merge window, we should
> still be able to fix the reply message type without breaking backward
> compatibility.
> 
> Fixes: c7d759eb7b12 ("ethtool: add tunnel info interface")
> Signed-off-by: Michal Kubecek <mkubecek@suse.cz>

Applied, thank you.
