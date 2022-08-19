Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76AD55993C9
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 05:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345782AbiHSD5N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 23:57:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345788AbiHSD5M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 23:57:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53275DF675;
        Thu, 18 Aug 2022 20:57:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E2E8161505;
        Fri, 19 Aug 2022 03:57:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1844C433D6;
        Fri, 19 Aug 2022 03:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660881431;
        bh=wJqAuzYCXIeNTbmY+FcWjsGWgwyfRsMkwVaQysfxfWk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cK2NWtib6SyISu1F7vndfs6eL8IIhkf1mjKgZYMf1mDfiFnLqXR8A3TvpBvOK9Won
         +TmuNnGZ1D1N94LmKYx3r/u/apnodN+74DHZHumr2PYBswPxAm64Q2zER+7LObgRKs
         MtQkhfkHVx4t115vLrqEJABhWLxgoLMliATOjY3OcBIsyUvN69b0rePzxfGGJ04doO
         Do4QNG6lHKb3yMi8DAHLfn/eu3mgJSBTsgP2jHfe3pHHdyhhJ5oaSz0pxhfl4gGNho
         XBUaU6uUE7M7YQu1rfX5RvmYjMq7lT2qpz0Tgu5orzDF4Epn1qhXZObu4oN1nbuadV
         2hnSWFEiptY4w==
Date:   Thu, 18 Aug 2022 20:57:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jonathan Toppins <jtoppins@redhat.com>
Cc:     netdev@vger.kernel.org, jay.vosburgh@canonical.com,
        liuhangbin@gmail.com, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v4 3/3] bonding: 3ad: make ad_ticks_per_sec a const
Message-ID: <20220818205710.7eb43ac6@kernel.org>
In-Reply-To: <2d2bdb267ac504b1e197fa7316470462a2e8b7a7.1660832962.git.jtoppins@redhat.com>
References: <cover.1660832962.git.jtoppins@redhat.com>
        <2d2bdb267ac504b1e197fa7316470462a2e8b7a7.1660832962.git.jtoppins@redhat.com>
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

On Thu, 18 Aug 2022 10:41:12 -0400 Jonathan Toppins wrote:
> @@ -2005,7 +2006,7 @@ void bond_3ad_initiate_agg_selection(struct bonding *bond, int timeout)
>   *
>   * Can be called only after the mac address of the bond is set.
>   */
> -void bond_3ad_initialize(struct bonding *bond, u16 tick_resolution)
> +void bond_3ad_initialize(struct bonding *bond)

kdoc needs updating here
