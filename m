Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ECF060CBB7
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 14:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230469AbiJYMZq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 08:25:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230294AbiJYMZo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 08:25:44 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87C1A11A95C
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 05:25:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=OrYkcL3FU3lBnzrVrd4qigZWw48YJxVfoA/kAXx5de8=; b=GISyhBTgWuElsGch8kE7ExRok8
        lupM/PXpyCgWvm5cfrbddwsN4TqY8ZLWhXkhGU+W9lMAPLYlwhNGxxwUKFdMCel3H8tpEV5PWmprH
        8ZD/ovBTEjRLiBqEbupvf6auAhyXNr/L2hwi9XRTWiXyE0k1pLT4JRKB/HTcU0IvR0m8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1onIzd-000WvA-DA; Tue, 25 Oct 2022 14:25:17 +0200
Date:   Tue, 25 Oct 2022 14:25:17 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Fabio Estevam <festevam@gmail.com>
Cc:     kuba@kernel.org, dmurphy@ti.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dp83822: Print the SOR1 strap status
Message-ID: <Y1fVrectVW3Ki9WQ@lunn.ch>
References: <20221025120109.779337-1-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221025120109.779337-1-festevam@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 25, 2022 at 09:01:09AM -0300, Fabio Estevam wrote:
> During the bring-up of the Ethernet PHY, it is very useful to
> see the bootstrap status information, as it can help identifying
> hardware bootstrap mistakes.
> 
> Allow printing the SOR1 register, which contains the strap status
> to ease the bring-up.
> 
> Signed-off-by: Fabio Estevam <festevam@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
