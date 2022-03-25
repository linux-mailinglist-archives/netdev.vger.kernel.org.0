Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 317964E7CE0
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 01:22:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230314AbiCYTg7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 15:36:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbiCYTg2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 15:36:28 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C2EC26F908;
        Fri, 25 Mar 2022 12:23:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=N+ZKC7KCwSTRxeetW0K6zqFJCKV7rg/oKwuvDGiPjl8=; b=p4y3L+qBksbg1GShFM894Uqzzu
        YpZuIueXVziRHbN7NaFWlzeIpK+AXEYk2c2GgArL1Ahxk8OR9MCBSI1N9llU+qv5afsWtErCE8XEG
        dhk05jKd29HqeOuC0BTf+P4+k7VLXMmLdSG23yUFKyEzv4r7nxbALRN9+Vg9j3srrn0c=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nXpWZ-00CgJe-IX; Fri, 25 Mar 2022 20:23:03 +0100
Date:   Fri, 25 Mar 2022 20:23:03 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Andy Chiu <andy.chiu@sifive.com>
Cc:     radhey.shyam.pandey@xilinx.com, robert.hancock@calian.com,
        michal.simek@xilinx.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org, linux@armlinux.org.uk,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        robh@kernel.org, Greentime Hu <greentime.hu@sifive.com>
Subject: Re: [PATCH v5 net 3/4] dt-bindings: net: add pcs-handle attribute
Message-ID: <Yj4Wl0zmDtnbxgDb@lunn.ch>
References: <20220323180022.864567-1-andy.chiu@sifive.com>
 <20220323180022.864567-4-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220323180022.864567-4-andy.chiu@sifive.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> + - pcs-handle: 	  Phandle to the internal PCS/PMA PHY in SGMII or 1000Base-X
> +		  modes, where "pcs-handle" should be preferably used to point
> +		  to the PCS/PMA PHY, and "phy-handle" should point to an
> +		  external PHY if exists.

Since this is a new property, you don't have any backwards
compatibility to worry about, don't use 'preferably'. It should point
to the PCS/PCA PHY and anything else is wrong for this new property.

   Andrew
