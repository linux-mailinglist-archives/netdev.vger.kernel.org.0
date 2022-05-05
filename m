Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF9E951C904
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 21:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376980AbiEETc7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 15:32:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381400AbiEETc6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 15:32:58 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D2C255491
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 12:29:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=U0h0TYZcqjzx6+NXJVSg9wXeZxdY5+mahJk6+GQTULs=; b=ofqFED8wwBTjcA2BXKtptR04qH
        WVVXbyI5isc3fFhhLuCOTZGF8f0e68fHB6QWQ3yVM2JDp70GQd4KZ8DQ4CoNzVEy1i+5BtBjaG066
        U2zGVF9UopRBZ0pv8+VGZyUFfgWG4uKfnWgrq22xf0VdSaNl8TLI/oI4p/Y5VspCMmi8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nmhA1-001PME-Mi; Thu, 05 May 2022 21:29:13 +0200
Date:   Thu, 5 May 2022 21:29:13 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Yuiko Oshino <yuiko.oshino@microchip.com>
Cc:     woojung.huh@microchip.com, davem@davemloft.net,
        netdev@vger.kernel.org, ravi.hegde@microchip.com,
        UNGLinuxDriver@microchip.com, kuba@kernel.org
Subject: Re: [PATCH v4 net-next 2/2] net: phy: smsc: add LAN8742 phy support.
Message-ID: <YnQlicxRi3XXGhCG@lunn.ch>
References: <20220505181252.32196-1-yuiko.oshino@microchip.com>
 <20220505181252.32196-3-yuiko.oshino@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220505181252.32196-3-yuiko.oshino@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 05, 2022 at 11:12:52AM -0700, Yuiko Oshino wrote:
> The current phy IDs on the available hardware.
>         LAN8742 0x0007C130, 0x0007C131
> 
> Signed-off-by: Yuiko Oshino <yuiko.oshino@microchip.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
