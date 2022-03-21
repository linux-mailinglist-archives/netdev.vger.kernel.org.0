Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1FB34E34E6
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 00:49:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233120AbiCUXqM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 19:46:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233103AbiCUXqL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 19:46:11 -0400
Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 411A5644D0;
        Mon, 21 Mar 2022 16:44:45 -0700 (PDT)
Received: by mail-oi1-f170.google.com with SMTP id q129so15944654oif.4;
        Mon, 21 Mar 2022 16:44:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8XhbM+yCSMWpV6YWusJua/ZId6n1RrQHIFkS4TPE+Mk=;
        b=Lz/m4dWIuGShMQBf+qJELaheuIBWNzewT1667lzl83UKSMAE8jbd7Qe5hrNAh3Rgij
         LSY/qQ8ihzE5vIVDj3SLnFbJKPCEHnIgGpS8NT3nqV+Zevlt7tRgiatyqN8gY+Jti+7G
         7VT6e0rWPydmqZR6FACuclA2wRR3tlfSLuv42ZVsRwp/rmcDUI+PJLy4uAExeOvsWb9p
         oVTk2MnzFC7pLjP9xqD6vy6Srr4m8dPZGstZ7J6qw6GNO5lA9GfSp0EdtHPj1GF8rOan
         020AE+uj8FbTHMdw3/np0e8rfAxlzc4IYowLqWgFcp4DzDRH8FTtHd88WHqhwsM4HX1O
         hp+A==
X-Gm-Message-State: AOAM532PlwyfgihyaOhjaDOE75QFniBPQtnm9lznJzh5qLX90EQAK+Le
        bPcBujfvF/KK5AePujnnHg==
X-Google-Smtp-Source: ABdhPJzVpKEiHAx0V8GFSjZh7Zgq+E4ZNwcyS6UchjyUvdWwdHZXueHIO5mdlnJS5tB4vgDPNnGLhA==
X-Received: by 2002:a05:6808:1202:b0:2d9:a01a:48d2 with SMTP id a2-20020a056808120200b002d9a01a48d2mr793652oil.285.1647906284241;
        Mon, 21 Mar 2022 16:44:44 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id w8-20020a056830410800b005b25e8430basm8054284ott.6.2022.03.21.16.44.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 16:44:43 -0700 (PDT)
Received: (nullmailer pid 766907 invoked by uid 1000);
        Mon, 21 Mar 2022 23:44:42 -0000
Date:   Mon, 21 Mar 2022 18:44:42 -0500
From:   Rob Herring <robh@kernel.org>
To:     Radhey Shyam Pandey <radheys@xilinx.com>
Cc:     Andy Chiu <andy.chiu@sifive.com>,
        "robert.hancock@calian.com" <robert.hancock@calian.com>,
        Michal Simek <michals@xilinx.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Greentime Hu <greentime.hu@sifive.com>,
        Harini Katakam <harinik@xilinx.com>
Subject: Re: [PATCH v4 3/4] dt-bindings: net: xilinx_axienet: add pcs-handle
 attribute
Message-ID: <YjkN6uo/3hXMU36c@robh.at.kernel.org>
References: <20220321152515.287119-1-andy.chiu@sifive.com>
 <20220321152515.287119-3-andy.chiu@sifive.com>
 <SA1PR02MB856080742C4C5B1AA50FA254C7169@SA1PR02MB8560.namprd02.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SA1PR02MB856080742C4C5B1AA50FA254C7169@SA1PR02MB8560.namprd02.prod.outlook.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 21, 2022 at 03:42:52PM +0000, Radhey Shyam Pandey wrote:
> > -----Original Message-----
> > From: Andy Chiu <andy.chiu@sifive.com>
> > Sent: Monday, March 21, 2022 8:55 PM
> > To: Radhey Shyam Pandey <radheys@xilinx.com>; robert.hancock@calian.com;
> > Michal Simek <michals@xilinx.com>
> > Cc: davem@davemloft.net; kuba@kernel.org; pabeni@redhat.com;
> > robh+dt@kernel.org; linux@armlinux.org.uk; andrew@lunn.ch;
> > netdev@vger.kernel.org; devicetree@vger.kernel.org; Andy Chiu
> > <andy.chiu@sifive.com>; Greentime Hu <greentime.hu@sifive.com>
> > Subject: [PATCH v4 3/4] dt-bindings: net: xilinx_axienet: add pcs-handle
> > attribute
> > 
> > Document the new pcs-handle attribute to support connecting to an external
> > PHY in SGMII or 1000Base-X modes through the internal PCS/PMA PHY.
> > 
> > Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> > Reviewed-by: Greentime Hu <greentime.hu@sifive.com>
> > ---
> >  Documentation/devicetree/bindings/net/xilinx_axienet.txt | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/net/xilinx_axienet.txt
> > b/Documentation/devicetree/bindings/net/xilinx_axienet.txt
> > index b8e4894bc634..ba720a2ea5fc 100644
> > --- a/Documentation/devicetree/bindings/net/xilinx_axienet.txt
> > +++ b/Documentation/devicetree/bindings/net/xilinx_axienet.txt
> > @@ -26,7 +26,8 @@ Required properties:
> >  		  specified, the TX/RX DMA interrupts should be on that node
> >  		  instead, and only the Ethernet core interrupt is optionally
> >  		  specified here.
> > -- phy-handle	: Should point to the external phy device.
> > +- phy-handle	: Should point to the external phy device if exists. Pointing
> > +		  this to the PCS/PMA PHY is deprecated and should be
> > avoided.
> >  		  See ethernet.txt file in the same directory.
> >  - xlnx,rxmem	: Set to allocated memory buffer for Rx/Tx in the hardware
> > 
> > @@ -68,6 +69,11 @@ Optional properties:
> >  		  required through the core's MDIO interface (i.e. always,
> >  		  unless the PHY is accessed through a different bus).
> > 
> > + - pcs-handle: 	  Phandle to the internal PCS/PMA PHY in SGMII or 1000Base-X
> > +		  modes, where "pcs-handle" should be preferably used to
> > point
> > +		  to the PCS/PMA PHY, and "phy-handle" should point to an
> > +		  external PHY if exists.
> 
> I would like to have Rob feedback on this pcs-handle DT property.
> 
> The use case is generic i.e. require separate handle to internal SGMII
> and external Phy so would prefer this new DT convention is 
> standardized or we discuss possible approaches on how to handle
> both phys and not add it as vendor specific property in the first 
> place.

IMO, you should use 'phys' for the internal PCS phy. That's aligned with 
other uses like PCIe, SATA, etc. (there is phy h/w that will do PCS, 
PCIe, SATA). 'phy-handle' is for the ethernet PHY.

Rob
