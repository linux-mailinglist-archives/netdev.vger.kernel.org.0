Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6159E5AA618
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 05:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232291AbiIBDAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 23:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231954AbiIBDAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 23:00:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 503B53054A;
        Thu,  1 Sep 2022 20:00:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 43DE9B8293A;
        Fri,  2 Sep 2022 03:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96895C433D6;
        Fri,  2 Sep 2022 03:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662087613;
        bh=PoPwHcQNI9n8w+O1e60egWulhTBWawW7kWOj4rVuQJY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kDGq+XroNyK4SIYBk4LdaJZ5N0/XBQc2qaeZFnRhHgKYkcS0vRPsBnFL3fs9ZLaze
         CTzV3/NwEKSH9GErr4z2BfwTpQ7bX5VIseIYl//ThuMcnakEffDIC6viqfNL1OjTTp
         NTdkNS2WR0fOwRlGBcltv8sfme9Vkaw+BvDyzXyaMLx2xVEG7fNLUfwwWzIie3E4Ft
         GgOURI/IRtwpNHHsUwbdD1PbMToHKcoFlfwT7RdeiemsvVLhvqqHioQNvQAgo/Um/K
         ZiD9jX89dFdlPWxlpzyZHEqQUTPWbQe6gCU9qf+aiCffnig4bhYTZ0WoT7zTFqlX2k
         OnhGM1pZ3iAeQ==
Date:   Thu, 1 Sep 2022 20:00:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Aring <aahringo@redhat.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Alexander Aring <alex.aring@gmail.com>,
        Gal Pressman <gal@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>
Subject: Re: [PATCH net-next] net: ieee802154: Fix compilation error when
 CONFIG_IEEE802154_NL802154_EXPERIMENTAL is disabled
Message-ID: <20220901200012.6f04466e@kernel.org>
In-Reply-To: <CAK-6q+gtcDVCGB0KvhMjQ-WotWuyL7mpw99-36j_TcC7mc2qyA@mail.gmail.com>
References: <20220830101237.22782-1-gal@nvidia.com>
        <20220830231330.1c618258@kernel.org>
        <4187e35d-0965-cf65-bff5-e4f71a04d272@nvidia.com>
        <20220830233124.2770ffc2@kernel.org>
        <20220831112150.36e503bd@kernel.org>
        <36f09967-b211-ef48-7360-b6dedfda73e3@datenfreihafen.org>
        <20220831140947.7e8d06ee@kernel.org>
        <YxBTaxMmHKiLjcCo@unreal>
        <20220901132338.2953518c@kernel.org>
        <CAK-6q+gtcDVCGB0KvhMjQ-WotWuyL7mpw99-36j_TcC7mc2qyA@mail.gmail.com>
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

On Thu, 1 Sep 2022 22:48:10 -0400 Alexander Aring wrote:
> > You're right, FWIW. I didn't want to get sidetracked into that before
> > we fix the immediate build issue. It's not the only family playing uAPI
> > games :(
> 
> I am not sure how to proceed here now, if removing the
> CONFIG_IEEE802154_NL802154_EXPERIMENTAL option is the way to go. Then
> do it?

Right, I was kinda expecting v2 from Gal but the weekend may have
started for him already, so let me send it myself.
