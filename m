Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 942C14E6AEF
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 00:01:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351726AbiCXXCR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 19:02:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238115AbiCXXCQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 19:02:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19851BB089;
        Thu, 24 Mar 2022 16:00:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A808D615CC;
        Thu, 24 Mar 2022 23:00:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4E0EC340EC;
        Thu, 24 Mar 2022 23:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648162843;
        bh=G1r5q+82NDLJrhAU0vD8OOUagHl0c9TCxr5HqadI45U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nwXx1G/4ADyMDnxksT7HO5PIj79u6EBRhzX6xYaZvE03vw+JZhrQYDSNLvb0DepUD
         ++auCcDJARgxL7qw5YygCI2BKYUa7nXG6XIrrE/mQYR6dQN2M26j6jeDJ9WPeHZvu0
         nmgSOTrC7ro8qTHVc5R0u/QEGAEzvXrGxKKINUpNmUdvwENBpuad2WpX6SfX+du2Ba
         TGX1OaEC83wTk5Nn2qyC569NKo6h4zB8uNwVWPQEIxGrfHZH4XE5Ih7KfZgDGNjVpo
         HJiWEm5Y1xFCFJtL4cA3DcCmtOjCZK4jmU10My/30Ge13hSggYrQT16228V5MjxNm0
         N7g9yBEQ17w1g==
Date:   Thu, 24 Mar 2022 16:00:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     <alexandru.tachici@analog.com>
Cc:     <andrew@lunn.ch>, <o.rempel@pengutronix.de>, <davem@davemloft.net>,
        <devicetree@vger.kernel.org>, <hkallweit1@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux@armlinux.org.uk>,
        <netdev@vger.kernel.org>, <robh+dt@kernel.org>
Subject: Re: [PATCH v5 0/7] net: phy: adin1100: Add initial support for
 ADIN1100 industrial PHY
Message-ID: <20220324160041.0d775df8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220324112620.46963-1-alexandru.tachici@analog.com>
References: <20220324112620.46963-1-alexandru.tachici@analog.com>
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

On Thu, 24 Mar 2022 13:26:13 +0200 alexandru.tachici@analog.com wrote:
> The ADIN1100 is a low power single port 10BASE-T1L transceiver designed for
> industrial Ethernet applications and is compliant with the IEEE 802.3cg
> Ethernet standard for long reach 10 Mb/s Single Pair Ethernet.

# Form letter - net-next is closed

We have already sent the networking pull request for 5.18
and therefore net-next is closed for new drivers, features,
code refactoring and optimizations. We are currently accepting
bug fixes only.

Please repost when net-next reopens after 5.18-rc1 is cut.

RFC patches sent for review only are obviously welcome at any time.
