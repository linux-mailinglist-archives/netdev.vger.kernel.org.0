Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAD1E4D0429
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 17:29:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244199AbiCGQab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 11:30:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244191AbiCGQa3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 11:30:29 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09B7269291;
        Mon,  7 Mar 2022 08:29:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=02D2otYguOs3IBNgfEENl7br6jhd4kE5uD4PYiH8JBE=; b=l70l3TVGEiLnrc0oDMbfDtxTTD
        +spKO4eHhAt8EM1yHdaFqZWPKJIl9H46V+cI1620Z7rz6yNd4SvZdofvmjBtlgebyTZ6u5rSksnQY
        jpLYsJYlV2+y+1ZAFxdYkl7b/xDAd+znYZ7xjFSSN4NpatlIz9Swu7zq0T6DINeEhXYU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nRGEj-009dKv-9j; Mon, 07 Mar 2022 17:29:29 +0100
Date:   Mon, 7 Mar 2022 17:29:29 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next 1/2] net: phy: exported the
 genphy_read_master_slave function
Message-ID: <YiYy6UDLIQdbEwVi@lunn.ch>
References: <20220307161515.14970-1-arun.ramadoss@microchip.com>
 <20220307161515.14970-2-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220307161515.14970-2-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 07, 2022 at 09:45:14PM +0530, Arun Ramadoss wrote:
> genphy_read_master_slave function allows to configure the master/slave
> for gigabit phys only. In order to use this function irrespective of
> speed, moved the speed check to the genphy_read_status call.
> 
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
