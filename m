Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8557623F6E
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 11:07:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbiKJKH5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 05:07:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiKJKH4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 05:07:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C91376B388;
        Thu, 10 Nov 2022 02:07:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 633E460FC6;
        Thu, 10 Nov 2022 10:07:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6E8FC433D6;
        Thu, 10 Nov 2022 10:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668074874;
        bh=yKo18MLv1Kh2OixwnjVwSGYwd7sLWJ25ItPKPlgzx9I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SZtQhYDEwALzdKfsPW9YBV5e+H8QJFFrasktVwJjfy++UcpwUgIt9Uyc8w38NTEpu
         7/oCPr44PpTLNHEzHFP6W1DekXTqQpS8dhFukUUkH+c+37IS4PWHl/9L9sowcuU23l
         W3aI/G8asx0SS/0ZvjzgJMOHGelZhDMeH5ANcgZoXOmI4JV6I2hQEqzj9jl2w2JdN+
         QqoFvVoi6qkeeigQGHaiHzN2S949Ax6SJ/mYnwxWsOoRVkN+r5Z9fVelg9vLteeaG7
         T7aMd/Ba8ny/7U2Gdp4mm1b2F760qkwmz0/c4Utdl44E6UsqDMpqGEzq5jJGRWVk3L
         GzCfbeeBBPIBA==
Date:   Thu, 10 Nov 2022 12:07:43 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Veerasenareddy Burru <vburru@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lironh@marvell.com, aayarekar@marvell.com, sedara@marvell.com,
        sburla@marvell.com, linux-doc@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next 0/8] Add octeon_ep_vf driver
Message-ID: <Y2zNbwDqhnOqzc1V@unreal>
References: <20221108204209.23071-1-vburru@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108204209.23071-1-vburru@marvell.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 08, 2022 at 12:41:51PM -0800, Veerasenareddy Burru wrote:
> This driver implements networking functionality of Marvell's Octeon
> PCI Endpoint NIC VF.
> 
> This driver support following devices:
>  * Network controller: Cavium, Inc. Device b203
>  * Network controller: Cavium, Inc. Device b403
> 
> Veerasenareddy Burru (8):
>   octeon_ep_vf: Add driver framework and device initialization
>   octeon_ep_vf: add hardware configuration APIs
>   octeon_ep_vf: add VF-PF mailbox communication.
>   octeon_ep_vf: add Tx/Rx ring resource setup and cleanup
>   octeon_ep_vf: add support for ndo ops
>   octeon_ep_vf: add Tx/Rx processing and interrupt support
>   octeon_ep_vf: add ethtool support
>   octeon_ep_vf: update MAINTAINERS

You should first sort this submission.
https://lore.kernel.org/all/Y2i%2FbdCAgQa95du8@unreal/
