Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93E03566445
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 09:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbiGEHjd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 03:39:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbiGEHjd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 03:39:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78BC413D1C
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 00:39:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 310F5B8163D
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 07:39:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB707C341C7;
        Tue,  5 Jul 2022 07:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657006769;
        bh=uf0aJbbPnOb8MSihvhlDS8q94NoOrvVdeXVSAInXGdU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i3WD5VR5Mg4ad5lSMfHVk0xXCQc/5BbP9kir4qchVdyhtSRMYMoXO9HIbjmj7P0yg
         alUo2LCcJAiivpg4IuM8k1DtqgK4DqKEC2lNd0F8Ahiv0dHF9jPVaunq8/wgsDqNnh
         xOjHRDDOA0yUDsUkukCT8K5/Jy+dByZRLK7F7+rIoA7yDyctq8mRdadXR1vioyZ2U3
         WEHf2sUr+1J3rJAOsfBLvs6WShOVUt48hMDgzA1c1B26M6PMyLekfqOJogAS+c7e/t
         lsXn+Egnb7LBBTGNPvVVte8+F7knXCD9D0z8hLCN3e3nDPgUMDvCXSzD/BT8wg6jaS
         /TfmVKRxvhpaA==
Date:   Tue, 5 Jul 2022 00:39:28 -0700
From:   Saeed Mahameed <saeed@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jianbo Liu <jianbol@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Ariel Levkovich <lariel@nvidia.com>
Subject: Re: [PATCH net-next] net/mlx5: fix 32bit build
Message-ID: <20220705073928.22icbhqtc4gvak6j@sx1>
References: <ecb00ddd1197b4f8a4882090206bd2eee1eb8b5b.1657005206.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <ecb00ddd1197b4f8a4882090206bd2eee1eb8b5b.1657005206.git.pabeni@redhat.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05 Jul 09:17, Paolo Abeni wrote:
>We can't use the division operator on 64 bits integers, that breaks
>32 bits build. Instead use the relevant helper.
>
>Fixes: 6ddac26cf763 ("net/mlx5e: Add support to modify hardware flow meter parameters")
>Signed-off-by: Paolo Abeni <pabeni@redhat.com>

Acked-by: Saeed Mahameed <saeedm@nvidia.com>

sorry for the mess. I sent v2 too soon, forgot to squash the 2nd fix to it.

