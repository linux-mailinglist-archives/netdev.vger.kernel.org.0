Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDD4761563A
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 00:43:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbiKAXn0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 19:43:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiKAXnZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 19:43:25 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EF44B3;
        Tue,  1 Nov 2022 16:43:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=uVPf4j7a3B5h1KCjzXigT/lRxdYCMQbAWHHBU9OxKTw=; b=P1czFIhoa0bsder7d3VOYDVZkE
        M4VIdq95zpdJdAk35nm3UWq2cxtxLi8B7oGqkup98s5cuAgZ9atQvS8tK6xJdBea6SfslB5UUt2oH
        rgQ0KHKnaF5JCdXGS46W96eUOTj7sW/mGDDwGqUCGKXCqnnwlYGabj205wiCad9/5iYQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oq0uA-0019Ll-Pd; Wed, 02 Nov 2022 00:42:50 +0100
Date:   Wed, 2 Nov 2022 00:42:50 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Liu Peibao <liupeibao@loongson.cn>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>, chenhuacai@loongson.cn,
        lvjianmin@loongson.cn, zhuyinbo@loongson.cn,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] stmmac: dwmac-loongson: fix invalid mdio_node
Message-ID: <Y2Gu+h7MI+Eju6Ns@lunn.ch>
References: <20221101060218.16453-1-liupeibao@loongson.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221101060218.16453-1-liupeibao@loongson.cn>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 01, 2022 at 02:02:18PM +0800, Liu Peibao wrote:
> In current code "plat->mdio_node" is always NULL, the mdio
> support is lost as there is no "mdio_bus_data". The original
> driver could work as the "mdio" variable is never set to
> false, which is described in commit <b0e03950dd71> ("stmmac:
> dwmac-loongson: fix uninitialized variable ......"). And
> after this commit merged, the "mdio" variable is always
> false, causing the mdio supoort logic lost.
> 
> Fixes: 30bba69d7db4 ("stmmac: pci: Add dwmac support for Loongson")
> Signed-off-by: Liu Peibao <liupeibao@loongson.cn>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
