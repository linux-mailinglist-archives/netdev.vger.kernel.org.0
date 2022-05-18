Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8550A52AF2E
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 02:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232568AbiERAcp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 20:32:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231217AbiERAco (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 20:32:44 -0400
Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20A561C906;
        Tue, 17 May 2022 17:32:43 -0700 (PDT)
Received: by mail-oi1-f170.google.com with SMTP id i66so852809oia.11;
        Tue, 17 May 2022 17:32:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QFA2d6A5RAAWuqracc3xgYj5/7N951deGtq1dGA/bWc=;
        b=lnlP/DqbyNNQEKEY9T+7cfxVQxwVTPr/PpLu6T78pNnv4uegXXHhIMMnrF7nVhSROS
         cOvQhTWdtIfymd1SDHt/jBz8In87lRqSDqflC94C7y1OglERVH0HE0zTmkFkuJEDK9pS
         HtF+CgmsoYFOeHTV9ZCKxAEV79BCj5gmvgeGrmx2ZB886IwFCMMjt22XqJhfztjZ4RlT
         rCUUrtpOJ1uJWmopT35LRtrG1DuB98lHlPaFNLDSanowLz6DrH8xV44sV+jOlcsmOOMr
         y+rl84At8khAsq5e8ES55ez5TqWir8lhLikV0HiIipT052AgiJ5ZSAqdch6EOOls5qDz
         WOGQ==
X-Gm-Message-State: AOAM532CTcz2XW6ba6NDewaKHw05jj5ZiwoIlVgy5lvtNBTP9tS0duIX
        ogNu/WmGZlbKOLBg3GB+Bw==
X-Google-Smtp-Source: ABdhPJw5DZXNbuW8nDNfJiIdYvSR1Uh4wOaOI3dT2Xe9fAeFaCnt8jBFuPGMDkqG/VMIrEL+HXhMIg==
X-Received: by 2002:a05:6808:2025:b0:326:6f73:5270 with SMTP id q37-20020a056808202500b003266f735270mr17557180oiw.241.1652833962463;
        Tue, 17 May 2022 17:32:42 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id 49-20020a9d0134000000b0060603221271sm297499otu.65.2022.05.17.17.32.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 17:32:41 -0700 (PDT)
Received: (nullmailer pid 1944462 invoked by uid 1000);
        Wed, 18 May 2022 00:32:40 -0000
Date:   Tue, 17 May 2022 19:32:40 -0500
From:   Rob Herring <robh@kernel.org>
To:     Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, krzysztof.kozlowski+dt@linaro.org,
        harini.katakam@xilinx.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        git@xilinx.com
Subject: Re: [RFC net-next] dt-bindings: net: xilinx: document xilinx
 emaclite driver binding
Message-ID: <20220518003240.GA1942137-robh@kernel.org>
References: <1652373596-5994-1-git-send-email-radhey.shyam.pandey@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1652373596-5994-1-git-send-email-radhey.shyam.pandey@xilinx.com>
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

On Thu, May 12, 2022 at 10:09:56PM +0530, Radhey Shyam Pandey wrote:
> Add basic description for the xilinx emaclite driver DT bindings.
> 
> Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
> ---
>  .../bindings/net/xlnx,emaclite.yaml           | 60 +++++++++++++++++++
>  1 file changed, 60 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/xlnx,emaclite.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/xlnx,emaclite.yaml b/Documentation/devicetree/bindings/net/xlnx,emaclite.yaml
> new file mode 100644
> index 000000000000..a3e2a0e89b24
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/xlnx,emaclite.yaml
> @@ -0,0 +1,60 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/xlnx,emaclite.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Xilinx Emaclite Ethernet controller
> +
> +maintainers:
> +  - Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
> +  - Harini Katakam <harini.katakam@xilinx.com>
> +
> +properties:
> +  compatible:
> +    enum:
> +      - xlnx,opb-ethernetlite-1.01.a
> +      - xlnx,opb-ethernetlite-1.01.b
> +      - xlnx,xps-ethernetlite-1.00.a
> +      - xlnx,xps-ethernetlite-2.00.a
> +      - xlnx,xps-ethernetlite-2.01.a
> +      - xlnx,xps-ethernetlite-3.00.a
> +
> +  reg:
> +    maxItems: 1
> +
> +  interrupts:
> +    maxItems: 1
> +
> +  phy-handle: true
> +
> +  local-mac-address: true
> +
> +  xlnx,tx-ping-pong:
> +    type: boolean
> +    description: hardware supports tx ping pong buffer.
> +
> +  xlnx,rx-ping-pong:
> +    type: boolean
> +    description: hardware supports rx ping pong buffer.

Are these based on IP version or configuration of IP?

Rob
