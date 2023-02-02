Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19EF468819D
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 16:20:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232632AbjBBPUD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 10:20:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232848AbjBBPTw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 10:19:52 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC42717CFC;
        Thu,  2 Feb 2023 07:19:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=9b7ek/j51YDB3J1VfULAhCx3WWngyDVIop+SMcxegiI=; b=GhQqE2Diia4GSMw6KCx9f4iksr
        gvb1brYeskJTqbSX7QOv4diK8qyjTwZvvEoCPnGdLSMHeoN0IkZ5WZil1ernf7sD4BTEfjlsmtMf/
        NQDit89KDYrKQq1qbsUQ68lge2nBn0wO9OoggL0OX9I7MH5NY9I5DrCLGPj0HtaRFx5A=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pNbN0-003uF0-N2; Thu, 02 Feb 2023 16:19:26 +0100
Date:   Thu, 2 Feb 2023 16:19:26 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        linux@armlinux.org.uk
Subject: Re: [RFC PATCH net-next 04/11] net: dsa: microchip: lan937x: update
 port number for LAN9373
Message-ID: <Y9vUflgHqpk44oYl@lunn.ch>
References: <20230202125930.271740-1-rakesh.sankaranarayanan@microchip.com>
 <20230202125930.271740-5-rakesh.sankaranarayanan@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202125930.271740-5-rakesh.sankaranarayanan@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 02, 2023 at 06:29:23PM +0530, Rakesh Sankaranarayanan wrote:
> LAN9373 have total 8 physical ports. Update port_cnt member in
> ksz_chip_data structure.

This seems more like a fix. Should it be applied to net, not net-next,
and have Fixes: tag?

    Andrew
