Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A15F5B27AF
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 22:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbiIHU0N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 16:26:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbiIHU0L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 16:26:11 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1943ED2B39;
        Thu,  8 Sep 2022 13:26:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=FAlGaLlUAtfaE4iIGxhp2DLAFKjHtKdEMLcHmqOjh5I=; b=kMfOI1tvtovnNXqTbT03edDZdd
        cz+sN/41YnKEThh1ZXkm+/Xz2mQHUnn2P6eejBzjlLbd7GU/MfVCTdTwm3g/5VQDT1AQNIlIVHt/G
        voV02MS+P5nCo/V8JC+XdyZ+N1xgN+UVmoy0J7RY96ELrrHsaG6LDwrntMCi8eBrbNbo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oWO5e-00G0Yh-NE; Thu, 08 Sep 2022 22:25:34 +0200
Date:   Thu, 8 Sep 2022 22:25:34 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jingyu Wang <jingyuwang_vip@163.com>
Cc:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ipv4: Fix some coding style in ah4.c file
Message-ID: <YxpPvoejMMNliCrg@lunn.ch>
References: <20220908022118.57973-1-jingyuwang_vip@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220908022118.57973-1-jingyuwang_vip@163.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -165,7 +165,8 @@ static int ah_output(struct xfrm_state *x, struct sk_buff *skb)
>  	ahp = x->data;
>  	ahash = ahp->ahash;
>  
> -	if ((err = skb_cow_data(skb, 0, &trailer)) < 0)
> +	err = skb_cow_data(skb, 0, &trailer));

I prefer the coding style issue over it not compiling at all.

I suggest you don't embarrass yourself any more by compile testing
your changes.

     Andrew
