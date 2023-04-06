Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD6E6D8D43
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 04:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234076AbjDFCIm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 22:08:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231441AbjDFCIk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 22:08:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E94CF49F9
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 19:08:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8386C62952
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 02:08:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92234C433D2;
        Thu,  6 Apr 2023 02:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680746918;
        bh=XyFRwOf5oRu/E/k6qrUZmaC15dFmf5/HGuEqX8Mfl3U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YGCLjFwT1+DgiGNUUx6kbg1Q9TBS8zzOFqD2ZleLj/lQdWZWBBNWQKMsgOG2Iq37X
         b65E5bOKaL5yyUeSBxo2pEHawQAjNEe9oOlcUt05dFkpbah/1pcfDHe9/8s5Px2v4L
         PvZZNf8dI1Jw3K5lyBURouBxES3uOhGHMLt+sGfCD9uGT3mPLxONLEZoE/wxGEXTjD
         bMNmqfoRdQrXW8/Dm8XTyjcmOSg+C/MqZLGK94AjQrS31rvl4a1JtOG+0Ags+MI5Ky
         GYqY5scQLCIkEdsaoTAGjlvAnVPWCPAk4w92qjpDZL3O4zjHQCWfAjoXbKaIQyg6Db
         VrgbIT5D1oSdw==
Date:   Wed, 5 Apr 2023 19:08:37 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [RFC PATCH net-next] net: dsa: replace
 NETDEV_PRE_CHANGE_HWTSTAMP notifier with a stub
Message-ID: <20230405190837.3cbbc449@kernel.org>
In-Reply-To: <20230405165115.3744445-1-vladimir.oltean@nxp.com>
References: <20230405165115.3744445-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  5 Apr 2023 19:51:15 +0300 Vladimir Oltean wrote:
> There have been objections from Jakub Kicinski that using notifiers in
> general when they are not absolutely necessary creates complications to
> the control flow and difficulties to maintainers who look at the code.
> So there is a desire to not use notifiers.

LGTM, thank you!
