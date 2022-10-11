Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7475FB29C
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 14:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbiJKMo5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 08:44:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbiJKMoz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 08:44:55 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D93682EF2D;
        Tue, 11 Oct 2022 05:44:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=aSMPgjswa0b5a8/jRySNmwzxT/MJQufut7Bj0GfUTMc=; b=zmGh1ZUWlzJAhBOMGcl7GmO3FV
        FB75xhNGi0Z4LfgCJe8FTwOtMotLRvYYfbmG9/N5UpZJFVvszoNqhduCajBYsUzIluU3ZV5IurBjM
        xWuRuxV5fgdSd+eenZL2dre/OmgozZek88ADe41czljP3sej1qsvTTpcTsl++L46t8AE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oiEcl-001iF2-P1; Tue, 11 Oct 2022 14:44:43 +0200
Date:   Tue, 11 Oct 2022 14:44:43 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: ethernet: ti: am65-cpsw: set correct devlink
 flavour for unused ports
Message-ID: <Y0VlO280Am0Er1lL@lunn.ch>
References: <20221011075002.3887-1-matthias.schiffer@ew.tq-group.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221011075002.3887-1-matthias.schiffer@ew.tq-group.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 11, 2022 at 09:50:02AM +0200, Matthias Schiffer wrote:
> am65_cpsw_nuss_register_ndevs() skips calling devlink_port_type_eth_set()
> for ports without assigned netdev, triggering the following warning when
> DEVLINK_PORT_TYPE_WARN_TIMEOUT elapses after 3600s:
> 
>     Type was not set for devlink port.
>     WARNING: CPU: 0 PID: 129 at net/core/devlink.c:8095 devlink_port_type_warn+0x18/0x30
> 
> Fixes: 0680e20af5fb ("net: ethernet: ti: am65-cpsw: Fix devlink port register sequence")
> Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
