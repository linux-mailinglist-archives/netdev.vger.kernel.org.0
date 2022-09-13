Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD04D5B6CDB
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 14:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232001AbiIMMLy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 08:11:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231951AbiIMMLx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 08:11:53 -0400
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01B145FAEE;
        Tue, 13 Sep 2022 05:11:51 -0700 (PDT)
Received: by mail-ot1-f51.google.com with SMTP id t8-20020a9d5908000000b0063b41908168so7915938oth.8;
        Tue, 13 Sep 2022 05:11:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=41W5VzWd2BJ4pYM95Nv/iwTfFA10pa/oiekl8eXTFCE=;
        b=H0nsadOYTLlI2IUMK2gJu0D19kkjyutCvb02nM2DCKnOMAjcM7lLRafZJ1mflX9M4M
         NIaBiMQ5eU2BJPyEROwS5D5yO7IWZIu9Bl8Mzs8DjMAYgMpxMn50ZEEVq6JUb793regJ
         YuvWD9GjCKHX0R9PemixVbyxIe+AP3HGXtTiGgzHc27iQAesEn8XTHIQFEPiLA0lBxa8
         5cLbPcnu4zOyY1yQ85qfIg6aeyno4at+KFpKUouLwGrCo/D8vemX82qnLU/H4H8Kp7Ng
         KyBpMyEllGx8/+MOsUKoCJaATUkw8UPRWpwUc1FNL8QqNIBEu1q+QnvpAUH/bv4MEkBQ
         2RqA==
X-Gm-Message-State: ACgBeo0Zj94Tc1pXfVIEFGtrHhAV4zLdIiQKEen5NO1l7hOy/J0ywyBX
        uFEYBdTgSfRsL1GNlEDmGA==
X-Google-Smtp-Source: AA6agR5olqqnemXJKb4NVDNArMb8Qzu43Bm2sTV6dkFQdJgmVeomfNWX15dpS+Gj2nTgaj1HJbJcEA==
X-Received: by 2002:a9d:4592:0:b0:637:35cc:68e7 with SMTP id x18-20020a9d4592000000b0063735cc68e7mr12322595ote.355.1663071110513;
        Tue, 13 Sep 2022 05:11:50 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id m189-20020aca58c6000000b003450abf4404sm5079304oib.21.2022.09.13.05.11.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Sep 2022 05:11:50 -0700 (PDT)
Received: (nullmailer pid 3413151 invoked by uid 1000);
        Tue, 13 Sep 2022 12:11:49 -0000
Date:   Tue, 13 Sep 2022 07:11:49 -0500
From:   Rob Herring <robh@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com,
        Bo.Jiao@mediatek.com, sujuan.chen@mediatek.com,
        ryder.Lee@mediatek.com, evelyn.tsai@mediatek.com,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 02/12] dt-bindings: net: mediatek: add WED
 binding for MT7986 eth driver
Message-ID: <20220913121149.GB3397630-robh@kernel.org>
References: <cover.1662661555.git.lorenzo@kernel.org>
 <e8e2e1134fde632b7f6aaf9d96feab471385f84c.1662661555.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e8e2e1134fde632b7f6aaf9d96feab471385f84c.1662661555.git.lorenzo@kernel.org>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 08, 2022 at 09:33:36PM +0200, Lorenzo Bianconi wrote:
> Document the binding for the Wireless Ethernet Dispatch core on the
> MT7986 ethernet driver
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  Documentation/devicetree/bindings/net/mediatek,net.yaml | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/mediatek,net.yaml b/Documentation/devicetree/bindings/net/mediatek,net.yaml
> index f5564ecddb62..0116f100ef19 100644
> --- a/Documentation/devicetree/bindings/net/mediatek,net.yaml
> +++ b/Documentation/devicetree/bindings/net/mediatek,net.yaml
> @@ -238,6 +238,15 @@ allOf:
>            minItems: 2
>            maxItems: 2
>  
> +        mediatek,wed:
> +          $ref: /schemas/types.yaml#/definitions/phandle-array
> +          minItems: 2
> +          maxItems: 2
> +          items:
> +            maxItems: 1
> +          description:
> +            List of phandles to wireless ethernet dispatch nodes.

There's already a definition of this in the binding. Move it to the main 
section and put 'mediatek,wed: false' in if/then schemas for variants 
that don't have it.

Rob
