Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6C5262EA11
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 01:07:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240332AbiKRAHo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 19:07:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232050AbiKRAHn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 19:07:43 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02584D94;
        Thu, 17 Nov 2022 16:07:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=wv0rvg+qGKsAcuFlpcEuCbIUu5ZxBnWHri6DHVe34qM=; b=eJpO91RR72W5+FtReIbXj9YpnF
        UgtpfDtz73IFT43IR566O3HGWcpc1IAtBKPeRKMfyNoAr4+c/foJCODDoijtPztc7lWW8z6Y7odrA
        KyKEkvMb+1cMD+oi95YAvMEJWY+Xj39t5LMghRPcpOef96VANYI9IASt5OItnjdn1Mfs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ovouw-002kA8-Id; Fri, 18 Nov 2022 01:07:38 +0100
Date:   Fri, 18 Nov 2022 01:07:38 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Andy Chiu <andy.chiu@sifive.com>
Cc:     davem@davemloft.net, kuba@kernel.org, michal.simek@xilinx.com,
        radhey.shyam.pandey@xilinx.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        robh+dt@kernel.org, pabeni@redhat.com, edumazet@google.com,
        greentime.hu@sifive.com
Subject: Re: [PATCH v5 net-next 3/3] net: axienet: set mdio clock according
 to bus-frequency
Message-ID: <Y3bMyjEWk73oabnA@lunn.ch>
References: <20221117154014.1418834-1-andy.chiu@sifive.com>
 <20221117154014.1418834-4-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221117154014.1418834-4-andy.chiu@sifive.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 17, 2022 at 11:40:14PM +0800, Andy Chiu wrote:
> Some FPGA platforms have 80KHz MDIO bus frequency constraint when
> connecting Ethernet to its on-board external Marvell PHY. Thus, we may
> have to set MDIO clock according to the DT. Otherwise, use the default
> 2.5 MHz, as specified by 802.3, if the entry is not present.
> 
> Also, change MAX_MDIO_FREQ to DEFAULT_MDIO_FREQ because we may actually
> set MDIO bus frequency higher than 2.5MHz if undelying devices support
> it. And properly disable the mdio bus clock in error path.
> 
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
