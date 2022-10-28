Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0686A611C74
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 23:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbiJ1Vf7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 17:35:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbiJ1Vf5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 17:35:57 -0400
Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8CDB1911DB;
        Fri, 28 Oct 2022 14:35:56 -0700 (PDT)
Received: by mail-oi1-f179.google.com with SMTP id r83so7483173oih.2;
        Fri, 28 Oct 2022 14:35:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZNCjs9nw/UlRpwc17oK4dkQqAKQBmKykfu9gcnjsiHY=;
        b=6d+uBKIcCXLeO+xDHaYVfRzJtgCI0dZ9FusNjXzzwjGgZcflOLepj0HxHefkD6FXnC
         Ek1JirF6unyH77RerQnkLYXt+ngSgizyedyOXZ90yR8w8FLyTPqdEatEn49j+/be3RAg
         umCUh3RtlPIpvC/C3dqPaBVJRLeAEKZoym+7ktAPD9TLvPTNw2NCnPFYNaFpf6hbphuL
         KWWqog78Is2Ub9AGl/72JGoz85W3yeP9a1YjeE6ybmBlPAWOKhAdmuA5zqkCbwZgK7Yj
         CHGa8V42J+34A1LXtUmlrcJ08SnWxjTt4ajh+eDbkZNGNqRg01lg8qpH1rTZgKkd/rd/
         RpUA==
X-Gm-Message-State: ACrzQf1pE8zcobNjuvNCh8hw8SIUWjhcymbWaIEbue6rI2tgn8T17hzN
        SkrXl4mWU5ne+nfWiiZaFw==
X-Google-Smtp-Source: AMsMyM66nlzhdxlsYZ4j0fr5qO5pjmvShA4sDx12vlzhDk6+7SKtQLNrxqxZijEFaF630V8HsyD7RQ==
X-Received: by 2002:a05:6808:1823:b0:359:bf5e:7649 with SMTP id bh35-20020a056808182300b00359bf5e7649mr5758748oib.54.1666992955931;
        Fri, 28 Oct 2022 14:35:55 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id j22-20020a4ad2d6000000b00480dac71228sm2007344oos.24.2022.10.28.14.35.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 14:35:55 -0700 (PDT)
Received: (nullmailer pid 2317054 invoked by uid 1000);
        Fri, 28 Oct 2022 21:35:56 -0000
Date:   Fri, 28 Oct 2022 16:35:56 -0500
From:   Rob Herring <robh@kernel.org>
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Robert Marko <robert.marko@sartura.hr>,
        Michael Walle <michael@walle.cc>, devicetree@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        linux-kernel@vger.kernel.org, Marcin Wojtas <mw@semihalf.com>,
        Eric Dumazet <edumazet@google.com>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        netdev@vger.kernel.org
Subject: Re: [PATCH 2/5] dt-bindings: nvmem: add YAML schema for the ONIE tlv
 layout
Message-ID: <20221028213556.GA2310662-robh@kernel.org>
References: <20221028092337.822840-1-miquel.raynal@bootlin.com>
 <20221028092337.822840-3-miquel.raynal@bootlin.com>
 <166695949292.1076993.16137208250373047416.robh@kernel.org>
 <20221028154431.0096ab70@xps-13>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221028154431.0096ab70@xps-13>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 28, 2022 at 03:44:31PM +0200, Miquel Raynal wrote:
> Hi Rob & Krzysztof,
> 
> robh@kernel.org wrote on Fri, 28 Oct 2022 07:20:05 -0500:
> 
> > On Fri, 28 Oct 2022 11:23:34 +0200, Miquel Raynal wrote:
> > > Add a schema for the ONIE tlv NVMEM layout that can be found on any ONIE
> > > compatible networking device.
> > > 
> > > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > > ---
> > >  .../nvmem/layouts/onie,tlv-layout.yaml        | 96 +++++++++++++++++++
> > >  1 file changed, 96 insertions(+)
> > >  create mode 100644 Documentation/devicetree/bindings/nvmem/layouts/onie,tlv-layout.yaml
> > >   
> > 
> > My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
> > on your patch (DT_CHECKER_FLAGS is new in v5.13):
> > 
> > yamllint warnings/errors:
> > 
> > dtschema/dtc warnings/errors:
> > Documentation/devicetree/bindings/nvmem/layouts/onie,tlv-layout.example.dtb:0:0: /example-0/onie: failed to match any schema with compatible: ['onie,tlv-layout', 'vendor,device']
> 
> Oh right, I wanted to ask about this under the three --- but I forgot.
> Here was my question:
> 
> How do we make the checker happy with an example where the second
> compatible can be almost anything (any nvmem-compatible device) but the
> first one should be the layout? (this is currently what Michael's
> proposal uses).

That seems like mixing 2 different meanings for compatibles. Perhaps 
that should be split with the nvmem stuff going into a child container 
node.

Rob

P.S. Any compatible string starting with 'foo' will pass, but I probably 
won't be happy to see that used.
