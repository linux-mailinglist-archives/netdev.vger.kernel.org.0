Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4FD860BB17
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 22:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234929AbiJXUql (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 16:46:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234881AbiJXUq0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 16:46:26 -0400
Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8456F7E312;
        Mon, 24 Oct 2022 11:54:10 -0700 (PDT)
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-13b6336a1acso7397038fac.3;
        Mon, 24 Oct 2022 11:54:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DSHoLmUbLuENurdrd9yEIJ7hkMBgnF+sF8cll6Ga1eM=;
        b=mBoKb9rkw7+wi9jxwsRvhwyN7wmC9t3ti2xJFtu5CgkRxRNiVuTqY4C3d8w91ZVMdD
         wLXnYs3sfUwclgeoj3mC5BM58y464sfU8vjqK0wEjBUno6F9cyb5kFP+fTuESw+lo1h9
         6qjTHhFBiU0+wIG1ZCq5MWP5dh5tKvkdI5CpjlAff0JIQWISFBhmpZZrJFInHzm6m5E5
         ONwVOSscnt0WnG5QdI+8W7V05dgaovFdnKXd8Rr7o48vQUJIyTVY/MaSWowsMgV2qeAV
         FCLuOXknLAUgpkvWFAgUbAcyfvII8PtEc3gdl7F608G0eb+ToO7IeTCIf31x9gSbdh/j
         QKOg==
X-Gm-Message-State: ACrzQf0yJgZM9TXctxlgdwo1P1CBela+yDEnJsdvpV3BkIEpUQBVo8QH
        KBN7HxCp5GnMpKRREU3eyw==
X-Google-Smtp-Source: AMsMyM60L1DQX1I0FNOMN2C66nrnpuz8xkkH//1Hjf2/c4Iu3HvI00DUtqeyi7rYsrwDIgvGIKRlWQ==
X-Received: by 2002:a05:6870:d29e:b0:131:c3df:1e93 with SMTP id d30-20020a056870d29e00b00131c3df1e93mr37559606oae.56.1666637594530;
        Mon, 24 Oct 2022 11:53:14 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id g4-20020a4ab044000000b0044b0465bd07sm296676oon.20.2022.10.24.11.53.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 11:53:14 -0700 (PDT)
Received: (nullmailer pid 2039478 invoked by uid 1000);
        Mon, 24 Oct 2022 18:53:12 -0000
Date:   Mon, 24 Oct 2022 13:53:12 -0500
From:   Rob Herring <robh@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Sebastian Reichel <sebastian.reichel@collabora.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@collabora.com
Subject: Re: [PATCH 1/1] dt-bindings: net: snps,dwmac: Document queue config
 subnodes
Message-ID: <20221024185312.GA2037160-robh@kernel.org>
References: <20221021171055.85888-1-sebastian.reichel@collabora.com>
 <761d6ae2-e779-2a4b-a735-960c716c3024@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <761d6ae2-e779-2a4b-a735-960c716c3024@linaro.org>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 22, 2022 at 12:05:15PM -0400, Krzysztof Kozlowski wrote:
> On 21/10/2022 13:10, Sebastian Reichel wrote:
> > The queue configuration is referenced by snps,mtl-rx-config and
> > snps,mtl-tx-config. Most in-tree DTs put the referenced object
> > as child node of the dwmac node.
> > 
> > This adds proper description for this setup, which has the
> > advantage of properly making sure only known properties are
> > used.
> > 
> > Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
> > ---
> >  .../devicetree/bindings/net/snps,dwmac.yaml   | 154 ++++++++++++------
> >  1 file changed, 108 insertions(+), 46 deletions(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> > index 13b984076af5..0bf6112cec2f 100644
> > --- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> > +++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> > @@ -167,56 +167,118 @@ properties:
> >    snps,mtl-rx-config:
> >      $ref: /schemas/types.yaml#/definitions/phandle
> >      description:
> > -      Multiple RX Queues parameters. Phandle to a node that can
> > -      contain the following properties
> > -        * snps,rx-queues-to-use, number of RX queues to be used in the
> > -          driver
> > -        * Choose one of these RX scheduling algorithms
> > -          * snps,rx-sched-sp, Strict priority
> > -          * snps,rx-sched-wsp, Weighted Strict priority
> > -        * For each RX queue
> > -          * Choose one of these modes
> > -            * snps,dcb-algorithm, Queue to be enabled as DCB
> > -            * snps,avb-algorithm, Queue to be enabled as AVB
> > -          * snps,map-to-dma-channel, Channel to map
> > -          * Specifiy specific packet routing
> > -            * snps,route-avcp, AV Untagged Control packets
> > -            * snps,route-ptp, PTP Packets
> > -            * snps,route-dcbcp, DCB Control Packets
> > -            * snps,route-up, Untagged Packets
> > -            * snps,route-multi-broad, Multicast & Broadcast Packets
> > -          * snps,priority, bitmask of the tagged frames priorities assigned to
> > -            the queue
> > +      Multiple RX Queues parameters. Phandle to a node that
> > +      implements the 'rx-queues-config' object described in
> > +      this binding.
> > +
> > +  rx-queues-config:
> 
> If this field is specific to this device, then you need vendor prefix:
> snps,rq-queues-config

Not for a node name...

Rob
