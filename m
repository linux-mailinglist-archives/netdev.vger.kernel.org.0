Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE1A65A1F20
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 04:52:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244891AbiHZCwy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 22:52:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbiHZCwx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 22:52:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FAB0CCE3D
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 19:52:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 22E7961E53
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 02:52:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 350C3C433D6;
        Fri, 26 Aug 2022 02:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661482371;
        bh=khs+TMotWIGHy+LjhFrP8SRc5mMLv5fL6JTBsChQvJQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XQkeYjVad24PGWWTWl4NFu2HNN73I8K05lEgw0f7j6qCiRtrDhxmSC+dIF8UFsD72
         0PTHUAg9MEG3vQbAnk22DnW90BmuIeOB8HzWIQoagqCdDIL2TV3I2aBybVxh1tYmOW
         5yd4g9yYXg/AvKUnjsfpdmyINkSwmqPXcfct6LxmZW/Z6hGPcnMLOlCSmVszbk3B95
         BzBrfq615o1yj7ItjtSweG9kYMb+xW1lL2yOhlh7b/SjFGFOSDj9+zg6RJdpSk2/mm
         dxseT/B8PfG/Jw5blEUutPTRdO+yMWkzP6E8Qu9lfHafcPq6XCEis6IwNFR5MTYE0T
         QyS+avNnhdUjg==
Date:   Thu, 25 Aug 2022 19:52:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mattias Forsblad <mattias.forsblad@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v1 2/3] dsa: mv88e6xxx: Add support for RMU in
 select switches
Message-ID: <20220825195250.1f9dbd42@kernel.org>
In-Reply-To: <20220825092629.236131-3-mattias.forsblad@gmail.com>
References: <20220825092629.236131-1-mattias.forsblad@gmail.com>
        <20220825092629.236131-3-mattias.forsblad@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Aug 2022 11:26:28 +0200 Mattias Forsblad wrote:
> Implement support for handling RMU layer 3 frames
> including receive and transmit.

clang says:

drivers/net/dsa/mv88e6xxx/rmu.c:127:17: warning: variable 'ethhdr' set but not used [-Wunused-but-set-variable]
+        unsigned char *ethhdr;
+                       ^
