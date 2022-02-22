Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E1504C0582
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 00:47:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236331AbiBVXsF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 18:48:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236330AbiBVXsA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 18:48:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BF314B1F3
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 15:47:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E800560E07
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 23:47:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29501C340E8;
        Tue, 22 Feb 2022 23:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645573653;
        bh=di3FRY+xUxnpeDAATlmtMU0IgJaYiiI7Bf4wfjAKqYQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=D8sU/GoKD2kGzsP+rZ/sxY9Fm6q5lMFST4+nORZ97gRVo1MgUr3/lRs14I7VZIMiZ
         99xh1Gy7h1C8vJNToa1+UI0/6UMw0Ox2kGflzGOGi2VsMQMDwiG4TMg7b4aRI7cvLD
         GP9rZdrzzeBuAJvW1jxefzBeIfISQtH0gBa6VbiagMams3AeLBAcmhssVUwZJuoxNr
         FKzyatW1Xa8e5tov3EQYsH3mF7VRUYMfcbXyK1B3JeWzOsNoTBk3X1xCcZ6Vo8buSC
         Wnrgh7OPpz7UBa+FPmxNnGTFJ8x2gnB6MCwHbmEwCReSSMpZhxQVcSWGtmcQ8WJ6Bj
         BHvigasTDG54Q==
Date:   Tue, 22 Feb 2022 15:47:32 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Casper Andersson <casper.casan@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2] net: sparx5: Support offloading of bridge
 port flooding flags
Message-ID: <20220222154732.48ec5cee@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220222143525.ubtovkknjxfiflij@wse-c0155>
References: <20220222143525.ubtovkknjxfiflij@wse-c0155>
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

On Tue, 22 Feb 2022 15:35:25 +0100 Casper Andersson wrote:
> Though the SparX-5i can control IPv4/6 multicasts separately from non-IP
> multicasts, these are all muxed onto the bridge's BR_MCAST_FLOOD flag.
> 
> Signed-off-by: Casper Andersson <casper.casan@gmail.com>
> ---
> Since Protonmail apparently caused issues with certain email clients
> I have now switched to using gmail. Hopefully, there will be no issues
> this time.

Yup, I can see it just fine now, thanks!

> Changes in v2:
>  - Added SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS callback
