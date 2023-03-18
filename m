Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 379856BF7BA
	for <lists+netdev@lfdr.de>; Sat, 18 Mar 2023 05:24:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbjCREYk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Mar 2023 00:24:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjCREYj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Mar 2023 00:24:39 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ECAD41B52
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 21:24:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 151C7CE08CC
        for <netdev@vger.kernel.org>; Sat, 18 Mar 2023 04:24:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49D07C4339B;
        Sat, 18 Mar 2023 04:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679113474;
        bh=YgMdpPrpkP5RNhwSaVy4MZQCxA2r+EBkSJWitSTOcMs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WEtVCH840H/MEPEPlFkSmzpLENJ46bvrFL084WhNPZlBD6M6eOy3K5cY3WL+orGaU
         zYQhHdnx08OV/8QouNxa/GMZa/kXBH0deAdrvde8SXMeDPWRaRDVlG7YM64O/MzSUs
         CUV1GcWxlu90NWMB1m9d1tyi74UYwNuZzjrQp4N51tvMWPrFNLwj9yO7sImHr8O6Kk
         5ajMK3LfdUW49MJpaG2LiLXeQo4RNVqdf1tvs3VQel6GHoEECZFrEfBZIBOY7PsO+c
         pABaOIhETPQJnxFbNJX5XWGTd+6gUrBY8jXpUHv/bjzpcV/8kwzk0pCmMX/iIMeauc
         HKHhNabCushxw==
Date:   Fri, 17 Mar 2023 21:24:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com
Subject: Re: [PATCH net-next 4/4] ynl: ethtool testing tool
Message-ID: <20230317212433.4d777672@kernel.org>
In-Reply-To: <20230318002340.1306356-5-sdf@google.com>
References: <20230318002340.1306356-1-sdf@google.com>
        <20230318002340.1306356-5-sdf@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 17 Mar 2023 17:23:40 -0700 Stanislav Fomichev wrote:
> $ ethtool enp0s31f6
> Settings for enp0s31f6:
> 	Supported ports: [ TP ]
> 	Supported link modes:   10baseT/Half 10baseT/Full
> 	                        100baseT/Half 100baseT/Full
> 	                        1000baseT/Full
> 	Supported pause frame use: No
> 	Supports auto-negotiation: Yes
> 	Supported FEC modes: Not reported
> 	Advertised link modes:  10baseT/Half 10baseT/Full
> 	                        100baseT/Half 100baseT/Full
> 	                        1000baseT/Full
> 	Advertised pause frame use: No
> 	Advertised auto-negotiation: Yes
> 	Advertised FEC modes: Not reported
> 	Speed: Unknown!
> 	Duplex: Unknown! (255)
> 	Auto-negotiation: on
> 	Port: Twisted Pair
> 	PHYAD: 2
> 	Transceiver: internal
> 	MDI-X: Unknown (auto)
> netlink error: Operation not permitted
>         Current message level: 0x00000007 (7)
>                                drv probe link
> 	Link detected: no

Quite impressive BTW :)
