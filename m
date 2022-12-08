Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3FEE6466CF
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 03:13:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbiLHCNQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 21:13:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbiLHCNE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 21:13:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3EC840931;
        Wed,  7 Dec 2022 18:13:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C337B821CC;
        Thu,  8 Dec 2022 02:13:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BA31C433C1;
        Thu,  8 Dec 2022 02:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670465581;
        bh=hk6nF9hW3WKp4ekOFq4BbUJ2zH+YnWgQqfQP2wxWoz4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rxFh1KJ/FZ0WS0wSNX6UtVcB9uqmvJZxMTZaSF8QjB0EBxex3oBNZV6BFHB2V8Yux
         CVUKA85u8GCZnhNPi/AdvQTalv2nx+8Lde32Vnk4ls86JMQw/6OADUYgQBh4hcZTpX
         5TlFAjrnBzFdoZ6n4dLTQVV48BxKSwQVazvDGHei82qU5lA8N+Oy1mgGLLpMzw5kIq
         1qKVh/LJa6jONYYvJVPz2bRATXehBd6lX5XXWCC1lkXJbIC2G3R5BWU4YkhUdF6eap
         PYnyKf3wqLYr4QewoBQJIciDns+yo4X7kZeXm049OpoEaK5ForIG7RBFtjELOoS+zU
         SxWoDJf54HZGA==
Date:   Wed, 7 Dec 2022 18:12:59 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH v5 net-next 1/5] net/ethtool: add netlink interface for
 the PLCA RS
Message-ID: <20221207181259.5ac4119e@kernel.org>
In-Reply-To: <Y5C2JdZkHGhHzWQh@gvm01>
References: <cover.1670371013.git.piergiorgio.beruto@gmail.com>
        <350e640b5c3c7b9c25f6fd749dc0237e79e1c573.1670371013.git.piergiorgio.beruto@gmail.com>
        <20221206195014.10d7ec82@kernel.org>
        <Y5CQY0pI+4DobFSD@gvm01>
        <Y5CgIL+cu4Fv43vy@lunn.ch>
        <Y5C2JdZkHGhHzWQh@gvm01>
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

On Wed, 7 Dec 2022 16:49:57 +0100 Piergiorgio Beruto wrote:
> Andrew, Jakub,
> I believe this should address your comments for this patch?
> It is a diff WRT patch v5.

It does mine, I think, thanks!
