Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B40E27930B
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 23:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727895AbgIYVMf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 17:12:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726119AbgIYVMf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 17:12:35 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9523EC0613CE;
        Fri, 25 Sep 2020 14:12:35 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8CF1113B70158;
        Fri, 25 Sep 2020 13:55:47 -0700 (PDT)
Date:   Fri, 25 Sep 2020 14:12:34 -0700 (PDT)
Message-Id: <20200925.141234.274433220362171981.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     netdev@vger.kernel.org, olteanv@gmail.com, vladimir.oltean@nxp.com,
        kuba@kernel.org, ap420073@gmail.com, edumazet@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2] net: vlan: Avoid using BUG() in
 vlan_proto_idx()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200925002746.79571-1-f.fainelli@gmail.com>
References: <20200925002746.79571-1-f.fainelli@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 25 Sep 2020 13:55:47 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Thu, 24 Sep 2020 17:27:44 -0700

> While we should always make sure that we specify a valid VLAN protocol
> to vlan_proto_idx(), killing the machine when an invalid value is
> specified is too harsh and not helpful for debugging. All callers are
> capable of dealing with an error returned by vlan_proto_idx() so check
> the index value and propagate it accordingly.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
> Changes in v2:
> - changed signature to return int
> - changed message to use ntohs()
> - renamed an index variable to 'pidx' instead of 'pdix'

Applied, thanks Florian.
