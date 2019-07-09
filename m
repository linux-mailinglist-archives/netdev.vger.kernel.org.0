Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92BCC63D8A
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 23:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729220AbfGIVuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 17:50:14 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46238 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729019AbfGIVuN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 17:50:13 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 14E5914255ECD;
        Tue,  9 Jul 2019 14:50:13 -0700 (PDT)
Date:   Tue, 09 Jul 2019 14:50:12 -0700 (PDT)
Message-Id: <20190709.145012.1314139094883979747.davem@davemloft.net>
To:     vivien.didelot@gmail.com
Cc:     netdev@vger.kernel.org, linux@armlinux.org.uk,
        f.fainelli@gmail.com, idosch@mellanox.com, andrew@lunn.ch
Subject: Re: [PATCH net-next] net: dsa: add support for BRIDGE_MROUTER
 attribute
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190709033113.8837-1-vivien.didelot@gmail.com>
References: <20190709033113.8837-1-vivien.didelot@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 09 Jul 2019 14:50:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vivien Didelot <vivien.didelot@gmail.com>
Date: Mon,  8 Jul 2019 23:31:13 -0400

> This patch adds support for enabling or disabling the flooding of
> unknown multicast traffic on the CPU ports, depending on the value
> of the switchdev SWITCHDEV_ATTR_ID_BRIDGE_MROUTER attribute.
> 
> The current behavior is kept unchanged but a user can now prevent
> the CPU conduit to be flooded with a lot of unregistered traffic that
> the network stack needs to filter in software with e.g.:
> 
>     echo 0 > /sys/class/net/br0/multicast_router
> 
> Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>

Looks very reasonable and straightforward.

Applied, thanks.
