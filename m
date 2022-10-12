Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C2665FC553
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 14:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbiJLMb3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 08:31:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbiJLMb2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 08:31:28 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADD01BE2F5;
        Wed, 12 Oct 2022 05:31:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=8M3Z6wLe6eoY/cEb4VbrsvOWCsbcc8c1UTHEJYNe/mc=; b=fCZp5XI+bjl88Wf0DbWiNuXufH
        nG7QWIGkitwwJIvsirFikWHxcxyDczxFz5iIhdCrCZl+bWCl72DDVprG5mZ6bcJkTKSYp2a9k9mya
        yiLPWBCvaz8VjTD0NGxag7Djnkqvnu+3V17WH/wA6HelckqoEGJAUABxnbVolejo9TJw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oiatL-001ngz-PF; Wed, 12 Oct 2022 14:31:19 +0200
Date:   Wed, 12 Oct 2022 14:31:19 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pawel Dembicki <paweldembicki@gmail.com>,
        Lech Perczak <lech.perczak@gmail.com>
Subject: Re: [net PATCH 1/2] net: dsa: qca8k: fix inband mgmt for big-endian
 systems
Message-ID: <Y0azl81l/jIWuZUU@lunn.ch>
References: <20221010111459.18958-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221010111459.18958-1-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 10, 2022 at 01:14:58PM +0200, Christian Marangi wrote:
> The header and the data of the skb for the inband mgmt requires
> to be in little-endian. This is problematic for big-endian system
> as the mgmt header is written in the cpu byte order.
> 
> Fix this by converting each value for the mgmt header and data to
> little-endian, and convert to cpu byte order the mgmt header and
> data sent by the switch.
> 
> Fixes: 5950c7c0a68c ("net: dsa: qca8k: add support for mgmt read/write in Ethernet packet")
> Tested-by: Pawel Dembicki <paweldembicki@gmail.com>
> Tested-by: Lech Perczak <lech.perczak@gmail.com>
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> Reviewed-by: Lech Perczak <lech.perczak@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
