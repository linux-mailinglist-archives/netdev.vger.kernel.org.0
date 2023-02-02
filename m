Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 670E6688523
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 18:13:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231894AbjBBRNR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 12:13:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231764AbjBBRNP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 12:13:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C44C131E16;
        Thu,  2 Feb 2023 09:13:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5372E61C2E;
        Thu,  2 Feb 2023 17:13:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B227C433D2;
        Thu,  2 Feb 2023 17:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675357993;
        bh=1TE7cu4BikNWDyFsQnhS0hUHbCsoZ2nQgndYweodG4g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qKyWEHJwkUO+uuhd54nyWDyRe3rVW3Zk88zWfZFJhxE/MmxmKCzW6P0xinfcL/Xnl
         FuRkNZytkEkBK2Z80gcaUvwjszeGIYBuTU2BJJrvhP2JEyC/Vp7ATkPUPHadT7yBYo
         fLx4Cs5eIAJrc8Fl9MLmLD9SY3TOBckwTA+aPvEXtknsw9xfNx9NSxeRbev27IQbLE
         CFDmYrnqISm4JE90DPRQ4WPeeug9iyMPPiovdN0JGDgn0iT+23xy4qkk9DcubnGF/k
         fvA7T4nA7JaMYHv67CJyF/Tw3Xv2XnHEv9Ipf9+KL6er290Hg7XzB2QJDxii2yFVAd
         8IO/FoGtrsGAA==
Date:   Thu, 2 Feb 2023 09:13:12 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: pull-request: mlx5-next 2023-01-24 V2
Message-ID: <20230202091312.578aeb03@kernel.org>
In-Reply-To: <Y9tqQ0RgUtDhiVsH@unreal>
References: <20230126230815.224239-1-saeed@kernel.org>
        <Y9tqQ0RgUtDhiVsH@unreal>
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

On Thu, 2 Feb 2023 09:46:11 +0200 Leon Romanovsky wrote:
> I don't see it in net-next yet, can you please pull it?
> 
> There are outstanding RDMA patches which depend on this shared branch.
> https://lore.kernel.org/all/cover.1673960981.git.leon@kernel.org

FWIW I'm not nacking this but I'm not putting my name on the merge,
either. You need to convince one of the other netdev maintainers to
pull.
