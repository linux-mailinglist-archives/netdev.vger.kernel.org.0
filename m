Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3E615E57D3
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 03:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbiIVBL0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 21:11:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbiIVBLY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 21:11:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CB754CA0C;
        Wed, 21 Sep 2022 18:11:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C748AB8198E;
        Thu, 22 Sep 2022 01:11:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E334AC433D6;
        Thu, 22 Sep 2022 01:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663809078;
        bh=UEejeR5j/HfizZGXLrDnPwM3JZb1ZxLW7c1MFE5c9sY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=G1zPNgeiNK33kf51wm0k5OFX4tMx7DzenuHz2tXpdYOgca7ZyB5BwZtMjDTWcz72M
         1wBaaU73O0Z9vR1me/DX8l4lj4p3L1QjQL7gQAeNVmOTm0o+PkNp8w2m/519cmID/E
         TxugPPzalsN4R8h3vmKwFFmYX9z+O1UV7lWhkbmtWwPJ22L5oW5cCowtKoD/y2b8ox
         wra+gM3TJ+WZ/DGjFzbN1GrBEbZsYKNlbj/e9BLJnSG+eyeP46G7nEDn6Wkw7O7KfK
         O3r4EjGbaYi5XzQVU7vIyueiYez/yFdmp5Iy2IUXJ4hlBpo2KZam9nwOPeCcy5zVeW
         HJdUGc/rOfqcw==
Date:   Wed, 21 Sep 2022 18:11:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>,
        <prasanna.vengateshan@microchip.com>, <hkallweit1@gmail.com>
Subject: Re: [Patch net-next v3 2/6] net: dsa: microchip: enable phy
 interrupts only if interrupt enabled in dts
Message-ID: <20220921181116.58b1163a@kernel.org>
In-Reply-To: <20220916091348.8570-3-arun.ramadoss@microchip.com>
References: <20220916091348.8570-1-arun.ramadoss@microchip.com>
        <20220916091348.8570-3-arun.ramadoss@microchip.com>
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

On Fri, 16 Sep 2022 14:43:44 +0530 Arun Ramadoss wrote:
> +	if (dev->irq > 0) {
> +		ret = lan937x_irq_phy_setup(dev);
> +		if (ret)
> +			return ret;

This no longer applies cleanly after 2f8a786f472445
please rebase & repost.
