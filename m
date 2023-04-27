Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD6346F05C2
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 14:28:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243420AbjD0M2a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 08:28:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243406AbjD0M23 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 08:28:29 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A473D4C39;
        Thu, 27 Apr 2023 05:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ZKyLvoJ2fNug57URvpaiOBCAIlqtWrGQ11WQPzruF9Y=; b=tPmc5rywTjzIgXh7NuHKYYAfh8
        WaHBxGay50P5YmPGUgMZ0h3v47yqGkxs7rI0flhlcC1FhvY+Emiwb940Zoy5yb8Op3dBkeEZn5Ajh
        MYp7zgDY1WPuwcSD/jKcUEZbuCncyojBm90oIjNB0ivJuFUk2eSuSjHkAc7kzI6Ima2E=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ps0jD-00BLpu-C9; Thu, 27 Apr 2023 14:28:03 +0200
Date:   Thu, 27 Apr 2023 14:28:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Hayes Wang <hayeswang@realtek.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net v2 3/3] r8152: move setting
 r8153b_rx_agg_chg_indicate()
Message-ID: <2209d5a9-31ea-4ca1-a2e8-f1a64290b2d2@lunn.ch>
References: <20230426122805.23301-400-nic_swsd@realtek.com>
 <20230427121057.29155-405-nic_swsd@realtek.com>
 <20230427121057.29155-408-nic_swsd@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230427121057.29155-408-nic_swsd@realtek.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 27, 2023 at 08:10:57PM +0800, Hayes Wang wrote:
> Move setting r8153b_rx_agg_chg_indicate() for 2.5G devices. The
> r8153b_rx_agg_chg_indicate() has to be called after enabling tx/rx.
> Otherwise, the coalescing settings are useless.
> 
> Fixes: 195aae321c82 ("r8152: support new chips")
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
