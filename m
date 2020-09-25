Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 369642794D2
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 01:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729093AbgIYXgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 19:36:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbgIYXgl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 19:36:41 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38886C0613CE
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 16:36:41 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EC86013BA072E;
        Fri, 25 Sep 2020 16:19:52 -0700 (PDT)
Date:   Fri, 25 Sep 2020 16:35:47 -0700 (PDT)
Message-Id: <20200925.163547.944973718417846136.davem@davemloft.net>
To:     vladimir.oltean@nxp.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, kuba@kernel.org, cphealy@gmail.com,
        jiri@nvidia.com
Subject: Re: [PATCH v2 net-next 0/3] Devlink regions for SJA1105 DSA driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200925230421.711991-1-vladimir.oltean@nxp.com>
References: <20200925230421.711991-1-vladimir.oltean@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 25 Sep 2020 16:19:53 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Sat, 26 Sep 2020 02:04:18 +0300

> This series exposes the SJA1105 static config as a devlink region. This
> can be used for debugging, for example with the sja1105_dump user space
> program that I have derived from Andrew Lunn's mv88e6xxx_dump:
> 
> https://github.com/vladimiroltean/mv88e6xxx_dump/tree/sja1105
> 
> Changes in v2:
> - Tear down devlink params on initialization failure.
> - Add driver identification through devlink.

Looks good, series applied, thanks!
