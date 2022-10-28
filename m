Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9EFC611133
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 14:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbiJ1MYD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 08:24:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbiJ1MYC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 08:24:02 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3479E6FA1D
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 05:24:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=b9t8XNg6OimL/KwLpaGFnyzeF3jcbL+LDfgvuS7Zsc0=; b=3I
        7shUv7ni+xVeHdHtEYsmdAojLLXfoLTVFB25lDvKLXGCVprVXMxubJKfst0R0+JM2Y8f2Cji/r3EU
        oEFjoz3TctESj/3jv32q9C2TFj4nJl15orwmmVq7A8MCYTZiXG55TYqaZO0vcjsuERHaRGcQbKMFo
        sQEGgo+E9w8mUqA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ooOOz-000oB9-I4; Fri, 28 Oct 2022 14:23:57 +0200
Date:   Fri, 28 Oct 2022 14:23:57 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Fabio Estevam <festevam@gmail.com>
Cc:     kuba@kernel.org, olteanv@gmail.com, netdev@vger.kernel.org,
        Steffen =?iso-8859-1?Q?B=E4tz?= <steffen@innosonix.de>
Subject: Re: [PATCH] net: dsa: mv88e6xxx: Add .port_set_rgmii_delay to 88E6320
Message-ID: <Y1vJ3Y7ZpHuJA+Sc@lunn.ch>
References: <20221028120654.90508-1-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221028120654.90508-1-festevam@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 28, 2022 at 09:06:54AM -0300, Fabio Estevam wrote:
> From: Steffen Bätz <steffen@innosonix.de>
> 
> Currently, the port_set_rgmii_delay hook is missing for 88E6320, which
> causes failure to retrieve an IP address via DHCP.

Hi Fabio

Thanks for the patch. The 88E6320 family contains both the 88E6320 and
the 88E6321. Could you check the datasheet if this same change works
for the 88E6321. It probably does.

Thanks
	Andrew
