Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8DEE5A9D23
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 18:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234233AbiIAQbl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 12:31:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232665AbiIAQbj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 12:31:39 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 920BB62AB8;
        Thu,  1 Sep 2022 09:31:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=LS2Woa4LuC44oMA7jdjUMP7C74QvndhsN+0OPg570ho=; b=hiDoRMTUYB2AzZo6c4oNEWXuTY
        H7xyflAdZh1PxBlnzsU6luqs5zaHiwun4Het1j+FTqNVe3STnTtW2I+8NBIkIWVNyDf+AA9NQVOnW
        Q5ht1B6aulg/+vV8j/BnyDSfGFT/v6HjUzgNHcLewBJdXk5CgRVqw3Yk4tEYSgygx+80=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oTn5v-00FJtV-HL; Thu, 01 Sep 2022 18:31:07 +0200
Date:   Thu, 1 Sep 2022 18:31:07 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Frank Rowand <frowand.list@gmail.com>,
        linux-mtd@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, Ahmad Fatoum <a.fatoum@pengutronix.de>
Subject: Re: [PATCH v1 01/14] net: add helper eth_addr_add()
Message-ID: <YxDeS2hAgP5C/Bla@lunn.ch>
References: <20220825214423.903672-1-michael@walle.cc>
 <20220825214423.903672-2-michael@walle.cc>
 <1682967feab905d06402d0f8402799a8@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1682967feab905d06402d0f8402799a8@walle.cc>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 01, 2022 at 06:26:39PM +0200, Michael Walle wrote:
> Hi netdev maintainers,
> 
> Am 2022-08-25 23:44, schrieb Michael Walle:
> > Add a helper to add an offset to a ethernet address. This comes in handy
> > if you have a base ethernet address for multiple interfaces.
> > 
> > Signed-off-by: Michael Walle <michael@walle.cc>
> 
> Would it be possible to get an Ack for this patch, so I don't have
> to repost this large (and still growing) series to netdev every time?

Looks O.K. to me

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
