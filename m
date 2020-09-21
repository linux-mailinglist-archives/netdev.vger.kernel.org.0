Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39E43271917
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 04:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726305AbgIUCCL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 22:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbgIUCCL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Sep 2020 22:02:11 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9ABDC061755
        for <netdev@vger.kernel.org>; Sun, 20 Sep 2020 19:02:10 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AC6C413D6D6DA;
        Sun, 20 Sep 2020 18:45:19 -0700 (PDT)
Date:   Sun, 20 Sep 2020 19:02:04 -0700 (PDT)
Message-Id: <20200920.190204.372392542090417415.davem@davemloft.net>
To:     vladimir.oltean@nxp.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, idosch@idosch.org, jiri@resnulli.us,
        kurt.kanzenbach@linutronix.de, kuba@kernel.org
Subject: Re: [PATCH v2 net-next 0/9] DSA with VLAN filtering and offloading
 masters
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200921001031.3650456-1-vladimir.oltean@nxp.com>
References: <20200921001031.3650456-1-vladimir.oltean@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Sun, 20 Sep 2020 18:45:20 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Mon, 21 Sep 2020 03:10:22 +0300

> This series attempts to make DSA VLANs work in the presence of a master
> interface that is:
> - filtering, so it drops VLANs that aren't explicitly added to its
>   filter list
> - offloading, so the old assumptions in the tagging code about there
>   being a VLAN tag in the skb are not necessarily true anymore.
> 
> For more context:
> https://lore.kernel.org/netdev/20200910150738.mwhh2i6j2qgacqev@skbuf/
> 
> This probably marks the beginning of a series of patches in which DSA
> starts paying much more attention to its upper interfaces, not only for
> VLAN purposes but also for address filtering and for management of the
> CPU flooding domain. There was a comment from Florian on whether we
> could factor some of the mlxsw logic into some common functionality, but
> it doesn't look so. This seems bound to be open-coded, but frankly there
> isn't a lot to it.
> 
> Changes in v2:
> Applied Florian's cosmetic suggestion in patch 4/9.

Series applied, thanks.
