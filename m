Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C63865BAEA8
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 15:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbiIPNzg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 09:55:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231844AbiIPNzE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 09:55:04 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F5EEEE36
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 06:54:44 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id cc5so26314607wrb.6
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 06:54:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date;
        bh=iZCw1bvItnQlpkNTaYlkvb1YmIymF+p9kkK7I7WyU3c=;
        b=pvpfHU48R/zvX3XAped8Dp9wVAub9OdEOZnMVENWA0xfg7UwB2KyOi5RSo/H7K7EFB
         a6TTRm4o/gOJGPXOE8UoDfKJmdWaE02xWL+iVy9FxT6ctlDio2DfRskgouWdURFKYp2H
         48XWQ9tz7ouobMtDiq7AvX5tvdcShWXWFb0/lPREnvjU3D+gGsHFt502CRczzNNsdZyG
         73IfrI2Fao9a5KX6kSoVaeLCob2sOu2h7RAvULCkVqN1gRXrwmkbSNvqHLxGekdFzwUT
         /6RtH6fCuhdk/f709IhpeYc483D1pDSPStEKRP0P8m4R9x9lK0+iZD4l3XbVVbwymXNt
         2OFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=iZCw1bvItnQlpkNTaYlkvb1YmIymF+p9kkK7I7WyU3c=;
        b=bOZwirsZeZs5jqypRDVOdxkHI5pvvP1Xy3iNNogiCEMM8FA9SJD028nLlPbJLEsc8z
         IWysizaTjx2ipV/hcd1eeW+s0BQ9qPi6LCH1kG0s+TzFXRO0TW/9KTDl7CWHcMCIYgvv
         NbobQhkXVfjEDpwHGL4X6yHRUTvffdA3qddT4qi+yuT3+vEbAnFqqX2GCv5qXamVuAQf
         TytEFUvLhu4VNSCeN+UgCSKgMDB87TE/a4XgFaandMJShFyp483QGmUY04W+YoElzqeY
         bVqVCtHpD7RvF0GLKUresFv5RN8sXGfcotWfGrhEn9i6cQXC2SyZy3vWKyuBT9foWECh
         5LfQ==
X-Gm-Message-State: ACrzQf1ajDTq5quED7uVXch8SXHfm3gs0qj+rHy2miNQ2AAwKIzj+dXG
        2LEahzxJSf1t1qTWpW6HmOkOs4xBoRI=
X-Google-Smtp-Source: AMsMyM6yC6uJwcM+DVPfe+fgo3QTQL4cZz7MIwKH28eCus/X21iQXI2i+JTg3e6jawlCToGkQ+iDSw==
X-Received: by 2002:a05:6000:81e:b0:228:a17f:92f0 with SMTP id bt30-20020a056000081e00b00228a17f92f0mr3036900wrb.31.1663336482935;
        Fri, 16 Sep 2022 06:54:42 -0700 (PDT)
Received: from Ansuel-xps. (93-42-70-134.ip85.fastwebnet.it. [93.42.70.134])
        by smtp.gmail.com with ESMTPSA id c18-20020adffb52000000b002252ec781f7sm5099616wrs.8.2022.09.16.06.54.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Sep 2022 06:54:42 -0700 (PDT)
Message-ID: <63248022.df0a0220.ce30f.be52@mx.google.com>
X-Google-Original-Message-ID: <YyQXMMAJb/3SEpBS@Ansuel-xps.>
Date:   Fri, 16 Sep 2022 08:26:56 +0200
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Mattias Forsblad <mattias.forsblad@gmail.com>,
        netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux@armlinux.org.uk
Subject: Re: [PATCH net-next v13 2/6] net: dsa: Add convenience functions for
 frame handling
References: <20220916121817.4061532-1-mattias.forsblad@gmail.com>
 <20220916121817.4061532-3-mattias.forsblad@gmail.com>
 <63247bbd.5d0a0220.2e1d3.e804@mx.google.com>
 <20220916134757.migsntozviogv2jh@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220916134757.migsntozviogv2jh@skbuf>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DATE_IN_PAST_06_12,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 16, 2022 at 04:47:57PM +0300, Vladimir Oltean wrote:
> On Fri, Sep 16, 2022 at 08:06:38AM +0200, Christian Marangi wrote:
> > > +static inline void dsa_switch_inband_complete(struct dsa_switch *ds, struct completion *completion)
> > > +{
> > > +	/* Custom completion? */
> > > +	complete(completion ?: &ds->inband_done);
> >
> > Missing handling for custom completion!
> >
> > Should be
> >
> > complete(completion ? completion : &ds->inband_done);
> 
> !!!!
> 
> https://en.wikipedia.org/wiki/%3F:#C
> https://en.wikipedia.org/wiki/Elvis_operator
> 
> | A GNU extension to C allows omitting the second operand, and using
> | implicitly the first operand as the second also:
> |
> | a == x ? : y;
> |
> | The expression is equivalent to
> |
> | a == x ? (a == x) : y;
> |
> | except that if x is an expression, it is evaluated only once. The
> | difference is significant if evaluating the expression has side effects.
> | This shorthand form is sometimes known as the Elvis operator in other
> | languages.
> 
> cat ternary.c
> #include <stdio.h>
> 
> int main(void)
> {
> 	printf("%d\n", 3 ?: 4);
> 	return 0;
> }
> 
> make ternary
> ./ternary
> 3

Oh well! The more you know ahahha.

Then sorry for the wrong review but still wouldn't be more
clear/readable with full syntax?

-- 
	Ansuel
