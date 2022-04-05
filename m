Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 102FD4F3FD7
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 23:05:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384095AbiDEOYP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 10:24:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380608AbiDENOG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 09:14:06 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C702124C39;
        Tue,  5 Apr 2022 05:17:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=TirUZa2jtJKxHIJLfrDdujcbpWXA+2UOaacwLbMHXu4=; b=HcqpA4hY9ri79fso0f339rrMcs
        wCZmTFSHG5Z4XYSQx1NT4zatymh5toRG4XsyM+hmnBPwUA/ssg0FePcwNGIE9y1MK1pIDF1RbBd3u
        qNkbgw1mAGxIDeegLAA6z4cJugPe8Nd8aaaOAzCUZHnivd0uVrXhc9oVxZwqR5Qo3Pm8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nbi7F-00EFMA-MV; Tue, 05 Apr 2022 14:16:57 +0200
Date:   Tue, 5 Apr 2022 14:16:57 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Andy Chiu <andy.chiu@sifive.com>
Cc:     davem@davemloft.net, michal.simek@xilinx.com,
        radhey.shyam.pandey@xilinx.com, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzk+dt@kernel.org, linux@armlinux.org.uk,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        Greentime Hu <greentime.hu@sifive.com>,
        Robert Hancock <robert.hancock@calian.com>
Subject: Re: [PATCH v8 net-next 1/4] net: axienet: setup mdio unconditionally
Message-ID: <YkwzOSR1yzspdCq3@lunn.ch>
References: <20220405091929.670951-1-andy.chiu@sifive.com>
 <20220405091929.670951-2-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220405091929.670951-2-andy.chiu@sifive.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 05, 2022 at 05:19:26PM +0800, Andy Chiu wrote:
> The call to axienet_mdio_setup should not depend on whether "phy-node"
> pressents on the DT. Besides, since `lp->phy_node` is used if PHY is in
> SGMII or 100Base-X modes, move it into the if statement. And the next patch
> will remove `lp->phy_node` from driver's private structure and do an
> of_node_put on it right away after use since it is not used elsewhere.
> 
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> Reviewed-by: Greentime Hu <greentime.hu@sifive.com>
> Reviewed-by: Robert Hancock <robert.hancock@calian.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
