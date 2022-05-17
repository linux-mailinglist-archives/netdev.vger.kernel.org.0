Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7749A52A9F9
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 20:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351778AbiEQSGe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 14:06:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352115AbiEQSGJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 14:06:09 -0400
Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E4D850B3B;
        Tue, 17 May 2022 11:05:59 -0700 (PDT)
Received: by mail-oi1-f171.google.com with SMTP id q8so23234342oif.13;
        Tue, 17 May 2022 11:05:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=F9oiFXagRBRMM/DebPuqOfAkO2xPh1J2DfBuF2wn6jY=;
        b=xe0XXT8brVgXGzTlap6H9xDOe+SauHmHwoRsb3chtKGz50eKcMYlZ10fpxrAFA36nN
         I1SlAehf9IupWTZqKnQjXK2CsEuJUmdvSjJmE0IjhQl/KndxwMfeLd4MCMuTAxmieg6f
         eUacQIMaYrjMYbg7EE/8uaAYYu1MhmTThOeAJCQjDZQ7i4+OBbL0o2tKCq9GErs7lvLv
         4RuF7bVHnn6JV4CYXDDtT4t5Pqwae2w3Nq1TIjbeabHsW55xczkkXl7KkPVahZA8Yv6b
         NguktNhBynQYLCFjYJ9b3d3F0IyokHJbHneFGt2+j90VKEjdxbIMKURXgt4RGFJissOq
         MhkQ==
X-Gm-Message-State: AOAM532Gvy+Ys+O+rjBcXlpYFastoN+ZZC3b8M42t9GpG/VJsY3Lfhq6
        5ebazOSkzHyTeXpvSDyenw==
X-Google-Smtp-Source: ABdhPJxfNzSDtx7hJ9IWeiR8Ju1BV+067OaqdyKqHEUUyEgP39xyDh5erKxEC5PILhcugCzNVYADaw==
X-Received: by 2002:a05:6808:b19:b0:325:d028:7681 with SMTP id s25-20020a0568080b1900b00325d0287681mr16804320oij.195.1652810758556;
        Tue, 17 May 2022 11:05:58 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id r4-20020aca4404000000b00325cda1ff87sm20013oia.6.2022.05.17.11.05.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 11:05:57 -0700 (PDT)
Received: (nullmailer pid 1337742 invoked by uid 1000);
        Tue, 17 May 2022 18:05:56 -0000
Date:   Tue, 17 May 2022 13:05:56 -0500
From:   Rob Herring <robh@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        kernel@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v6 0/3] document dt-schema for some USB Ethernet
 controllers
Message-ID: <20220517180556.GA1327859-robh@kernel.org>
References: <20220517111505.929722-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220517111505.929722-1-o.rempel@pengutronix.de>
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

On Tue, May 17, 2022 at 01:15:02PM +0200, Oleksij Rempel wrote:
> changes v6:
> - remove USB hub example from microchip,lan95xx.yaml. We care only about
>   ethernet node.
> - use only documented USD ID in example.
> - add Reviewed-by
> - drop board patches, all of them are taken by different subsystem
>   maintainers.
> 
> changes v5:
> - move compatible string changes to a separate patch
> - add note about possible regressions
> 
> changes v4:
> - reword commit logs.
> - add note about compatible fix
> 
> Oleksij Rempel (3):
>   dt-bindings: net: add schema for ASIX USB Ethernet controllers
>   dt-bindings: net: add schema for Microchip/SMSC LAN95xx USB Ethernet
>     controllers
>   dt-bindings: usb: ci-hdrc-usb2: fix node node for ethernet controller

Series applied, thanks.

Rob
