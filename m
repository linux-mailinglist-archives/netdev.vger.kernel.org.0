Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 818C9671191
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 04:12:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbjARDMk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 22:12:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbjARDMi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 22:12:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9ED54FADB;
        Tue, 17 Jan 2023 19:12:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99D96B81601;
        Wed, 18 Jan 2023 03:12:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5F2FC433D2;
        Wed, 18 Jan 2023 03:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674011555;
        bh=qZKIw3YHSpLbGC0IBsO+16g8GkAkcZudfly6vo0JCm4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MrfkiqjFpIa4RzjEUYWAbVP0lein/lPR5F3tORe3N0Z3TAecMj7r+Lz7wEY8muZGJ
         CxPk/BY2YXWzddJSTFaaVmlSUyAFlE6nwYnYVnnOLdW4k2EmV4Nu/mAFr5rBfFsAmm
         ZWN+ko/7hS3J4Nk3JXkoQsbFluZr5WwFsibMZTxxt8GpmYC2+NwTb5jXBBhShqonF0
         WZ6NWdjZm2wI3czovJRhsODenuOsx3BSkyDQzBGwxQ3M5QiG+britQkck+/ymVuckU
         bej6DyWxBCxcHS/qMG6BjyiS5z08JvR03pBNBCBXEHiTUZH8HX/4y7cYfFxQ9ADw1H
         V4l3+TLDdB/Vg==
Date:   Tue, 17 Jan 2023 19:12:33 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     Michael Walle <michael@walle.cc>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sander Vanheule <sander@svanheule.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next] regmap: Rework regmap_mdio_c45_{read|write}
 for new C45 API.
Message-ID: <20230117191233.1d8ac5a3@kernel.org>
In-Reply-To: <Y8VjkgcWHjR9TzNw@sirena.org.uk>
References: <20230116111509.4086236-1-michael@walle.cc>
        <Y8VjkgcWHjR9TzNw@sirena.org.uk>
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

On Mon, 16 Jan 2023 14:47:46 +0000 Mark Brown wrote:
> regmap: Rework regmap_mdio_c45_{read|write} for new C45 API.
> 
> This reworks the regmap MDIO handling of C45 addresses in
> preparation for some forthcoming updates to the networking code.

Pulled, thanks!
