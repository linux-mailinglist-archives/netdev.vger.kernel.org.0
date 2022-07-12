Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5473571B03
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 15:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232000AbiGLNUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 09:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbiGLNUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 09:20:20 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F9924B49B;
        Tue, 12 Jul 2022 06:20:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=5myWbE1xCV9RkNlbJ5TLOsN03+CVJzD4SpNFRvkiDJM=; b=IqqDFj4nYtwcP+DizK+aKySf/D
        LGBPGndi0WYmd8RRMkUgYTqktU/ZBr0bVTbvrJ9Lmz0oF4/GrahzOZ8QGeTsZgiKTA60hiSKm21sG
        hND/5ntIzlSYeq6mP/IloH0iKIWaUNkzmP/3nHHm/YAkrtpZx1inrPmL5VhPEBsZ1mu8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oBFno-00A3IN-KP; Tue, 12 Jul 2022 15:19:48 +0200
Date:   Tue, 12 Jul 2022 15:19:48 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     Xu Liang <lxu@maxlinear.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/4] net: phy: mxl-gpy: fix version reporting
Message-ID: <Ys109F4n3960bgqz@lunn.ch>
References: <20220712131554.2737792-1-michael@walle.cc>
 <20220712131554.2737792-2-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220712131554.2737792-2-michael@walle.cc>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 12, 2022 at 03:15:51PM +0200, Michael Walle wrote:
> The commit 09ce6b20103b ("net: phy: mxl-gpy: add temperature sensor")
> will overwrite the return value and the reported version will be wrong.
> Fix it.
> 
> Fixes: 09ce6b20103b ("net: phy: mxl-gpy: add temperature sensor")
> Signed-off-by: Michael Walle <michael@walle.cc>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
