Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F7D45E6BB2
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 21:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbiIVTab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 15:30:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiIVTaa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 15:30:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF9B0796B0
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 12:30:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 59A31637A7
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 19:30:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57FBAC433D7;
        Thu, 22 Sep 2022 19:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663875028;
        bh=7kck3UGGvaihTEB/w9UIYjvIuCdA3lnl0As+UDBEuHY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=H+Y5VKA/8q4VuSWJ+Wi8+9Ex20DhBmxpshBnWDJm/YU5qtQYDWcvYIB/YIH8SZ0Po
         UiK1gppLegkEZ2PRFQPzSX6Yv9w8FsbWRXZTBdlAFoSCLC4fJvguJjEKB2eMA1owMg
         MBj8FPYR9cQPVNOiJAJ2FBvDkng9WaJpBKszBC0+2QCYLj9fj+3iUxY33W9yjSk+d5
         dF4W3crNOnLkd1ScD5s2Q4YShtOQcXBJROc752In46HFs8IUsdtX0CtOluuLBlD1+f
         oeYbVNCP1KH2Kup2mvPlvVe2tOheMGskLuSKs/B7Ev1vqoiNkjpy0+ckEUOVWl6RoJ
         WcbFlUxDOgLqg==
Date:   Thu, 22 Sep 2022 12:30:27 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH v2 iproute2-next] ip link: add sub-command to view and
 change DSA master
Message-ID: <20220922123027.74abaaa9@kernel.org>
In-Reply-To: <20220922180051.qo6swrvz2gqwgtlp@skbuf>
References: <20220921165105.1737200-1-vladimir.oltean@nxp.com>
        <20220921113637.73a2f383@hermes.local>
        <20220921183827.gkmzula73qr4afwg@skbuf>
        <20220921154107.61399763@hermes.local>
        <Yyu6w8Ovq2/aqzBc@lunn.ch>
        <20220922062405.15837cfe@kernel.org>
        <20220922180051.qo6swrvz2gqwgtlp@skbuf>
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

On Thu, 22 Sep 2022 18:00:52 +0000 Vladimir Oltean wrote:
> As for via, I didn't even know that this had a serious use in English as
> a noun, other than the very specific term for PCB design. I find it
> pretty hard to use in speech: "the via interface does this or that".

Maybe it's a stretch but I meant it as a parallel to next-hops 
in routing.

 ip route add 10.0.0.0/24 via 192.168.0.1 dev eth1
                          ^^^
