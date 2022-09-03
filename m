Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B178C5ABF7F
	for <lists+netdev@lfdr.de>; Sat,  3 Sep 2022 17:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbiICPWN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Sep 2022 11:22:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiICPWN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Sep 2022 11:22:13 -0400
Received: from violet.fr.zoreil.com (violet.fr.zoreil.com [IPv6:2001:4b98:dc0:41:216:3eff:fe56:8398])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0DD557227
        for <netdev@vger.kernel.org>; Sat,  3 Sep 2022 08:22:11 -0700 (PDT)
Received: from violet.fr.zoreil.com ([127.0.0.1])
        by violet.fr.zoreil.com (8.17.1/8.17.1) with ESMTP id 283FLbWE3202404;
        Sat, 3 Sep 2022 17:21:37 +0200
DKIM-Filter: OpenDKIM Filter v2.11.0 violet.fr.zoreil.com 283FLbWE3202404
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fr.zoreil.com;
        s=v20220413; t=1662218497;
        bh=ROhZ4rUOaBOWDTMS7RLr/QUR34UiIQOrvzU2400dNVM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Yc3cd8125A+KkLT2mRGW8+95gV0t2mGqUUqGxCbt3Va1XZX+nZkVzHaRBARBRKgiU
         Ah1OYhaQ+/0tFhkZS2PEsdOh/5bU5ew7TflyJSNV5wgVSPf+g/7n0eLo1XXfdP7HmI
         JN43gU0UGXW9Ygvn1GA0zshC6KYxC3xKVZOxlFA4=
Received: (from romieu@localhost)
        by violet.fr.zoreil.com (8.17.1/8.17.1/Submit) id 283FLaKI3202401;
        Sat, 3 Sep 2022 17:21:36 +0200
Date:   Sat, 3 Sep 2022 17:21:35 +0200
From:   Francois Romieu <romieu@fr.zoreil.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] r8169: remove not needed net_ratelimit() check
Message-ID: <YxNw/6qh5gwWZH7N@electric-eye.fr.zoreil.com>
References: <1b1349bd-bb99-de1b-8323-2685d20f0c10@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1b1349bd-bb99-de1b-8323-2685d20f0c10@gmail.com>
X-Organisation: Land of Sunshine Inc.
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Heiner Kallweit <hkallweit1@gmail.com> :
> We're not in a hot path and don't want to miss this message,
> therefore remove the net_ratelimit() check.
>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

There had historically been some user push against excess "spam"
messages, even when systems are able to stand a gazillion of phy
generated messages - resources constrained systems may not - due
to dysfunctionning hardware or externally triggered events.

Things may have changed though.

-- 
Ueimor
