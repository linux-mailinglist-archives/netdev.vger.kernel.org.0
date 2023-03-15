Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73D056BA88D
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 08:00:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231236AbjCOHAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 03:00:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230348AbjCOHAq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 03:00:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64E2130EB6
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 00:00:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC99E61B36
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 07:00:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14F64C4339C;
        Wed, 15 Mar 2023 07:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678863644;
        bh=+aevTxkIuFXyBbaZjNiaGznDnVzW8trKHj3MOO/ETHs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uIKB+ts6+h8Hb1S2yFLV1bBT4DMcHobZXaA9oUsbKt/Kn1X9D8b1PvDji1KHHz7BI
         2N7rVJLN9v6ZeKDfrJxDudTmGQbR7pzesr5+OUIKZTgmjUSsKaYPlsp+kvRLCvOWIR
         KtWowSD1EWJvwAPJt+IvLBR3L+wWGiwUH61dL0/sMiBQc3/YG6Bkn6CaYnbagq/fvs
         OcI8n1wxAoKa+40/6xL1noprT5sO5V4Cy4wNePvRpqCnmyJ0VE2oik0nsgW6SGkdMo
         MqVuK0xPStYrFXwUrBK9fYsIx24qxhliIN0JnFQK95FfCEMUfHA/Sw9O1hKG0vae4R
         R+zOtOineSOnQ==
Date:   Wed, 15 Mar 2023 00:00:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sven Auhagen <Sven.Auhagen@voleatech.de>
Cc:     netdev@vger.kernel.org, mw@semihalf.com, linux@armlinux.org.uk,
        davem@davemloft.net, maxime.chevallier@bootlin.com
Subject: Re: [PATCH 3/3] net: mvpp2: parser fix PPPoE
Message-ID: <20230315000043.05475d9b@kernel.org>
In-Reply-To: <20230311071024.irbtnpzvihm37hna@Svens-MacBookPro.local>
References: <20230311071024.irbtnpzvihm37hna@Svens-MacBookPro.local>
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

On Sat, 11 Mar 2023 08:10:24 +0100 Sven Auhagen wrote:
> In PPPoE add all IPv4 header option length to the parser
> and adjust the L3 and L4 offset accordingly.
> Currently the L4 match does not work with PPPoE and
> all packets are matched as L3 IP4 OPT.

Also needs a Fixes tag
