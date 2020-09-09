Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD392263877
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 23:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729824AbgIIV3S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 17:29:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726426AbgIIV3S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 17:29:18 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EDC8C061573;
        Wed,  9 Sep 2020 14:29:17 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2169C1298AC26;
        Wed,  9 Sep 2020 14:12:30 -0700 (PDT)
Date:   Wed, 09 Sep 2020 14:29:16 -0700 (PDT)
Message-Id: <20200909.142916.472512614395323672.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     netdev@vger.kernel.org, olteanv@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, kuba@kernel.org, linux@armlinux.org.uk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2] net: dsa: b53: Report VLAN table occupancy
 via devlink
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200909174932.4138500-1-f.fainelli@gmail.com>
References: <20200909174932.4138500-1-f.fainelli@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 09 Sep 2020 14:12:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Wed,  9 Sep 2020 10:49:31 -0700

> We already maintain an array of VLANs used by the switch so we can
> simply iterate over it to report the occupancy via devlink.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Applied.
