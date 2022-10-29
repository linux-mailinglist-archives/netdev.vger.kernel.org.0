Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC9A6123ED
	for <lists+netdev@lfdr.de>; Sat, 29 Oct 2022 16:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbiJ2Ojn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Oct 2022 10:39:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbiJ2Ojj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Oct 2022 10:39:39 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38BBC10F4;
        Sat, 29 Oct 2022 07:39:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=2dglrjsFiG4DIT+B05PLH7PMZ7VjFIIbT/WijiPDScU=; b=DjIEOQws6bPXGlhq79OR/d6X0a
        EQxaork/HTnqI7ly3naUMPM/p+r+ybrGUtZRTZaLHWuvDoNWtPnBn+K+LiYn2lTUiUjAIdYHHm3k9
        wrUx2SCHrBnSVU/Gk1ddquH2HUSPj2831rx3E157sDuenQjulksoDyqiecf0JhJ4ux2U=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oomyp-000uFe-UH; Sat, 29 Oct 2022 16:38:35 +0200
Date:   Sat, 29 Oct 2022 16:38:35 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Frank <Frank.Sae@motor-comm.com>
Cc:     Peter Geis <pgwipeout@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, yinghong.zhang@motor-comm.com,
        fei.zhang@motor-comm.com, hua.sun@motor-comm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v8.2] net: phy: Add driver for Motorcomm yt8521
 gigabit ethernet phy
Message-ID: <Y106640hN5Q5mtOv@lunn.ch>
References: <20221028092621.1061-1-Frank.Sae@motor-comm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221028092621.1061-1-Frank.Sae@motor-comm.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 28, 2022 at 05:26:21PM +0800, Frank wrote:
>  Add a driver for the motorcomm yt8521 gigabit ethernet phy. We have verified
>  the driver on StarFive VisionFive development board, which is developed by
>  Shanghai StarFive Technology Co., Ltd.. On the board, yt8521 gigabit ethernet
>  phy works in utp mode, RGMII interface, supports 1000M/100M/10M speeds, and
>  wol(magic package).
> 
> Signed-off-by: Frank <Frank.Sae@motor-comm.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
