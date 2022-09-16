Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E6E85BACFE
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 14:08:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231264AbiIPMIY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 08:08:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230438AbiIPMIS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 08:08:18 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 193F6AFADC;
        Fri, 16 Sep 2022 05:08:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=3sBrLZszBTwXrdkhDhI3TRiPwHJ3gCGVkiN5akonAyA=; b=add+KNbUGfKNimygvqrNno44qk
        JAtUswvhSwRGSGk1A+1xsjn30E600n9BXMwKkznbrl0TrecSeFh+bbaFOphmXi2CguVh0GDFRBPfi
        uakL1RO/3UJorlpZpyyaQxjazWqmOrnzeoTZ9MVqd5/Hm3dc4DmRPyW22ygushzxKZWE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oZA8W-00GuiQ-N4; Fri, 16 Sep 2022 14:08:00 +0200
Date:   Fri, 16 Sep 2022 14:08:00 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Divya Koppera <Divya.Koppera@microchip.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: Re: [patch net-next] net: phy: micrel: PEROUT support in lan8814
Message-ID: <YyRnIIZYhnyEXMqA@lunn.ch>
References: <20220916112042.16501-1-Divya.Koppera@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220916112042.16501-1-Divya.Koppera@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 16, 2022 at 04:50:42PM +0530, Divya Koppera wrote:
> Support Periodic output from lan8814 gpio
> 
> Signed-off-by: Divya Koppera <Divya.Koppera@microchip.com>

Please Cc: the PTP Maintainer.

> +#define LAN88XX_PTP_GENERAL_CONFIG_LTC_EVENT_5MS_	9
> +#define LAN88XX_PTP_GENERAL_CONFIG_LTC_EVENT_1MS_	8
> +#define LAN88XX_PTP_GENERAL_CONFIG_LTC_EVENT_500US_	7
> +#define LAN88XX_PTP_GENERAL_CONFIG_LTC_EVENT_100US_	6
> +#define LAN88XX_PTP_GENERAL_CONFIG_LTC_EVENT_50US_	5
> +#define LAN88XX_PTP_GENERAL_CONFIG_LTC_EVENT_10US_	4
> +#define LAN88XX_PTP_GENERAL_CONFIG_LTC_EVENT_5US_	3
> +#define LAN88XX_PTP_GENERAL_CONFIG_LTC_EVENT_1US_	2
> +#define LAN88XX_PTP_GENERAL_CONFIG_LTC_EVENT_500NS_	1
> +#define LAN88XX_PTP_GENERAL_CONFIG_LTC_EVENT_100NS_	0
> +static int lan88xx_get_pulsewidth(struct phy_device *phydev,
> +				  struct ptp_perout_request *perout_request,
> +				  int *pulse_width)
> +{


A blank line between the #defines and the function would be good.

  Andrew
