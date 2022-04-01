Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D898B4EED47
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 14:37:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345912AbiDAMjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 08:39:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344160AbiDAMjL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 08:39:11 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62B5425AEEE;
        Fri,  1 Apr 2022 05:37:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=A65FHQzB5wzN/vTaWYJa0lug1PmkY+gb72rfwJwaMM0=; b=SIeo0eUxgWgHXr/tg8eqKOogw6
        XZ4ZobMs8s9X4+wl2k4HZVemCLxQZ1+j5PajaTrmxG3r1GntyS+F8zQGrf8QkgMkohxejWKNd6+Pb
        bYU/9dY0LP9RaOuwuyvK9PKs88W8Mm+ox4/vHUTa/rFL4aivdEtglU27htAizvuvge80=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1naGWm-00DfYe-QZ; Fri, 01 Apr 2022 14:37:20 +0200
Date:   Fri, 1 Apr 2022 14:37:20 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, hkallweit1@gmail.com,
        linux@armlinux.org.uk, Divya.Koppera@microchip.com,
        davem@davemloft.net, kuba@kernel.org, richardcochran@gmail.com,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net 1/3] dt-bindings: net: micrel: Revert latency support
 and timestamping check
Message-ID: <YkbyAPVP0MHRBncd@lunn.ch>
References: <20220401094805.3343464-1-horatiu.vultur@microchip.com>
 <20220401094805.3343464-2-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220401094805.3343464-2-horatiu.vultur@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 01, 2022 at 11:48:03AM +0200, Horatiu Vultur wrote:
> Revert latency support from binding.
> Based on the discussion[1], the DT is the wrong place to have the
> lantecies for the PHY.
> 
> [1] https://lkml.org/lkml/2022/3/4/325
> 
> Fixes: 2358dd3fd325fc ("dt-bindings: net: micrel: Configure latency values and timestamping check for LAN8814 phy")
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
