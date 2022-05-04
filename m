Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 651AD51B166
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 23:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239194AbiEDV5C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 17:57:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbiEDV5B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 17:57:01 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 447CD5007E;
        Wed,  4 May 2022 14:53:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=6FQAlfBFwtEMoTlqGcYaL8W2/p5ReaYxjD8uG1edIvU=; b=Jmsphw7xyQ2GuCamtRaHEYjBXg
        HiKMTj4v5Co69T8YNSbq6inEY1fSQHEhTyZ6LtNpyfROIqxTnyLQmfTSfQF/1aY5Jfi0oQ9d+BHp7
        6xodyE/hMNideVcyxc8TSF6fu3VgbEG6JhjCYHWFwjXfTwpV07edD36Pi47b5HvrFk9Y=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nmMvs-001Ggn-HF; Wed, 04 May 2022 23:53:16 +0200
Date:   Wed, 4 May 2022 23:53:16 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Fabio Estevam <festevam@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        netdev <netdev@vger.kernel.org>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Fabio Estevam <festevam@denx.de>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH net v2 1/2] net: phy: micrel: Do not use
 kszphy_suspend/resume for KSZ8061
Message-ID: <YnL1zI5eJVZxvyki@lunn.ch>
References: <20220504143104.1286960-1-festevam@gmail.com>
 <CAOMZO5DU8XRCGaYOcGeHimgupqMksyLXsjL=R8JHajSBs4KAeg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMZO5DU8XRCGaYOcGeHimgupqMksyLXsjL=R8JHajSBs4KAeg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> If this series gets applied, I plan to submit two patches targeting net-next to:
> 
> 1. Allow .probe to be called without .data_driver being passed
> 2. Convert KSZ8061 to use .probe and kszphy_suspend/resume

Great.

Please wait at least a week so that net gets merged into net-next, so
there are no merge conflicts.

Thanks
	Andrew
