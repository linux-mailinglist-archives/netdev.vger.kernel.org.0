Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C949E624D85
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 23:12:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbiKJWMb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 17:12:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiKJWMa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 17:12:30 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAE662F01A
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 14:12:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=I9sTB+jvGuTAmUH2W5/Z6LyZ8WpJD01sPLIjUfiSVAc=; b=mv4dIykQfaT95hNKl8V6NCla0B
        gzPe3GSw7YoYOFFfUN6qTy4+5ySNo0z490ShTF7VYUB/flwZx8jKhC9fogvaxPN1TFV2tToasLIOJ
        I63PS0VkDAGHFpzP1gB0V5a75EE13lTlt7qAEvwCyNDKLQ2Vc4uR34168OAwWH7wHbAc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1otFmH-0024Vv-72; Thu, 10 Nov 2022 23:12:05 +0100
Date:   Thu, 10 Nov 2022 23:12:05 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lukasz Majewski <lukma@denx.de>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 7/9] net: dsa: mv88e6071: Define max frame size (2048
 bytes)
Message-ID: <Y213NdYv3357ndij@lunn.ch>
References: <20221108082330.2086671-1-lukma@denx.de>
 <20221108082330.2086671-8-lukma@denx.de>
 <Y2pecZmradpWbtOn@lunn.ch>
 <20221110164236.5d24383d@wsk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221110164236.5d24383d@wsk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 10, 2022 at 04:42:36PM +0100, Lukasz Majewski wrote:
> Hi Andrew,
> 
> > On Tue, Nov 08, 2022 at 09:23:28AM +0100, Lukasz Majewski wrote:
> > > Accroding to the documentation - the mv88e6071 can support
> > > frame size up to 2048 bytes.  
> > 
> > Since the mv88e6020 is in the same family, it probably is the same?
> 
> Yes it is 2048 B
> 
> > And what about the mv88e66220?
> 
> You mean mv88e6220 ?

Upps, sorry, yes.

> 
> IIRC they are from the same family of ICs, so my guess :-) is that they
> also have the same value.

My point being, you created a new _ops structure when i don't think it
is needed.

   Andrew
