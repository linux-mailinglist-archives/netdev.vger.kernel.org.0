Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 487AD2765BE
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 03:14:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726714AbgIXBOI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 21:14:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbgIXBOH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 21:14:07 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6AC6C0613D1;
        Wed, 23 Sep 2020 18:14:07 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A8193126BAF37;
        Wed, 23 Sep 2020 17:57:19 -0700 (PDT)
Date:   Wed, 23 Sep 2020 18:14:06 -0700 (PDT)
Message-Id: <20200923.181406.747857153054080876.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        vladimir.oltean@nxp.com, olteanv@gmail.com, nikolay@nvidia.com
Subject: Re: [PATCH net-next v3 0/2] net: dsa: b53: Configure VLANs while
 not filtering
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200923214038.3671566-1-f.fainelli@gmail.com>
References: <20200923214038.3671566-1-f.fainelli@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 23 Sep 2020 17:57:20 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Wed, 23 Sep 2020 14:40:36 -0700

> These two patches allow the b53 driver which always configures its CPU
> port as egress tagged to behave correctly with VLANs being always
> configured whenever a port is added to a bridge.
> 
> Vladimir provides a patch that aligns the bridge with vlan_filtering=0
> receive path to behave the same as vlan_filtering=1. Per discussion with
> Nikolay, this behavior is deemed to be too DSA specific to be done in
> the bridge proper.
> 
> This is a preliminary series for Vladimir to make
> configure_vlan_while_filtering the default behavior for all DSA drivers
> in the future.
 ...

Series applied, thanks Florian.
