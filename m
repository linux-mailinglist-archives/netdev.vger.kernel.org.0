Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2781659851F
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 16:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245138AbiHRN5q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 09:57:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245356AbiHRN5h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 09:57:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFE90B5A48;
        Thu, 18 Aug 2022 06:57:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C886616EA;
        Thu, 18 Aug 2022 13:57:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43DD5C433D6;
        Thu, 18 Aug 2022 13:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660831055;
        bh=qqw2ZRKAM/HopXMmPqWG8KqLHJLGqfDq1lckUaBBS8Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Cy10ULQIGxDyatCWqA/3oow8PAmwyVzNy7YkqEZxmZKow0w5Jle1X0Yjd0Xhd9yyh
         kT7GDu4HtPhWfvw+9RX2zDgtjPuHSUYWwUyu1nK3MnHITs/ge3k9sJYhjCmkBf4dCo
         J8J/HbpmfS4SMrgrNTzJHwgTCU6uAMA6501rT8hu03C7AFx74utljnrtVJ8w0viSX4
         0k9ykb6DQ4h+FxBxCgEId1kTbFGG4mZtCQ2CyrWgBFpx9rluHCQSmIwKutI0Pj8okm
         +encPvqOmVeKMqdHXtfC+8ePZIEY3In5ET6OQHUDpS6nkczYafXSeWo3GRCW6Y9/EC
         LhVcicOuVd/CA==
Date:   Thu, 18 Aug 2022 21:57:27 +0800
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
Message-ID: <20220818135727.GG149610@dragon>
References: <20220704101056.24821-1-wei.fang@nxp.com>
 <20220704101056.24821-2-wei.fang@nxp.com>
 <ef7e501a-b351-77f9-c4f7-74ab10283ed6@linaro.org>
 <20220818013344.GE149610@dragon>
 <fd41a409-d0e0-0026-4644-9058d1177c45@linaro.org>
 <20220818092257.GF149610@dragon>
 <a08b230c-d655-75ee-0f0c-8281b13b477b@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a08b230c-d655-75ee-0f0c-8281b13b477b@linaro.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 18, 2022 at 12:46:33PM +0300, Krzysztof Kozlowski wrote:
> On 18/08/2022 12:22, Shawn Guo wrote:
> > On Thu, Aug 18, 2022 at 10:51:02AM +0300, Krzysztof Kozlowski wrote:
> >> On 18/08/2022 04:33, Shawn Guo wrote:
> >>> On Mon, Jul 04, 2022 at 11:12:09AM +0200, Krzysztof Kozlowski wrote:
> >>>>> diff --git a/Documentation/devicetree/bindings/net/fsl,fec.yaml b/Documentation/devicetree/bindings/net/fsl,fec.yaml
> >>>>> index daa2f79a294f..6642c246951b 100644
> >>>>> --- a/Documentation/devicetree/bindings/net/fsl,fec.yaml
> >>>>> +++ b/Documentation/devicetree/bindings/net/fsl,fec.yaml
> >>>>> @@ -40,6 +40,10 @@ properties:
> >>>>>            - enum:
> >>>>>                - fsl,imx7d-fec
> >>>>>            - const: fsl,imx6sx-fec
> >>>>> +      - items:
> >>>>> +          - enum:
> >>>>> +              - fsl,imx8ulp-fec
> >>>>> +          - const: fsl,imx6ul-fec
> >>>>
> >>>> This is wrong.  fsl,imx6ul-fec has to be followed by fsl,imx6q-fec. I
> >>>> think someone made similar mistakes earlier so this is a mess.
> >>>
> >>> Hmm, not sure I follow this.  Supposing we want to have the following
> >>> compatible for i.MX8ULP FEC, why do we have to have "fsl,imx6q-fec"
> >>> here?
> >>>
> >>> 	fec: ethernet@29950000 {
> >>> 		compatible = "fsl,imx8ulp-fec", "fsl,imx6ul-fec";
> >>> 		...
> >>> 	};
> >>
> >> Because a bit earlier this bindings is saying that fsl,imx6ul-fec must
> >> be followed by fsl,imx6q-fec.
> > 
> > The FEC driver OF match table suggests that fsl,imx6ul-fec and fsl,imx6q-fec
> > are not really compatible.
> > 
> > static const struct of_device_id fec_dt_ids[] = {
> >         { .compatible = "fsl,imx25-fec", .data = &fec_devtype[IMX25_FEC], },
> >         { .compatible = "fsl,imx27-fec", .data = &fec_devtype[IMX27_FEC], },
> >         { .compatible = "fsl,imx28-fec", .data = &fec_devtype[IMX28_FEC], },
> >         { .compatible = "fsl,imx6q-fec", .data = &fec_devtype[IMX6Q_FEC], },
> >         { .compatible = "fsl,mvf600-fec", .data = &fec_devtype[MVF600_FEC], },
> >         { .compatible = "fsl,imx6sx-fec", .data = &fec_devtype[IMX6SX_FEC], },
> >         { .compatible = "fsl,imx6ul-fec", .data = &fec_devtype[IMX6UL_FEC], },
> 
> I don't see here any incompatibility. Binding driver with different
> driver data is not a proof of incompatible devices.

To me, different driver data is a good sign of incompatibility.  It
mostly means that software needs to program the hardware block
differently.


> Additionally, the
> binding describes the hardware, not the driver.
> 
> >         { .compatible = "fsl,imx8mq-fec", .data = &fec_devtype[IMX8MQ_FEC], },
> >         { .compatible = "fsl,imx8qm-fec", .data = &fec_devtype[IMX8QM_FEC], },
> >         { /* sentinel */ }
> > };
> > MODULE_DEVICE_TABLE(of, fec_dt_ids);
> > 
> > Should we fix the binding doc?
> 
> Maybe, I don't know. The binding describes the hardware, so based on it
> the devices are compatible. Changing this, except ABI impact, would be
> possible with proper reason, but not based on Linux driver code.

Well, if Linux driver code is written in the way that hardware requires,
I guess that's just based on hardware characteristics.

To me, having a device compatible to two devices that require different
programming model is unnecessary and confusing.

Shawn
