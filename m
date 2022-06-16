Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E07C54E9E5
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 21:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377090AbiFPTR4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 15:17:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230305AbiFPTRz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 15:17:55 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3678140BB;
        Thu, 16 Jun 2022 12:17:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Ca+bIvPNi/dtQkS9WR53dqw4kd5pgFoBDQaG1qfGWeI=; b=aicN4PCo9xroI40wRfHwPqbvml
        kF07OcBR1CSWwd2oC6GlxXXNKQ6hCwYplVgR7Lg7DvfuD+cMkfykTifeWb6nMmhP8r7l+6ydGBJtD
        NM+WwiHpnYSrpUPwViu8v9lrukRvLWg7CHOSpGu4ck+8Q/xqyWg+DRkdKg47Ft4fXeUg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1o1v01-007EC3-Gk; Thu, 16 Jun 2022 21:17:49 +0200
Date:   Thu, 16 Jun 2022 21:17:49 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, lxu@maxlinear.com,
        davem@davemloft.net, linux-kernel@vger.kernel.org,
        bryan.whitehead@microchip.com, richardcochran@gmail.com,
        UNGLinuxDriver@microchip.com, Ian.Saturley@microchip.com
Subject: Re: [PATCH net-next V2 3/4] net: lan743x: Add support to SGMII 1G
 and 2.5G
Message-ID: <YquB3dl7mWXvKn9V@lunn.ch>
References: <20220616041226.26996-1-Raju.Lakkaraju@microchip.com>
 <20220616041226.26996-4-Raju.Lakkaraju@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220616041226.26996-4-Raju.Lakkaraju@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 16, 2022 at 09:42:25AM +0530, Raju Lakkaraju wrote:
> Add SGMII access read and write functions
> Add support to SGMII 1G and 2.5G for PCI11010/PCI11414 chips
> 
> Signed-off-by: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

  
