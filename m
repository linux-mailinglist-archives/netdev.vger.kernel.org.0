Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A108054E9DE
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 21:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233571AbiFPTNh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 15:13:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbiFPTNd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 15:13:33 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D8EB23159;
        Thu, 16 Jun 2022 12:13:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=kwHkEhHoMIYTCtzv7vXobAS9Ona03Hki3de+fTCBFF4=; b=3zGfQ4z7b+R1c55wBrk6cLo1MY
        fnu/bhi9kJ9kATT6CGEsTdLftTOm3WsiJOkaIR2Bdf4dCGKksUraO6LQc0RzLIfbvzCGPBYM3qv4m
        Yc/0YyJW6xpHqe//RzZF2STuhaLMysYTBXTq9QBgdNvZBxGGPh1u5XPVwwCBlB8r/Soc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1o1uvm-007EAX-N4; Thu, 16 Jun 2022 21:13:26 +0200
Date:   Thu, 16 Jun 2022 21:13:26 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, lxu@maxlinear.com,
        davem@davemloft.net, linux-kernel@vger.kernel.org,
        bryan.whitehead@microchip.com, richardcochran@gmail.com,
        UNGLinuxDriver@microchip.com, Ian.Saturley@microchip.com
Subject: Re: [PATCH net-next V2 2/4] net: lan743x: Add support to Secure-ON
 WOL
Message-ID: <YquA1vrBDkcm18uq@lunn.ch>
References: <20220616041226.26996-1-Raju.Lakkaraju@microchip.com>
 <20220616041226.26996-3-Raju.Lakkaraju@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220616041226.26996-3-Raju.Lakkaraju@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 16, 2022 at 09:42:24AM +0530, Raju Lakkaraju wrote:
> Add support to Magic Packet Detection with Secure-ON for PCI11010/PCI11414 chips
> 
> Signed-off-by: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
