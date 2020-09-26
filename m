Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE4EA279C98
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 23:19:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbgIZVSW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 17:18:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726382AbgIZVSW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Sep 2020 17:18:22 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9AD4C0613CE
        for <netdev@vger.kernel.org>; Sat, 26 Sep 2020 14:18:22 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 84EB811924EB4;
        Sat, 26 Sep 2020 14:01:33 -0700 (PDT)
Date:   Sat, 26 Sep 2020 14:18:18 -0700 (PDT)
Message-Id: <20200926.141818.1170749837743709005.davem@davemloft.net>
To:     vladimir.oltean@nxp.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, kuba@kernel.org
Subject: Re: [PATCH v3 net-next 00/15] Generic adjustment for flow
 dissector in DSA
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200926193215.1405730-1-vladimir.oltean@nxp.com>
References: <20200926193215.1405730-1-vladimir.oltean@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Sat, 26 Sep 2020 14:01:33 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Sat, 26 Sep 2020 22:32:00 +0300

> This is the v2 of a series initially submitted in May:
> https://www.spinics.net/lists/netdev/msg651866.html
> 
> The end goal is to get rid of the unintuitive code for the flow
> dissector that currently exists in the taggers. It can all be replaced
> by a single, common function.
> 
> Some background work needs to be done for that. Especially the ocelot
> driver poses some problems, since it has a different tag length between
> RX and TX, and I didn't want to make DSA aware of that, since I could
> instead make the tag lengths equal.
> 
> Changes in v3:
> - Added an optimization (08/15) that makes the generic case not need to
>   call the .flow_dissect function pointer. Basically .flow_dissect now
>   currently only exists for sja1105.
> - Moved the .promisc_on_master property to the tagger structure.
> - Added the .tail_tag property to the tagger structure.
> - Disabled "suppresscc = all" from my .gitconfig.

Series applied, thank you.
