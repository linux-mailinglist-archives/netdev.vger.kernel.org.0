Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09B4C590250
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 18:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237335AbiHKQIu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 12:08:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235432AbiHKQIU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 12:08:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C98C43E7D;
        Thu, 11 Aug 2022 08:54:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 32F2F601BF;
        Thu, 11 Aug 2022 15:54:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52861C433D6;
        Thu, 11 Aug 2022 15:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660233262;
        bh=iho7i9ZB1ofg2gRUhLG+IxJBVsaRONzK72+kliu3akw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oTglkPR0rn5OzxkPxJmLKt+bRuPFfpYMnhHbTEcPE7mt8Jb/z+gBxnBlY/m/poEIF
         9QzQP3KG+XV/ZCPXpz5NBkPcYqZUK7kiaqe9JuhVea2jGfPjKYSmVksMCzCQBSph+O
         TklykeKfQr7LYkymfaXhJgvNzVzq3lS4h8dG7rLb9RowRxrs2l9zsPO1Pe1iykMTiJ
         v9jjCAWuHzuXdAwdMAXO/diQEp/lN5cHpY2OsZ6uXkAG6LeAEKfMiUUszffAOmj7vJ
         z0/8pWdm+euh9jLyIMPDMTb1lNXRpaN4DamfbViRTbeOPdp8ORJDBPm3a/Wo5glneS
         32A4Pbq9VJ8Sg==
Date:   Thu, 11 Aug 2022 08:54:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jiri Pirko <jiri@nvidia.com>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.19 096/105] net: devlink: make sure that
 devlink_try_get() works with valid pointer during xarray iteration
Message-ID: <20220811085413.41ce9d41@kernel.org>
In-Reply-To: <20220811152851.1520029-96-sashal@kernel.org>
References: <20220811152851.1520029-1-sashal@kernel.org>
        <20220811152851.1520029-96-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 11 Aug 2022 11:28:20 -0400 Sasha Levin wrote:
> Remove dependency on devlink_mutex during devlinks xarray iteration.

Prep for a later patch, please drop.
