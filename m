Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CDC15980BF
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 11:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232900AbiHRJXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 05:23:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231439AbiHRJXH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 05:23:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DB8299279;
        Thu, 18 Aug 2022 02:23:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BDC4A6135E;
        Thu, 18 Aug 2022 09:23:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FF7BC433D6;
        Thu, 18 Aug 2022 09:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660814585;
        bh=s6c6ydJJJfHjse+r0+DqdY7QAzCBMOBNADyhfdHK1zk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mNzlrg87y4yH5fKwRgzCcPKS8208gG5XXWb5Vtk1LYKufkzT+4ilSpt5nJpYHKvFG
         K1xiFRaHInj2KtLYeRRA0qe0DT8ihfdgmD/dvbVfKFCB9VS4cte9oQ7cOoZuK9AFOC
         3VHfuK2CF7bIJOs214lqqHtBy2u3gdrvt1gJwk4qQFh0UAvCiENazzDHqu7TpPj1aQ
         XvjY2s+iIYkZTHGZRv94OigOIKBmx7xWNt8TSMg6/QATH7DouNm5QDGXKF2Q+hfem/
         wR8mwd/Z5Y9YDUvG2agkQzusiZ7EPNLQlBe/FghYRK0dg9QjcnXXZRaeM78K836b+K
         W8neUNaL0UXng==
Date:   Thu, 18 Aug 2022 17:22:57 +0800
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
Message-ID: <20220818092257.GF149610@dragon>
References: <20220704101056.24821-1-wei.fang@nxp.com>
 <20220704101056.24821-2-wei.fang@nxp.com>
 <ef7e501a-b351-77f9-c4f7-74ab10283ed6@linaro.org>
 <20220818013344.GE149610@dragon>
 <fd41a409-d0e0-0026-4644-9058d1177c45@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd41a409-d0e0-0026-4644-9058d1177c45@linaro.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 18, 2022 at 10:51:02AM +0300, Krzysztof Kozlowski wrote:
> On 18/08/2022 04:33, Shawn Guo wrote:
> > On Mon, Jul 04, 2022 at 11:12:09AM +0200, Krzysztof Kozlowski wrote:
> >>> diff --git a/Documentation/devicetree/bindings/net/fsl,fec.yaml b/Documentation/devicetree/bindings/net/fsl,fec.yaml
> >>> index daa2f79a294f..6642c246951b 100644
> >>> --- a/Documentation/devicetree/bindings/net/fsl,fec.yaml
> >>> +++ b/Documentation/devicetree/bindings/net/fsl,fec.yaml
> >>> @@ -40,6 +40,10 @@ properties:
> >>>            - enum:
> >>>                - fsl,imx7d-fec
> >>>            - const: fsl,imx6sx-fec
> >>> +      - items:
> >>> +          - enum:
> >>> +              - fsl,imx8ulp-fec
> >>> +          - const: fsl,imx6ul-fec
> >>
> >> This is wrong.  fsl,imx6ul-fec has to be followed by fsl,imx6q-fec. I
> >> think someone made similar mistakes earlier so this is a mess.
> > 
> > Hmm, not sure I follow this.  Supposing we want to have the following
> > compatible for i.MX8ULP FEC, why do we have to have "fsl,imx6q-fec"
> > here?
> > 
> > 	fec: ethernet@29950000 {
> > 		compatible = "fsl,imx8ulp-fec", "fsl,imx6ul-fec";
> > 		...
> > 	};
> 
> Because a bit earlier this bindings is saying that fsl,imx6ul-fec must
> be followed by fsl,imx6q-fec.

The FEC driver OF match table suggests that fsl,imx6ul-fec and fsl,imx6q-fec
are not really compatible.

static const struct of_device_id fec_dt_ids[] = {
        { .compatible = "fsl,imx25-fec", .data = &fec_devtype[IMX25_FEC], },
        { .compatible = "fsl,imx27-fec", .data = &fec_devtype[IMX27_FEC], },
        { .compatible = "fsl,imx28-fec", .data = &fec_devtype[IMX28_FEC], },
        { .compatible = "fsl,imx6q-fec", .data = &fec_devtype[IMX6Q_FEC], },
        { .compatible = "fsl,mvf600-fec", .data = &fec_devtype[MVF600_FEC], },
        { .compatible = "fsl,imx6sx-fec", .data = &fec_devtype[IMX6SX_FEC], },
        { .compatible = "fsl,imx6ul-fec", .data = &fec_devtype[IMX6UL_FEC], },
        { .compatible = "fsl,imx8mq-fec", .data = &fec_devtype[IMX8MQ_FEC], },
        { .compatible = "fsl,imx8qm-fec", .data = &fec_devtype[IMX8QM_FEC], },
        { /* sentinel */ }
};
MODULE_DEVICE_TABLE(of, fec_dt_ids);

Should we fix the binding doc?

Shawn
