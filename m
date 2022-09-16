Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 149495BB2D0
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 21:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbiIPTan (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 15:30:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230054AbiIPTam (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 15:30:42 -0400
Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C12C959270;
        Fri, 16 Sep 2022 12:30:40 -0700 (PDT)
Received: by mail-oi1-f180.google.com with SMTP id m81so5654803oia.1;
        Fri, 16 Sep 2022 12:30:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=8cuk1eJxoG1FNNo/YKYY7GR8A8kNHB5RJDTvskk+Tfk=;
        b=FsQQdSjPnOsxqhpFociBBOP04f5Pxl0UP8m8apo3ga/7PLAigPMbyswEofT6+P5M7P
         wJhlYYwPPTiWLyOyzqQZ9S2YOcPJq10CFL07NqvIcC2HVk2VgoPdgwFvwGzFeQTH0bCx
         3Vm9iBwTA4tNKfVg+J6zEGaklkgkzEJsh7S59rhfaxPVQe4jnogqMRStwtI9Guga3QM4
         VFUnOgtr5A8o2dEb3NfTiGR0JTqxOrDHnduUkp38cKwR0JnjUcHWKTWMbKLn7WClzEf0
         NNHcnQTRXwFI4Sjl/oj/6y0ICnQqsAbeyOtMesB7LzS8+OPZIJq9etLpUx7sPKmFtbFJ
         nJaQ==
X-Gm-Message-State: ACrzQf2ZQGCHiid1CJH3ZQN3lGNFAv0wDebpjZ/j4OXT7a2WXRuiiMNj
        pW3KTbNn+eBI6+BKYWDiig==
X-Google-Smtp-Source: AMsMyM55WVnfjf35q6Y7UEBkhQeojCI+xmbengY+1s6c3Xj01c34ilWcTHfUCnIzh2JAafjlrQxqgg==
X-Received: by 2002:aca:908:0:b0:34f:87eb:6a62 with SMTP id 8-20020aca0908000000b0034f87eb6a62mr3081579oij.33.1663356640081;
        Fri, 16 Sep 2022 12:30:40 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id k19-20020a4abd93000000b004357ccfc8bfsm9429934oop.7.2022.09.16.12.30.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Sep 2022 12:30:39 -0700 (PDT)
Received: (nullmailer pid 1131728 invoked by uid 1000);
        Fri, 16 Sep 2022 19:30:38 -0000
Date:   Fri, 16 Sep 2022 14:30:38 -0500
From:   Rob Herring <robh@kernel.org>
To:     Matej Vasilevski <matej.vasilevski@seznam.cz>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        "David S. Miller" <davem@davemloft.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Ondrej Ille <ondrej.ille@gmail.com>
Subject: Re: [PATCH v4 1/3] dt-bindings: can: ctucanfd: add another clock for
 HW timestamping
Message-ID: <20220916193038.GA1131695-robh@kernel.org>
References: <20220914233944.598298-1-matej.vasilevski@seznam.cz>
 <20220914233944.598298-2-matej.vasilevski@seznam.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220914233944.598298-2-matej.vasilevski@seznam.cz>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 15 Sep 2022 01:39:42 +0200, Matej Vasilevski wrote:
> Add second clock phandle to specify the timestamping clock.
> 
> Signed-off-by: Matej Vasilevski <matej.vasilevski@seznam.cz>
> ---
>  .../bindings/net/can/ctu,ctucanfd.yaml        | 19 +++++++++++++++----
>  1 file changed, 15 insertions(+), 4 deletions(-)
> 

Acked-by: Rob Herring <robh@kernel.org>
