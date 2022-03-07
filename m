Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C60F64D0080
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 14:54:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242944AbiCGNy4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 08:54:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242939AbiCGNyz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 08:54:55 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7985735251;
        Mon,  7 Mar 2022 05:54:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=6rOIFWhKoDtftsvnwuvPzF/1bQoao+7kYZk3K81OBV4=; b=1PqANxNzfOGdPb/AcfRUQsPbH9
        L9a4S3nesQKVhaE3zm5GswY2l+3U9XgnuR8zjx0Ynn8FxKhLuH0KcZg1iJ1beL39rItg46O4gEPib
        BMmb6ykxTA1ZCsJU/Tv8h6uH2gTVNj7rO8bibICg14r4CcFhyN1Sg1gxl0d0tpch7+O8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nRDoF-009cQF-RR; Mon, 07 Mar 2022 14:53:59 +0100
Date:   Mon, 7 Mar 2022 14:53:59 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        UNGLinuxDriver@microchip.com
Subject: Re: [RFC PATCH net-next 2/2] net: phy: lan87xx: use
 genphy_read_master_slave in read_status
Message-ID: <YiYOd61DUAJBA08G@lunn.ch>
References: <20220307101743.8567-1-arun.ramadoss@microchip.com>
 <20220307101743.8567-3-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220307101743.8567-3-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 07, 2022 at 03:47:43PM +0530, Arun Ramadoss wrote:
> To read the master slave configuration of the LAN87xx T1 phy, used the
> generic phy driver genphy_read_master_slave function. Removed the local
> lan87xx_read_master_slave function.
> 
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
