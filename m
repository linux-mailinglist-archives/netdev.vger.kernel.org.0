Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C6952707A7
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 22:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbgIRU7A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 16:59:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726139AbgIRU67 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 16:58:59 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D144BC0613CE
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 13:58:59 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 00A0F15932242;
        Fri, 18 Sep 2020 13:42:11 -0700 (PDT)
Date:   Fri, 18 Sep 2020 13:58:58 -0700 (PDT)
Message-Id: <20200918.135858.1501075167621870462.davem@davemloft.net>
To:     tuong.t.lien@dektech.com.au
Cc:     jmaloy@redhat.com, maloy@donjonn.com, ying.xue@windriver.com,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net
Subject: Re: [net-next v3 0/4] tipc: add more features to TIPC encryption
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200918011729.30146-1-tuong.t.lien@dektech.com.au>
References: <20200918011729.30146-1-tuong.t.lien@dektech.com.au>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 18 Sep 2020 13:42:12 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tuong Lien <tuong.t.lien@dektech.com.au>
Date: Fri, 18 Sep 2020 08:17:25 +0700

> This series adds some new features to TIPC encryption:
> 
> - Patch 1 ("tipc: optimize key switching time and logic") optimizes the
> code and logic in preparation for the following commits.
> 
> - Patch 2 ("tipc: introduce encryption master key") introduces support
> of 'master key' for authentication of new nodes and key exchange. A
> master key can be set/changed by user via netlink (eg. using the same
> 'tipc node set key' command in iproute2/tipc).
> 
> - Patch 3 ("tipc: add automatic session key exchange") allows a session
> key to be securely exchanged between nodes as needed.
> 
> - Patch 4 ("tipc: add automatic rekeying for encryption key") adds
> automatic 'rekeying' of session keys a specific interval. The new key
> will be distributed automatically to peer nodes, so become active then.
> The rekeying interval is configurable via netlink as well.
> 
> v2: update the "tipc: add automatic session key exchange" patch to fix
> "implicit declaration" issue when built without "CONFIG_TIPC_CRYPTO".
> 
> v3: update the patches according to David comments by using the
> "genl_info->extack" for messages in response to netlink user config
> requests.

Series applied, thanks.
