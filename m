Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BDCA539BD4
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 05:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349517AbiFADyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 23:54:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232740AbiFADym (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 23:54:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 017935A090;
        Tue, 31 May 2022 20:54:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 257B560C2D;
        Wed,  1 Jun 2022 03:54:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA75EC385B8;
        Wed,  1 Jun 2022 03:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654055680;
        bh=Hw0JjLLLLJmJEqRrg3SXTwBDAG1cIOlJGpAbCO5/avU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MKJ/UpypicQmV5Js/2EpsXg5icbiSKbIoajJ0yHax556P6pZObm2oxOjZsDCB65H+
         Vu5wwM1jvXHHdwu/oomCCLR77M8bIfsIh8vx6Y76SC5dpgmM1BGm9AoR4CQnaFBTUJ
         HpYebHTPPqiXPF6nfDnbdIIQBLjLDQVo678D6CvGZPvu13hWMzn+5lbH0JHk4ECjuF
         x/+FknlbIGb5mjbC0plI7txLX8jgR4SIOO6StpQagBQSRiQsPwwSaU3u54B2CRUIHm
         DEdwGeEUErA7PyNTtfRWU84LUEvyqRbGxA0GUAz7mgKp4esS2xX4YwbIZXJeQTBdhc
         +0MMsfvSkygbg==
Date:   Tue, 31 May 2022 20:54:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Piyush Malgujar <pmalgujar@marvell.com>
Cc:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <devicetree@vger.kernel.org>,
        <cchavva@marvell.com>, <deppel@marvell.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH v2 0/3] net: mdio: mdio-thunder: MDIO clock related
 changes for Marvell Octeon Family.
Message-ID: <20220531205438.4fe7e074@kernel.org>
In-Reply-To: <20220530125329.30717-1-pmalgujar@marvell.com>
References: <20220530125329.30717-1-pmalgujar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 May 2022 05:53:25 -0700 Piyush Malgujar wrote:
> This patch series mdio changes are pertaining to Marvell Octeon family.
> 
> 1) clock gating:
> 	The purpose of this change is to apply clock gating for MDIO clock
> 	when there is no transaction happening. This will stop the MDC
> 	clock toggling in idle scenario.
> 
> 2) Marvell MDIO clock frequency attribute change:
> 	This MDIO change provides an option for user to have the bus speed
> 	set to their needs. The clock-freq for Marvell Octeon defaults to
> 	3.125 MHz and not 2.5 MHz as standard. In case someone needs to use
> 	this attribute, they have to add an extra attribute
> 	"clock-frequency" in the mdio entry in their DTS and this driver
> 	will do the rest.
>         The changes are made in a way that the clock will set to the
> 	nearest possible value based on the clock calculation and required
> 	frequency from DTS.
>         
> These changes has been verified internally with Marvell Octeon series.

Thanks for the patches, this does not sound like a fix tho and we're in
the middle of a merge window, so please repost on/after Monday.
