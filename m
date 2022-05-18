Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B43C52C2C6
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 20:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241672AbiERSxQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 14:53:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241708AbiERSxO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 14:53:14 -0400
Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE6D020EE20;
        Wed, 18 May 2022 11:53:10 -0700 (PDT)
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-e5e433d66dso3914370fac.5;
        Wed, 18 May 2022 11:53:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=8MjJCE/8K8+TV18DiRjp4WnXk9vy6w8u4Ub+xfkaiUo=;
        b=NWb6Q3Xp8TjvfEuECfIQr9df1jw+ayPwuRvx0niNBQuVXPSTM+UUV9YoaOuxuK70MH
         C2pCHplp1VP4eV5d0Pkihl3CYLiitDTRasrd+7p/pYXn+DV89pSXfMOKLllydTfH8NeF
         7mRQub4QFL+L6RR4mfEjJhA+SRKn9X+zHqtPYelTGz0gstgzPRNP5StkaljSpjCOS0Lq
         hJKA51WujP9e9c8K4GzLG7mBFm8hsli0kcmWSUjyNZAzQ3EkU7kVgoHwjV+IDP5DcEMe
         T09kJRO94G5ogh7TMRGPX24aDGQmFNkOZzkFi+Iia2gp6lr3twPg9GB3BZ6KSMNxpOxg
         m7oQ==
X-Gm-Message-State: AOAM531rZ1Jh8K+slVqKDs6Wjlg0WgEukSX7nEhxc664egcU3G5Gj/5J
        piGvk4IjSs5kLkyCKqhEbA==
X-Google-Smtp-Source: ABdhPJw+P/6QyDD9F7P5YoNd1qUPUMDZ8vwFg4Y7o7BJFW/d3h8QUhanxfXSfGfLfywzFxVJbjIodA==
X-Received: by 2002:a05:6870:f61a:b0:f1:7484:8eca with SMTP id ek26-20020a056870f61a00b000f174848ecamr546312oab.107.1652899989566;
        Wed, 18 May 2022 11:53:09 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id a9-20020a056870618900b000edda81f868sm1267659oah.10.2022.05.18.11.53.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 11:53:08 -0700 (PDT)
Received: (nullmailer pid 3685342 invoked by uid 1000);
        Wed, 18 May 2022 18:53:07 -0000
Date:   Wed, 18 May 2022 13:53:07 -0500
From:   Rob Herring <robh@kernel.org>
To:     =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?iso-8859-1?Q?Miqu=E8l?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v4 05/12] dt-bindings: net: dsa: add bindings
 for Renesas RZ/N1 Advanced 5 port switch
Message-ID: <20220518185307.GL3302100-robh@kernel.org>
References: <20220509131900.7840-1-clement.leger@bootlin.com>
 <20220509131900.7840-6-clement.leger@bootlin.com>
 <20220511152221.GA334055-robh@kernel.org>
 <20220511153337.deqxawpbbk3actxf@skbuf>
 <20220518015924.GC2049643-robh@kernel.org>
 <20220518120503.3m2zfw7kmhsfg336@skbuf>
 <20220518144111.135c7d0d@fixe.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220518144111.135c7d0d@fixe.home>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 18, 2022 at 02:41:11PM +0200, Clément Léger wrote:
> Le Wed, 18 May 2022 15:05:03 +0300,
> Vladimir Oltean <olteanv@gmail.com> a écrit :
> 
> > On Tue, May 17, 2022 at 08:59:24PM -0500, Rob Herring wrote:
> > > On Wed, May 11, 2022 at 06:33:37PM +0300, Vladimir Oltean wrote:  
> > > > On Wed, May 11, 2022 at 10:22:21AM -0500, Rob Herring wrote:  
> > > > > > +patternProperties:
> > > > > > +  "^ethernet-ports$":  
> > > > > 
> > > > > Move to 'properties', not a pattern.
> > > > > 
> > > > > With that,
> > > > > 
> > > > > Reviewed-by: Rob Herring <robh@kernel.org>  
> > > > 
> > > > Even if it should have been "^(ethernet-)?ports$"?  
> > > 
> > > Why? Allowing 'ports' is for existing users. New ones don't need the 
> > > variability and should use just 'ethernet-ports'.
> > > 
> > > Rob  
> > 
> > Yeah, ok, somehow the memo that new DSA drivers shouldn't support "ports"
> > didn't reach me. They invariably will though, since the DSA framework is
> > the main parser of the property, and that is shared by both old and new
> > drivers.
> 
> Should also the subnodes of "ethernet-ports" use the
> "ethernet-port@[0-9]*" naming ? Or keeping the existing pattern is ok
> (ie "^(ethernet-)?port@[0-4]$") ?

I prefer the former, but care less. The whole reason for 'ethernet-' 
prefix is to make this distinct from the graph binding that uses ports 
and port.

Rob
