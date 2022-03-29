Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA0F04EA6AE
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 06:45:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232132AbiC2ErL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 00:47:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231938AbiC2ErK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 00:47:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 946175AA56;
        Mon, 28 Mar 2022 21:45:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3E12CB80E5E;
        Tue, 29 Mar 2022 04:45:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49671C340ED;
        Tue, 29 Mar 2022 04:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648529124;
        bh=6hJOtf0eN1JPWyNYTlK4OfqUxK64irFgfVb+4qtqv2I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JVgTwdJM7LTPHhgBoMYT/ZUmYbTqUSmbbz/jg3r+HoEsNAK6HqHxef2uUISQTSDe2
         Hb9jTxx95gh6wquGFQF9jB7VJDKlehXpa30qchSkwlpgu4VQ0HhVke/2vcWpuBxTLQ
         qiBlZbT5tfEVhsBNPv7ifQYMnYY0VQEqd0eo2V6VFNqWYJSAH0nzZfS7Ow+KFTnYbR
         boAbdxkJC33OkKyBJVd8ggPpJpDA7JH7mBgJ3HaDCg0V5UVrvoAB3eOmqxyAN9+3Ef
         SBWtZ7jBy7dozNrQUjmewvHcvGV3NHaS9kEH2ROrZU5Dyge/BLQU8EclOm7o/c0LY9
         kIM8UjAJP6viA==
Date:   Mon, 28 Mar 2022 21:45:22 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dylan Hung <dylan_hung@aspeedtech.com>
Cc:     <robh+dt@kernel.org>, <joel@jms.id.au>, <andrew@aj.id.au>,
        <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <pabeni@redhat.com>,
        <p.zabel@pengutronix.de>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-aspeed@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <BMC-SW@aspeedtech.com>
Subject: Re: [PATCH v3 0/3] Add reset deassertion for Aspeed MDIO
Message-ID: <20220328214522.7cfdff1e@kernel.org>
In-Reply-To: <20220325041451.894-1-dylan_hung@aspeedtech.com>
References: <20220325041451.894-1-dylan_hung@aspeedtech.com>
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

On Fri, 25 Mar 2022 12:14:48 +0800 Dylan Hung wrote:
> Add missing reset deassertion for Aspeed MDIO bus controller. The reset
> is asserted by the hardware when power-on so the driver only needs to
> deassert it. To be able to work with the old DT blobs, the reset is
> optional since it may be deasserted by the bootloader or the previous
> kernel.

# Form letter - net-next is closed

We have already sent the networking pull request for 5.18
and therefore net-next is closed for new drivers, features,
code refactoring and optimizations. We are currently accepting
bug fixes only.

Please repost when net-next reopens after 5.18-rc1 is cut, in ~1 week.

RFC patches sent for review only are obviously welcome at any time.
