Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 378C3559855
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 13:11:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230488AbiFXLLF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 07:11:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbiFXLLE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 07:11:04 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 106A256C36;
        Fri, 24 Jun 2022 04:11:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=lw72Svz/s5Op9EKKkC8WwBc51rXr7wxqnOH5BBs08Js=; b=xjApAEUt+BBKjvM7Rysw0SKL0I
        x4h/9q+rM8mkRvdYISc27sj7F8/V6KAih90QtHnFV7xUVeC3j8aimJhwbsyxsB+1/I+ehsHyKhT9Z
        rB9+zsh7N5WnO5utGMaYdHAhTYTmHrNiQp6pFPGlpSmvq0I/iIx2eyJ72knJrV5XCVyc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1o4hCv-0083vq-N3; Fri, 24 Jun 2022 13:10:37 +0200
Date:   Fri, 24 Jun 2022 13:10:37 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        Raju Lakkaraju <Raju.Lakkaraju@microchip.com>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] net: lan743x: Use correct variable in
 lan743x_sgmii_config()
Message-ID: <YrWbrdSnZqcPFhjs@lunn.ch>
References: <YrRry7K66BzKezl8@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YrRry7K66BzKezl8@kili>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 23, 2022 at 04:34:03PM +0300, Dan Carpenter wrote:
> There is a copy and paste bug in lan743x_sgmii_config() so it checks
> if (ret < 0) instead of if (mii_ctl < 0).
> 
> Fixes: 46b777ad9a8c ("net: lan743x: Add support to SGMII 1G and 2.5G")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
