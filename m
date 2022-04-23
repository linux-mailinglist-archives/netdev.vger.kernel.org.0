Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEA1F50CBCC
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 17:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232415AbiDWPaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Apr 2022 11:30:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230421AbiDWP34 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Apr 2022 11:29:56 -0400
X-Greylist: delayed 603 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 23 Apr 2022 08:26:59 PDT
Received: from mail.nic.cz (mail.nic.cz [IPv6:2001:1488:800:400::400])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30BAB3FD80;
        Sat, 23 Apr 2022 08:26:59 -0700 (PDT)
Received: from thinkpad (unknown [172.20.6.87])
        by mail.nic.cz (Postfix) with ESMTPS id C1712151174;
        Sat, 23 Apr 2022 17:16:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1650727011; bh=G7yyshhGzRSHXweoe8ic4yqAHyyaNMWVkDQ0V+9J8wM=;
        h=Date:From:To:Cc:Subject:From;
        b=IdWzepAwbJtCULx5459eE+BQZlVWsRg2AypHcK6nMjfKawlZ/llJdHB10HbIEGh/F
         I2sGeccEP0EriD3UZrkWzzN2Kuv9wXoJv5CM1fl7L9it3oT52+LbKYyN4GViEGzCNc
         rrz8msgVNQ9waPKKGNne63uG5PIJzAcj9nUJkNPI=
Date:   Sat, 23 Apr 2022 17:16:49 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <marek.behun@nic.cz>
To:     Nathan Rossi <nathan@nathanrossi.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH 2/2] net: dsa: mv88e6xxx: Handle single-chip-address OF
 property
Message-ID: <20220423171649.73ff30d1@thinkpad>
In-Reply-To: <CA+aJhH3EtAxAKy8orC-SU8UnagBCibF3dHXrp78zfjuAzj4vUg@mail.gmail.com>
References: <20220423131427.237160-1-nathan@nathanrossi.com>
        <20220423131427.237160-2-nathan@nathanrossi.com>
        <YmQIHWL4iTS5qVIz@lunn.ch>
        <CA+aJhH3EtAxAKy8orC-SU8UnagBCibF3dHXrp78zfjuAzj4vUg@mail.gmail.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.103.4 at mail
X-Virus-Status: Clean
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>     switch0: switch0@16 {
>         compatible = "marvell,mv88e6141", "marvell,mv88e6085";

Not relevant to your problem, but the node name should be switch@16,
not switch0@16. The 0 is redundant and should not be there.

Marek
