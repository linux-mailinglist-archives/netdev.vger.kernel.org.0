Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9FC95200CF
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 17:12:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238138AbiEIPQI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 11:16:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238078AbiEIPP4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 11:15:56 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9BA115E624;
        Mon,  9 May 2022 08:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=pqsJDz6qnnvShqx1Sral3htZd6sOhUooH5JnGt+uNbA=; b=nl/ZNhhfBjpKQcfCiuuktzjyYF
        7hzJCoDh+Z4e21DuYXpsouSMiCAjGQFIO2m/d3/wkURLxL5MY46JA/QOEPbVsbAhoy62WXWD4qGUR
        cw/L0waUJLGU3WOMfPy/Dd8hMzm6G641/Yn+oonq7SI7tletQQubpJTfAa/2RUtRVrHg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1no535-001xeg-BT; Mon, 09 May 2022 17:11:47 +0200
Date:   Mon, 9 May 2022 17:11:47 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Wan Jiabing <wanjiabing@vivo.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net] net: phy: micrel: Fix incorret variable type in
 micrel
Message-ID: <YnkvM5iuSuAOqBg+@lunn.ch>
References: <20220509144519.2343399-1-wanjiabing@vivo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220509144519.2343399-1-wanjiabing@vivo.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 09, 2022 at 10:45:19PM +0800, Wan Jiabing wrote:
> In lanphy_read_page_reg, calling __phy_read() might return a negative
> error code. Use 'int' to check the error code.
> 
> Fixes: 7c2dcfa295b1 ("net: phy: micrel: Add support for LAN8804 PHY")
> Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
