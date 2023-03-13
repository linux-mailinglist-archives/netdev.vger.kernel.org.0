Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 575376B819D
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 20:20:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231226AbjCMTUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 15:20:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231335AbjCMTTg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 15:19:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DB216EA3;
        Mon, 13 Mar 2023 12:19:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D5CE61291;
        Mon, 13 Mar 2023 19:18:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70C29C433EF;
        Mon, 13 Mar 2023 19:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678735114;
        bh=yasZ4aX1hL1e3cTm0fi5rz3GeesnBxAdJe+hvx0twkI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Kq2a4aWaXFuhi0vkcQnXu86e8jtKTY3vBoUkiRziS8410fJIQIzsdfhpyd7zXyZdx
         oPU8BE91jloPCXc6US4ahEfHICl/zOT+wTYT5WEcek5U87sNwGWHB4Xb/S8einD+Fu
         lxXMlqAf6sHgX8nwv2oV4KaE2N+jIaO3k5u9Jrmd92ptYGv6cJimTTe2pffmIrZYiD
         NAlCpKr9Z+5b1d2M9K3Zbt+/TQ+kMD8Y4Erjf8T1RDPbEZTSGvVpMZNGADn7WZoH64
         jSJayLD//R3y6jC7Xfaz91sH3zkN9cFBEmAvJ4MP+50LPOyfYICszmRTNIt0Kv64+3
         w8Mm+LQ+R+SUQ==
Date:   Mon, 13 Mar 2023 12:18:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next v2 0/2] net: dsa: microchip: tc-ets support
Message-ID: <20230313121833.1942244e@kernel.org>
In-Reply-To: <20230310090809.220764-1-o.rempel@pengutronix.de>
References: <20230310090809.220764-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Mar 2023 10:08:07 +0100 Oleksij Rempel wrote:
> changes v3:
> - add tc_ets_supported to match supported devices
> - dynamically regenerated default TC to queue map.
> - add Acked-by to the first patch
> 
> changes v2:
> - run egress limit configuration on all queue separately. Otherwise
>   configuration may not apply correctly.

I thought Vladimir was suggesting mqprio, could you summarize the take
aways from that discussion?
