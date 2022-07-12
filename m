Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47D3A571B35
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 15:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232869AbiGLN1q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 09:27:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbiGLN1p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 09:27:45 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72EB8904DB;
        Tue, 12 Jul 2022 06:27:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=GeBXHzaR9hFbNi2rsIvOiJSjHq9fAExMloziB95EMUE=; b=V+oUzrIn7OyuULfkM8jc8uIeM/
        6PQQ1LvQ8inlh9SbFMk0HnMP9C+trqbaWo9si/3wpN+YtTLvrsfjFQM4iowRT9qt/ydUexQZPULb8
        7EQ649RrQ6mfQzid78/+c5EmrfQtxkDfoyl4viwYarZGKVEPGLSJJa0kvaQCj+WUGqFA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oBFvL-00A3LL-JD; Tue, 12 Jul 2022 15:27:35 +0200
Date:   Tue, 12 Jul 2022 15:27:35 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     Xu Liang <lxu@maxlinear.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 4/4] net: phy: mxl-gpy: print firmware in human
 readable form
Message-ID: <Ys12x5tqJkhav5AV@lunn.ch>
References: <20220712131554.2737792-1-michael@walle.cc>
 <20220712131554.2737792-5-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220712131554.2737792-5-michael@walle.cc>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 12, 2022 at 03:15:54PM +0200, Michael Walle wrote:
> Now having a major and a minor number, also print the firmware in
> human readable form "major.minor". Still keep the 4-digit hexadecimal
> representation because that form is used in the firmware changelog
> documents. Also, drop the "release" string assuming that most common
> case, but make it clearer that the user is running a test version.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>

O.K, this answers my earlier question :-)

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
