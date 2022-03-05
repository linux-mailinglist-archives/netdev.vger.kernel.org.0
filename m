Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69B2D4CE2A9
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 06:07:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbiCEFIF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 00:08:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiCEFIE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 00:08:04 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 398C523F3A6
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 21:07:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9B3E1CE2BF2
        for <netdev@vger.kernel.org>; Sat,  5 Mar 2022 05:07:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 580D1C004E1;
        Sat,  5 Mar 2022 05:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646456831;
        bh=StxylLJZndmfaoBm49hP8e4rvDchvwoXbyMB3UxCkc8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uy/3Kf+17XYlpyOyAOpCdl193ZOhkdpevjoIT96KWtNH4KqGLrTgWRZN9kf9QLkHg
         hcTgHJhWVpj9mVOBvsJFuiofnxylp7pSm99tZ4bcomVqwZsFRszOHM7QVi4roaOpGt
         I9KOLo4jhIpXVezAyJb9OWSEY6RMyyuooS0bZwtublyNi5abRi6ReSOM26Ji2m50L1
         m23bSITaXE5TMNoMd4v9kFIIF0t1Q+pH4hPZkhgHtPVq8wNb9XYTs9tOMABM5X/+5x
         J2osxm70uxWf3eQGb6XAtRXZ2AQMhr7tHHA/eXUahBxU97htANiOP5GABl6fKQ0ZA9
         RHn/8ye5fLrPw==
Date:   Fri, 4 Mar 2022 21:07:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vyacheslav <adeep@lexina.in>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        linux-amlogic@lists.infradead.org,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net] net: phy: meson-gxl: fix interrupt handling in
 forced mode
Message-ID: <20220304210710.0d2cea8b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <962ae330-b2aa-c52d-5888-83b4fff74c44@lexina.in>
References: <04cac530-ea1b-850e-6cfa-144a55c4d75d@gmail.com>
        <962ae330-b2aa-c52d-5888-83b4fff74c44@lexina.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 4 Mar 2022 22:52:48 +0300 Vyacheslav wrote:
> Seems works for JetHub H1 (S905W with internal phy)

Thanks for testing! For future reference if you use the standard tag
i.e.:

Tested-by: Your Name <email@domain.tld> # JetHub H1 (S905W internal phy)

the credit to your testing will be preserved in git history.
