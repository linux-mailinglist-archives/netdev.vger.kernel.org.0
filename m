Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E50A8520286
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 18:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239182AbiEIQjI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 12:39:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239176AbiEIQjI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 12:39:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A080296BE0
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 09:35:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EE90BB817F8
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 16:35:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6220FC385B4;
        Mon,  9 May 2022 16:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652114111;
        bh=M600/xVF+vmq9EwwK2+KoLqnlseZwIXcxdz+2Vi8AFY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SvclTJ6xG4zWfAZqc+pR2tFJA1fSqnIfpI0DnBUL8ET9kYPGppJa4eu6/guuf6qvo
         F/4NABzSDxiZQ0Ic73MVf3kG4Ey/MxRbAYKIdFq7gOECAZerJ+tgDaFqqiqBMGbnga
         VqxRYEKwgofOsyomTU0bOUwNg9HGsXJcuSvq47Ge3zOQQTLHJdCmrxcE828NRLyY0f
         Mz7b19bz1yVgY1mjANr3gVC5iclCwwLi3AEWLr8attnvdgOTV/gs7PVTNRz4+H5rN/
         ZfpQGOKj9nfUvFEP9RHN/dG8alrpXfTn+6fIPeOIAZQJjcBL7N4oe85PZLk5MBed7A
         nhKXlApwyjfxA==
Date:   Mon, 9 May 2022 09:35:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     <Yuiko.Oshino@microchip.com>
Cc:     <andrew@lunn.ch>, <Woojung.Huh@microchip.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <Ravi.Hegde@microchip.com>, <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH v4 net-next 2/2] net: phy: smsc: add LAN8742 phy
 support.
Message-ID: <20220509093510.33bcfea2@kernel.org>
In-Reply-To: <CH0PR11MB55611C73D1A6472911151BB98EC69@CH0PR11MB5561.namprd11.prod.outlook.com>
References: <20220505181252.32196-1-yuiko.oshino@microchip.com>
        <20220505181252.32196-3-yuiko.oshino@microchip.com>
        <YnQlicxRi3XXGhCG@lunn.ch>
        <20220506154513.48f16e24@kernel.org>
        <YnZ4uqB688uAeamL@lunn.ch>
        <CH0PR11MB5561FF8274E9D5771D472C0F8EC69@CH0PR11MB5561.namprd11.prod.outlook.com>
        <YnkcJ73mhI2aoo2h@lunn.ch>
        <CH0PR11MB55611C73D1A6472911151BB98EC69@CH0PR11MB5561.namprd11.prod.outlook.com>
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

On Mon, 9 May 2022 14:24:44 +0000 Yuiko.Oshino@microchip.com wrote:
> May I also fix this missing one tab after the phy_id in smsc.c in the same patch?
> 
> +	.phy_id	= 0x0007c130,	/* 0x0007c130 and 0x0007c131 */
> +	.phy_id_mask	= 0xfffffff2,
> +

Seems like an okay change to make in addition in adding the comments.
Both are non-functional changes, anyway.
