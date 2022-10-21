Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41FA5606D88
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 04:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbiJUCU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 22:20:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbiJUCU6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 22:20:58 -0400
Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D0A71EA562;
        Thu, 20 Oct 2022 19:20:58 -0700 (PDT)
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-1364357a691so1886327fac.7;
        Thu, 20 Oct 2022 19:20:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9WCJTRSJ650T37gl1fy1TLSM1yvaFdecsLly4ZCAwt0=;
        b=HcPAFm82Per3d4CnKS5bPFNhXCDTKDrKsrCqnciiXQ3E45M6xbMcm4YpJaTP0sy7LV
         iI+6IcT+bPxayi8857fdRpysnzdbG7gUC4Wv2JH/Wu+FdUcb5XYHCwZNStLxestP3YfJ
         uRiYHDd54IGAXWZBL8PrBVBXpbrYC6jUaJ0WocC1PArltHtCpHIDCCDuMuY48/w6EjZa
         NIOPTHcl6XuCUlsEsQWfxGsLyvyEHPHdub+HPTwC+cDHALcazcRkKHlJ/vFnPdjpsTiX
         /WjFhC9BXJiFFQyZY/1UigfZtG+vWg/fUXRithbt1wYEq/1OrAAsK7S0oPX2nwLh8jKV
         pK2w==
X-Gm-Message-State: ACrzQf1x6/fCxFXD+KSPybEZ+Me+KQa8sBIHl1M4n9uYW3sgoYqE9vvn
        719Z956EzGLNeiiFQtiNGw==
X-Google-Smtp-Source: AMsMyM6gGWhuay0oXF9v3Bb7JNcNpcEv0REpfUvEIvxylDjtTOuL31vwGs7GIBhDgT7LTqjQRM6F7Q==
X-Received: by 2002:a05:6870:d7a4:b0:136:ddff:40c2 with SMTP id bd36-20020a056870d7a400b00136ddff40c2mr11147732oab.134.1666318857234;
        Thu, 20 Oct 2022 19:20:57 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id p21-20020a0568301d5500b0063695ad0cbesm560555oth.66.2022.10.20.19.20.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Oct 2022 19:20:56 -0700 (PDT)
Received: (nullmailer pid 2192274 invoked by uid 1000);
        Fri, 21 Oct 2022 02:20:58 -0000
Date:   Thu, 20 Oct 2022 21:20:58 -0500
From:   Rob Herring <robh@kernel.org>
To:     Michal Simek <michal.simek@amd.com>
Cc:     Andy Chiu <andy.chiu@sifive.com>, davem@davemloft.net,
        kuba@kernel.org, michal.simek@xilinx.com,
        radhey.shyam.pandey@xilinx.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        krzysztof.kozlowski+dt@linaro.org, pabeni@redhat.com,
        edumazet@google.com, greentime.hu@sifive.com
Subject: Re: [PATCH net-next 2/2] dt-bindings: add mdio frequency description
Message-ID: <20221021022058.GA2191302-robh@kernel.org>
References: <20221020094106.559266-1-andy.chiu@sifive.com>
 <20221020094106.559266-3-andy.chiu@sifive.com>
 <495eb398-bec4-5d68-ef5d-4f02d0122a7c@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <495eb398-bec4-5d68-ef5d-4f02d0122a7c@amd.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 20, 2022 at 12:39:46PM +0200, Michal Simek wrote:
> 
> 
> On 10/20/22 11:41, Andy Chiu wrote:
> > CAUTION: This message has originated from an External Source. Please use proper judgment and caution when opening attachments, clicking links, or responding to this email.
> > 
> > 
> > Add a property to set mdio bus frequency at runtime by DT.
> > 
> > Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> > Reviewed-by: Greentime Hu <greentime.hu@sifive.com>
> > ---
> >   Documentation/devicetree/bindings/net/xilinx_axienet.txt | 3 +++
> >   1 file changed, 3 insertions(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/net/xilinx_axienet.txt b/Documentation/devicetree/bindings/net/xilinx_axienet.txt
> > index 1aa4c6006cd0..d78cf402aa2a 100644
> > --- a/Documentation/devicetree/bindings/net/xilinx_axienet.txt
> > +++ b/Documentation/devicetree/bindings/net/xilinx_axienet.txt
> > @@ -43,6 +43,9 @@ Optional properties:
> >                    support both 1000BaseX and SGMII modes. If set, the phy-mode
> >                    should be set to match the mode selected on core reset (i.e.
> >                    by the basex_or_sgmii core input line).
> > +- xlnx,mdio-freq: Define the clock frequency of the MDIO bus. If the property
> > +                 does not pressent on the DT, then the mdio driver would use
> > +                 the default 2.5 MHz clock, as mentioned on 802.3 spc.
> 
> Isn't it better to specify it based on ccf description. It means &clk and
> used clock framework to find value?

Or use 'bus-frequency' which IIRC is defined for MDIO.

Rob
