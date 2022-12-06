Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29107643C17
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 05:12:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232748AbiLFEMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 23:12:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229938AbiLFEL6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 23:11:58 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0CFB209A4;
        Mon,  5 Dec 2022 20:11:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 38672CE1732;
        Tue,  6 Dec 2022 04:11:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12DF3C433D6;
        Tue,  6 Dec 2022 04:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670299913;
        bh=oHyQEKDCZJCHzZrjfqpySFld26mpywWljhHt4iOUg3Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=j5yZ/B8xAFf3+t90iBRLhKfQsZpzC4mVtXAC+XEHhNikiJpT/YrovfrCA72aRPbtc
         jiI6qJQSJ49Bd6BM/dJNqJMbXsZ5a5FYfCzpVyYoFzd8O5A8XrrfdbKlwsFOeUXXeo
         Oxc8qwB6JziQZgm/kDCM0fu9X/bZZ3GZDTeevqLSCHjTBpAMGT9XUDJplYRQaNE79+
         NvP4F7aeADX1HBXl5/73ngnodZJm3QjCn6UnxoS7DY08u6KmyXBHHAZDfzXzXdtL9y
         BSIfbtI6RyE5KwlWXazXgXvnhnmg2+Sl3DA0cAnu/jL/Qt3CJaG7SXTtLIv9QslLlq
         A/5Xd+JL+HlKA==
Date:   Mon, 5 Dec 2022 20:11:52 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH net-next 0/2] ethtool: add PLCA RS support
Message-ID: <20221205201152.4577d15d@kernel.org>
In-Reply-To: <20221205180527.7cad354c@kernel.org>
References: <cover.1670121214.git.piergiorgio.beruto@gmail.com>
        <20221205180527.7cad354c@kernel.org>
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

On Mon, 5 Dec 2022 18:05:27 -0800 Jakub Kicinski wrote:
> On Sun, 4 Dec 2022 03:37:57 +0100 Piergiorgio Beruto wrote:
> > This patchset is related to the proposed "add PLCA RS support and onsemi
> > NCN26000" patchset on the kernel. It adds userland support for
> > getting/setting the configuration of the Physical Layer Collision
> > Avoidance (PLCA) Reconciliation Sublayer (RS) defined in the IEEE 802.3
> > specifications, amended by IEEE802.3cg-2019.  
> 
> nit: for the user space patches use the tool name in the subject tag
> [PATCH ethtool-next], I bet quite a few people looked at your set
> expecting kernel changes ;)

... which you already figured out / was told. Is a very bad day 
for my ability to spot next postings of the same set it seems :S
