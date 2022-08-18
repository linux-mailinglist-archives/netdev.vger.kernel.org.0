Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25325597B18
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 03:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240101AbiHRBd6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 21:33:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238839AbiHRBd5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 21:33:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 914467A532;
        Wed, 17 Aug 2022 18:33:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F9D9B81FF1;
        Thu, 18 Aug 2022 01:33:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 657AFC433C1;
        Thu, 18 Aug 2022 01:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660786433;
        bh=nPgq2EwU9zwQ5x4W5Z3BaUbWZq+uPaHojV269l9I2T8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SOZCkOJapUD4HX9tUEIS/3vRWe6/BGKlokEuvnAtCqJoqp/jdnzG7KQCtzbcLswOE
         ueyM4ueH8qSlnCz/RJfGbWBLfNvYvQ2CTyQx6+2XBAaGTY5LR4T6BcLmtxA1A72Si7
         s0qycCc6kewqO0XSfoJq5ImWAbtVHI/R59UL53JrvjTEv9hJdCQFYRrUNOBM6Ddqbt
         EjFhaK2Mf6XBnlBluFp3NO9dMHi+qLyx9Xf8yo52vxV0aylrFkWZL8/bOGVS5VeZbf
         +FuF6lNHlqLl7yLID6zL214nw7s2sAvAutcs/BojQc1JLAls8YSopO4Zlfv6vNat5G
         LUbsYCLXNRkFg==
Date:   Thu, 18 Aug 2022 09:33:44 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Wei Fang <wei.fang@nxp.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        s.hauer@pengutronix.de, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, festevam@gmail.com, linux-imx@nxp.com,
        peng.fan@nxp.com, ping.bai@nxp.com, sudeep.holla@arm.com,
        linux-arm-kernel@lists.infradead.org, aisheng.dong@nxp.com
Subject: Re: [PATCH 1/3] dt-bings: net: fsl,fec: update compatible item
Message-ID: <20220818013344.GE149610@dragon>
References: <20220704101056.24821-1-wei.fang@nxp.com>
 <20220704101056.24821-2-wei.fang@nxp.com>
 <ef7e501a-b351-77f9-c4f7-74ab10283ed6@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ef7e501a-b351-77f9-c4f7-74ab10283ed6@linaro.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 04, 2022 at 11:12:09AM +0200, Krzysztof Kozlowski wrote:
> > diff --git a/Documentation/devicetree/bindings/net/fsl,fec.yaml b/Documentation/devicetree/bindings/net/fsl,fec.yaml
> > index daa2f79a294f..6642c246951b 100644
> > --- a/Documentation/devicetree/bindings/net/fsl,fec.yaml
> > +++ b/Documentation/devicetree/bindings/net/fsl,fec.yaml
> > @@ -40,6 +40,10 @@ properties:
> >            - enum:
> >                - fsl,imx7d-fec
> >            - const: fsl,imx6sx-fec
> > +      - items:
> > +          - enum:
> > +              - fsl,imx8ulp-fec
> > +          - const: fsl,imx6ul-fec
> 
> This is wrong.  fsl,imx6ul-fec has to be followed by fsl,imx6q-fec. I
> think someone made similar mistakes earlier so this is a mess.

Hmm, not sure I follow this.  Supposing we want to have the following
compatible for i.MX8ULP FEC, why do we have to have "fsl,imx6q-fec"
here?

	fec: ethernet@29950000 {
		compatible = "fsl,imx8ulp-fec", "fsl,imx6ul-fec";
		...
	};

Shawn

> 
> >        - items:
> >            - const: fsl,imx8mq-fec
> >            - const: fsl,imx6sx-fec
