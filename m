Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D49E5E81D7
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 20:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbiIWSio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 14:38:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232827AbiIWSik (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 14:38:40 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8293411BCFE;
        Fri, 23 Sep 2022 11:38:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ZQ+PAIF1Jb4NIgEmf3aef9CJmpHHgPmanYlhQKVKIb4=; b=43jWBbcikQ7sQ+cRN+pRAh64Mk
        zfa4v03i/wl5JVQWzFiAGftpcNTSC8hkRylDL3Kejm+eRyS/F2z0c+1fTewNf5apcsBHzBf6EXnAh
        2md8A+m533oA+4Kv3h6evZAr/Qa6W4eVGCmzzrcSrv/S3UH42np72CSC7pFppuHnE5qI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1obnZL-0003I8-TU; Fri, 23 Sep 2022 20:38:35 +0200
Date:   Fri, 23 Sep 2022 20:38:35 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@armlinux.org.uk,
        Tristram.Ha@microchip.com, prasanna.vengateshan@microchip.com,
        hkallweit1@gmail.com
Subject: Re: [Patch net-next v4 3/6] net: dsa: microchip: lan937x: return
 zero if mdio node not present
Message-ID: <Yy39K8KkGVQbSiAJ@lunn.ch>
References: <20220922071028.18012-1-arun.ramadoss@microchip.com>
 <20220922071028.18012-4-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220922071028.18012-4-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 22, 2022 at 12:40:25PM +0530, Arun Ramadoss wrote:
> Currently, if the mdio node is not present in the dts file then
> lan937x_mdio_register return -ENODEV and entire probing process fails.
> To make the mdio_register generic for all ksz series switches and to
> maintain back-compatibility with existing dts file, return -ENODEV is
> replaced with return 0.
> 
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
