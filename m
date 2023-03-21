Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD90F6C2C45
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 09:26:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231180AbjCUI0M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 04:26:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230273AbjCUIZ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 04:25:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEBA02CC5B;
        Tue, 21 Mar 2023 01:25:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7144AB81252;
        Tue, 21 Mar 2023 08:25:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB65FC433D2;
        Tue, 21 Mar 2023 08:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679387153;
        bh=8GPiMzbN7BmXPyIzz0Qw60XVpxo4kSSqd4BTGmy3AlA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OZRB44LFEQYJBDh3/ETp0fAJtAFrIfUIZw8BfDyFQb45eTLV1shnqldjlcpL7R4PV
         kQv1VW7/0ZDSudqTWBvFo9UpFVin9rUMixEC5b50BKHffW4eOHc9j20wTowSTVpsz9
         NHCiVoU94+dYFTZvEJWCYtydZ92oOcva2ArbYTJVi9x5e1BjjZcc4wDPudZ9d+7Hrc
         pglakWLnRAIlljeSqYERD/BuZ18rBrmxK0aYMU/mnBh+3i5vTm5BInFfWiVrqSan5f
         /ICplHQsfLqF+2gu3HY1UA82jVADZd+twDQNKOI349ENKDMfJSH5NLb2ttbXV5mJw0
         YqzR2W7as7Wwg==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1peXKu-00008b-6A; Tue, 21 Mar 2023 09:27:16 +0100
Date:   Tue, 21 Mar 2023 09:27:16 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Johan Hovold <johan+linaro@kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] dt-bindings: wireless: add ath11k pcie bindings
Message-ID: <ZBlqZLHwqLLZhtTi@hovoldconsulting.com>
References: <20230320104658.22186-1-johan+linaro@kernel.org>
 <20230320104658.22186-2-johan+linaro@kernel.org>
 <a8356f76-189d-928b-1a1c-f4171de1e2d0@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8356f76-189d-928b-1a1c-f4171de1e2d0@linaro.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 21, 2023 at 09:14:15AM +0100, Krzysztof Kozlowski wrote:
> On 20/03/2023 11:46, Johan Hovold wrote:
> > Add devicetree bindings for Qualcomm ath11k PCIe devices such as WCN6856
> > for which the calibration data variant may need to be described.
> > 
> > Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> > ---
> >  .../bindings/net/wireless/pci17cb,1103.yaml   | 56 +++++++++++++++++++
> >  1 file changed, 56 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/net/wireless/pci17cb,1103.yaml
> > 
> > diff --git a/Documentation/devicetree/bindings/net/wireless/pci17cb,1103.yaml b/Documentation/devicetree/bindings/net/wireless/pci17cb,1103.yaml
> > new file mode 100644
> > index 000000000000..df67013822c6
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/net/wireless/pci17cb,1103.yaml
> 
> PCI devices are kind of exception in the naming, so this should be
> qcom,ath11k-pci.yaml or qcom,wcn6856.yaml (or something similar)

Heh, I suggested something similar in my reply to Kalle. Let's go with
'qcom,ath11k-pci.yaml' then as he first suggested (and keeping the
current schema file unchanged?).

> > @@ -0,0 +1,56 @@
> > +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> > +# Copyright (c) 2023 Linaro Limited
> > +%YAML 1.2
> > +---
> > +$id: http://devicetree.org/schemas/net/wireless/pci17cb,1103.yaml#
> > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > +
> > +title: Qualcomm Technologies ath11k wireless devices (PCIe)
> > +
> > +maintainers:
> > +  - Kalle Valo <kvalo@kernel.org>
> > +
> > +description: |
> > +  Qualcomm Technologies IEEE 802.11ax PCIe devices.
> > +
> > +properties:
> > +  compatible:
> > +    enum:
> > +      - pci17cb,1103  # WCN6856
> > +
> > +  reg:
> > +    maxItems: 1
> > +
> > +  qcom,ath11k-calibration-variant:
> 
> qcom,calibration-variant

This one is already in use as you noticed.

> > +    $ref: /schemas/types.yaml#/definitions/string
> > +    description: calibration data variant
> 
> Your description copies the name of property. Instead say something more...

Yeah, I was actively avoiding trying to say too much (e.g. mentioning
the name of the current firmware file). See the definition in
qcom,ath11k.yaml.

I can try to find some middle ground unless you prefer copying the
current definition.

Johan
