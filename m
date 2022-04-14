Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5019500D22
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 14:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243160AbiDNMYs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 08:24:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbiDNMYr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 08:24:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28B7375224;
        Thu, 14 Apr 2022 05:22:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B494961F8E;
        Thu, 14 Apr 2022 12:22:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 951F1C385A1;
        Thu, 14 Apr 2022 12:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649938942;
        bh=8Xnx1DikNC8S2miol9o95pX0WhJ5fuI422FUZIL5zhg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=N8vF0SYdpsOHP/kq1h8sVjrcKPvnImlfhaeWieGFCt9WQNoz+/pC8GVsQ7LgHgwx6
         bahUHfWLmPARFdsuDbP75vQxEYigTxwlYRfHpEfDMYnB5Cx7Icft0fLLLON1CH1Eui
         eaGX/bXDgdmvvEpOs23AYeh1DMgsk7QIC3pCWMkpRwZq8O1yp3sV7SYHEfctNv9b44
         nM5uBbKrIJQx6Vh3VQa44flG/cxsz7Cve7gu9W9pAufjz96fBQfw0riFR/yLYfstWQ
         BU97D2C6ww4KepktXtYrxxSqFqh6HcU1zWTTDK3mdHuzV1O3Tt2i/GZagEIBwPIN5i
         05vzYceWGgdgQ==
Date:   Thu, 14 Apr 2022 14:22:12 +0200
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dylan Hung <dylan_hung@aspeedtech.com>
Cc:     <robh+dt@kernel.org>, <joel@jms.id.au>, <andrew@aj.id.au>,
        <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <pabeni@redhat.com>,
        <p.zabel@pengutronix.de>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-aspeed@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <krzk+dt@kernel.org>,
        <BMC-SW@aspeedtech.com>
Subject: Re: [PATCH v5 0/3] Add reset deassertion for Aspeed MDIO
Message-ID: <20220414142212.258fcb37@kernel.org>
In-Reply-To: <20220413121037.23748-1-dylan_hung@aspeedtech.com>
References: <20220413121037.23748-1-dylan_hung@aspeedtech.com>
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

On Wed, 13 Apr 2022 20:10:34 +0800 Dylan Hung wrote:
> Add missing reset deassertion for Aspeed MDIO bus controller. The reset
> is asserted by the hardware when power-on so the driver only needs to
> deassert it. To be able to work with the old DT blobs, the reset is
> optional since it may be deasserted by the bootloader or the previous
> kernel.

I presume you want this applied to net-next, but it appears there 
is a conflict or something. Could you resend the patches based on
net-next/master?
