Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 910E44F4520
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 00:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355503AbiDEOYA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 10:24:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381716AbiDENOn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 09:14:43 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C6BC127590;
        Tue,  5 Apr 2022 05:18:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=g8HbdxageWMZjW4MNTzRzqXFH334Zm1UWoKjrVxSyuc=; b=C9gZOFUXwcrudSR2zBQ8Y7EV4j
        mdO5X1aR4sYmlOOyRhrKyjQjHIiRN781rYJxt/Zi9492igAQu3H1pPWP4bEhxlNazgb2rwRuxqoTH
        9Dh252ZB286S5EDLtH6pJFVl5tjvmoj7In16nSBW0uNgV8UYYNRfa8RAgSTNuUDbz4v4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nbi8J-00EFNn-Uo; Tue, 05 Apr 2022 14:18:03 +0200
Date:   Tue, 5 Apr 2022 14:18:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Andy Chiu <andy.chiu@sifive.com>
Cc:     davem@davemloft.net, michal.simek@xilinx.com,
        radhey.shyam.pandey@xilinx.com, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzk+dt@kernel.org, linux@armlinux.org.uk,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        Greentime Hu <greentime.hu@sifive.com>,
        Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v8 net-next 3/4] dt-bindings: net: add pcs-handle
 attribute
Message-ID: <Ykwze3+VW4LtBb7j@lunn.ch>
References: <20220405091929.670951-1-andy.chiu@sifive.com>
 <20220405091929.670951-4-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220405091929.670951-4-andy.chiu@sifive.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 05, 2022 at 05:19:28PM +0800, Andy Chiu wrote:
> Document the new pcs-handle attribute to support connecting to an
> external PHY. For Xilinx's AXI Ethernet, this is used when the core
> operates in SGMII or 1000Base-X modes and links through the internal
> PCS/PMA PHY.
> 
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> Reviewed-by: Greentime Hu <greentime.hu@sifive.com>
> Reviewed-by: Rob Herring <robh@kernel.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
