Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABE01526A7B
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 21:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383841AbiEMThL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 15:37:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383842AbiEMThK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 15:37:10 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C2C35400F
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 12:37:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ENTPGX8oQSdw057kf/ixQqrYUpRHVGYP3xLe9VQ9/os=; b=5VgGqm7tba3F5hRDTu0JJ3YG7F
        i9xMbdz7rPbcMXnihXx8yD/ZfHc8V124eu4VnhQv+zQTf20ROCxonBi4ZF40NAQg2de9vajfwNPkp
        9sBAxQlsP82ojq3y+mzTOIkPI8rIk8dnWtTG+NuuG5ljlxeVMKr37P0R1akbFnFBlv20=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1npb5t-002cm0-Fw; Fri, 13 May 2022 21:36:57 +0200
Date:   Fri, 13 May 2022 21:36:57 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Fabio Estevam <festevam@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        Fabio Estevam <festevam@denx.de>
Subject: Re: [PATCH net-next 1/2] net: phy: micrel: Allow probing without
 .driver_data
Message-ID: <Yn6zWVRztEwibCy/@lunn.ch>
References: <20220513114613.762810-1-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220513114613.762810-1-festevam@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 13, 2022 at 08:46:12AM -0300, Fabio Estevam wrote:
> From: Fabio Estevam <festevam@denx.de>
> 
> Currently, if the .probe element is present in the phy_driver structure
> and the .driver_data is not, a NULL pointer dereference happens.
> 
> Allow passing .probe without .driver_data by inserting NULL checks
> for priv->type.
> 
> Signed-off-by: Fabio Estevam <festevam@denx.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
