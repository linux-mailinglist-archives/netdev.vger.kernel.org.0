Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F4058611A5C
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 20:44:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbiJ1Soj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 14:44:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230274AbiJ1Sog (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 14:44:36 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47FACD106
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 11:44:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=6PgbphJPPBYVMyhPmlwXCA15Zz/880Ci2PCyOBgYCoY=; b=Ad
        xCd6fpF82Jo8vsc/6X/W99CzULjy5obhHt6DLG73xyjhnhRxK3oZ009mv1JojEDWRszx6gCSbW9BD
        UIyF63LzxMH5KS7Aqdy052HgPRyE1r91hdwtrfM2KJu2uhu1x3bEKlQAzZa8BnJFozVIQ7p1lV7yE
        tRlUQpuNqbuswZU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ooUKg-000qcw-MH; Fri, 28 Oct 2022 20:43:54 +0200
Date:   Fri, 28 Oct 2022 20:43:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Fabio Estevam <festevam@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, olteanv@gmail.com,
        netdev@vger.kernel.org,
        Steffen =?iso-8859-1?Q?B=E4tz?= <steffen@innosonix.de>,
        Fabio Estevam <festevam@denx.de>
Subject: Re: [PATCH v3 net-next] net: dsa: mv88e6xxx: Add RGMII delay to
 88E6320
Message-ID: <Y1wi6t4Cu0R7qFxp@lunn.ch>
References: <20221028163158.198108-1-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221028163158.198108-1-festevam@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 28, 2022 at 01:31:58PM -0300, Fabio Estevam wrote:
> From: Steffen Bätz <steffen@innosonix.de>
> 
> Currently, the .port_set_rgmii_delay hook is missing for the 88E6320
> family, which causes failure to retrieve an IP address via DHCP.
> 
> Add mv88e6320_port_set_rgmii_delay() that allows applying the RGMII
> delay for ports 2, 5, and 6, which are the only ports that can be used
> in RGMII mode.
> 
> Tested on a custom i.MX8MN board connected to an 88E6320 switch.
> 
> This change also applies safely to the 88E6321 variant.
> 
> The only difference between 88E6320 versus 88E6321 is the temperature
> grade and pinout.
> 
> They share exactly the same MDIO register map for ports 2, 5, and 6,
> which are the only ports that can be used in RGMII mode.
> 
> Signed-off-by: Steffen Bätz <steffen@innosonix.de>
> [fabio: Improved commit log and extended it to mv88e6321_ops]
> Signed-off-by: Fabio Estevam <festevam@denx.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
