Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31BEA6730E9
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 06:03:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbjASFDG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 00:03:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbjASFC3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 00:02:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F024C7ED7E
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 20:56:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E5E0061B00
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 04:55:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00DACC433EF;
        Thu, 19 Jan 2023 04:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674104137;
        bh=XQCkqGRGK23DbwXcMKbgHwdCBbAgJSzWN6jUSfWnJXk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OZYuda/MAlZ6XIxH2OEl2ZKN/HTB4VRCZX0HUhxrqOhSi/Yev+NNr4KUQdcoSiYuf
         oo+oHFCNQy1X7Zl8AQjkLs6WrpZOrnj2Ad8bSYYD4fsUsTZS60LG2mVQINMv1s94oM
         2bc1lRcztaeTXEsc/oGiUxvBda9S0Iwx46v1DSE3tMBFab4gdFm+pCl3FV1aITS4OB
         4VS114Hhw//OHEx2jcGobyfQ/rp9Pd0QvElmmLGO7q42re3uQ2zdqHUosxw8K88snc
         yyKgcvyVPYe308GFeYgVD+TH2alIcClhR7BiSldA6r4Kxth+BDMPBPzNEEFaJi1VGg
         Yzwi1zjrS3Huw==
Date:   Wed, 18 Jan 2023 20:55:36 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [pull request][net 00/10] mlx5 fixes 2023-01-18
Message-ID: <20230118205536.61511fdc@kernel.org>
In-Reply-To: <20230118080414.77902-1-saeed@kernel.org>
References: <20230118080414.77902-1-saeed@kernel.org>
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

On Wed, 18 Jan 2023 00:04:04 -0800 Saeed Mahameed wrote:
> mlx5-fixes-2023-01-18

Acked-by: Jakub Kicinski <kuba@kernel.org>
