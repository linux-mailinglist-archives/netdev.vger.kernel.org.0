Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2521B549C72
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 20:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344610AbiFMS7P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 14:59:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347753AbiFMS7E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 14:59:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F7928A046
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 09:13:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82B79B810DC
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 16:13:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86D0FC34114;
        Mon, 13 Jun 2022 16:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655136800;
        bh=bkXxF/8rqiIGVLDZTwnmZ9winCNh3IvsK6ufCxdHmVI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TLZsHGBgYdoLmaLxMifGf8SIQOPbxyAxLsFO1ml+VegH+NcC2uiSB9mKHSnDNsSB8
         l0vlF0kFAAi5nGMmvgJkPHEEFFEYh/umrwxmzwd0srxdd/Nx5BS27ZID3qz6bvq4Iv
         R8eQKB/aH/cjt5TWwlVpCVOk4SrRQIcl7N0rqaXCqcn2lwUpADofe0/aDS1YJQU3Jt
         ovL9gfu05jUr6OchiGKyXjcVj6C5EUOcpPQhghwZ8WmW2o8YZL9XA22Cic6xnNtTyp
         U6jYuYpGFoQrA3ikT54yKCglcE2OeZ94Vvkd7SbOwjJTqM6NiZ088fdJ72Q+ofAOo8
         YKNfKXppEFlSg==
Date:   Mon, 13 Jun 2022 09:13:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     netdev@vger.kernel.org, kernel-team@fb.com,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Lasse Johnsen <l@ssejohnsen.me>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>
Subject: Re: [PATCH net-next v6 2/3] net: phy: broadcom: Add PTP support for
 some Broadcom PHYs.
Message-ID: <20220613091318.72ce51e8@kernel.org>
In-Reply-To: <20220611213355.q4gtcglc5j3kmdek@bsd-mbp.dhcp.thefacebook.com>
References: <20220608204451.3124320-1-jonathan.lemon@gmail.com>
        <20220608204451.3124320-3-jonathan.lemon@gmail.com>
        <20220610180255.68586bd1@kernel.org>
        <20220611213355.q4gtcglc5j3kmdek@bsd-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 11 Jun 2022 14:33:55 -0700 Jonathan Lemon wrote:
> How about this?  Seems to work for my testing.  If this is ok, I'll
> spin up (hopefully the last) patch on Monday.

LGTM!
