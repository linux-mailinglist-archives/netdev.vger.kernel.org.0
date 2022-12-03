Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2B3641445
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 06:26:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbiLCF0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 00:26:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbiLCF0S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 00:26:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 078BDE2ABB;
        Fri,  2 Dec 2022 21:26:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7FD16601C3;
        Sat,  3 Dec 2022 05:26:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5169BC433C1;
        Sat,  3 Dec 2022 05:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670045176;
        bh=lZSpHvJTKBzH3b/jmSRHKymBWI9h02r7vUsYUG3LJD0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BB0ClzzFx20GCDAlaxpA9Obulcb9Pspy5MCBR9ev1ZivxD7XYDKOvMsgPNCQ3Oc1w
         HOoClyEnJMhauncHCCtua6bXh37/oTpki9bqbgAmBEINgTCf+3hoRP4/FgmXUSDXht
         YHjYPObz2BPJXXw00Q+5oadB3x4ufjBr8qiqhkVZBscemfRziG1kFL3ITspzxoG5es
         4mFn2XCxF1SHNLufmNWup9ym6ah5NVCVcOmGvkUcNMAj1FrnWCOLZ13wdjem/06GHT
         lWTTWICQfBAlyfqQWvjKXoCVm6PTCziRCA7O7PXPjH4Ash5ILJjfXcsONPPd9x8/x7
         zu48YsFo15vjQ==
Date:   Fri, 2 Dec 2022 21:26:15 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Tim Harvey <tharvey@gateworks.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 3/3] phy: aquantia: Determine rate
 adaptation support from registers
Message-ID: <20221202212615.0f1c1378@kernel.org>
In-Reply-To: <20221202181719.1068869-4-sean.anderson@seco.com>
References: <20221202181719.1068869-1-sean.anderson@seco.com>
        <20221202181719.1068869-4-sean.anderson@seco.com>
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

On Fri,  2 Dec 2022 13:17:18 -0500 Sean Anderson wrote:
> + * @speed - The speed of this config
> + * @reg - The global system configuration register for this speed
> + * @speed_bit - The bit in the PMA/PMD speed ability register which determines

s/ -/:/
