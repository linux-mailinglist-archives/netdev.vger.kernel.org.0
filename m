Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CDEA4F1B1F
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 23:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358121AbiDDVTk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 17:19:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379816AbiDDSKs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 14:10:48 -0400
Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA47B63C8;
        Mon,  4 Apr 2022 11:08:48 -0700 (PDT)
Received: by mail-oi1-f174.google.com with SMTP id e4so10895325oif.2;
        Mon, 04 Apr 2022 11:08:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DZpb0oBlOn87G7Q9uY1KQVcxA7oJ+asZrRDCjqQo8Z0=;
        b=mw0cAgw2SQ7yg8GQm44Kcefu+IZc4+byKBJAJpAREypXrxt1ZD2aLeeuM+xRYP13xs
         3e8fRywy2yQszXcnfyLdA+s0h1+9UxRyNXXBhuPyB0na+wcaPw0CSgLhGNNpjbyvPzOp
         MVNH1u7jTsNLjWyYBk7CbTyxLgTKVIiXpk8raEIZrnJC5kqG6AVbOj4R2cDhYY/01kB7
         PEQj8tKEVakVwvtuRTXGi9IRQ6MfZYy5sL+G91nTEjeZURi8ZgJTsJoO5Uvd21/RDkdA
         giSVIS1f0yycQik5cB70vof5J7fdLQ9bcbqf8C/pejkloaeQH0ln8KlhHq1hHJ8+T7iW
         a7aQ==
X-Gm-Message-State: AOAM532kZquENPzOoHcdoxSYUFGXO3v9V4ZnMITy+VEGXdjeWbE+6guE
        TP1ZDZX+2xVJKA7Bf8Qt/gyCLhKUZw==
X-Google-Smtp-Source: ABdhPJxeH7Wnz+4tUU3Y3MNJPpLuS8q51VeePVqDnsderFcju4PRjj/rPTbO30yhzinHYhB/5r48eQ==
X-Received: by 2002:a05:6808:d51:b0:2ec:b129:1197 with SMTP id w17-20020a0568080d5100b002ecb1291197mr211068oik.12.1649095728018;
        Mon, 04 Apr 2022 11:08:48 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id u16-20020a056808151000b002f734da0881sm4667921oiw.57.2022.04.04.11.08.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Apr 2022 11:08:47 -0700 (PDT)
Received: (nullmailer pid 1643107 invoked by uid 1000);
        Mon, 04 Apr 2022 18:08:46 -0000
Date:   Mon, 4 Apr 2022 13:08:46 -0500
From:   Rob Herring <robh@kernel.org>
To:     Andy Chiu <andy.chiu@sifive.com>
Cc:     netdev@vger.kernel.org, pabeni@redhat.com,
        robert.hancock@calian.com, davem@davemloft.net, robh+dt@kernel.org,
        devicetree@vger.kernel.org, linux@armlinux.org.uk, kuba@kernel.org,
        michal.simek@xilinx.com, radhey.shyam.pandey@xilinx.com,
        Greentime Hu <greentime.hu@sifive.com>, andrew@lunn.ch
Subject: Re: [PATCH v7 net 3/4] dt-bindings: net: add pcs-handle attribute
Message-ID: <Yks0LoizNfx2uVmu@robh.at.kernel.org>
References: <20220329024921.2739338-1-andy.chiu@sifive.com>
 <20220329024921.2739338-4-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220329024921.2739338-4-andy.chiu@sifive.com>
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

On Tue, 29 Mar 2022 10:49:20 +0800, Andy Chiu wrote:
> Document the new pcs-handle attribute to support connecting to an
> external PHY. For Xilinx's AXI Ethernet, this is used when the core
> operates in SGMII or 1000Base-X modes and links through the internal
> PCS/PMA PHY.
> 
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> Reviewed-by: Greentime Hu <greentime.hu@sifive.com>
> ---
>  .../devicetree/bindings/net/ethernet-controller.yaml      | 6 ++++++
>  Documentation/devicetree/bindings/net/xilinx_axienet.txt  | 8 +++++++-
>  2 files changed, 13 insertions(+), 1 deletion(-)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
