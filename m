Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA867282DCB
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 23:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726398AbgJDVjO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 17:39:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726313AbgJDVjO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Oct 2020 17:39:14 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03A5DC0613CE
        for <netdev@vger.kernel.org>; Sun,  4 Oct 2020 14:39:13 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6BA131277F7EF;
        Sun,  4 Oct 2020 14:22:25 -0700 (PDT)
Date:   Sun, 04 Oct 2020 14:39:12 -0700 (PDT)
Message-Id: <20201004.143912.1339042847829123816.davem@davemloft.net>
To:     andrew@lunn.ch
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com,
        vladimir.oltean@nxp.com, jiri@nvidia.com, kuba@kernel.org
Subject: Re: [PATCH net-next v3 0/7] mv88e6xxx: Add per port devlink regions
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201004161257.13945-1-andrew@lunn.ch>
References: <20201004161257.13945-1-andrew@lunn.ch>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Sun, 04 Oct 2020 14:22:25 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Sun,  4 Oct 2020 18:12:50 +0200

> This patchset extends devlink regions to support per port regions, and
> them makes use of them to support the ports of the mv88e6xxx switches.
 ...

Series applied, thanks!
