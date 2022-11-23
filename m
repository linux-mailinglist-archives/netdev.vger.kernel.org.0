Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73897636CE1
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 23:13:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbiKWWL6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 17:11:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbiKWWLj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 17:11:39 -0500
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C4C01165AE;
        Wed, 23 Nov 2022 14:11:00 -0800 (PST)
Received: by mail-il1-f172.google.com with SMTP id z9so48146ilu.10;
        Wed, 23 Nov 2022 14:11:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZvpAjsBIY6CxauQNysBXahbEXeZsGuLG5UKliS76lWc=;
        b=rmyB4q/GZ3z2Uj2kEai/PNH1RMKMN+APhupSKnN9yDv+XaWQBVdLrSEs5PQO78MeOK
         U5tfe1s8Oy7+HFCEzjsg8x47s1n5WFxxrlNf7QcaSU+sa4SX4/PuT78oZBsT7E34WjZL
         oB5XONaryHty/m2DtOjerfTL8lro1iWUfYiK/1EH5La+TggVI/Njsde5ckyunL6dUcTl
         zn+GZo/YOJdocFb9i3DLYLDf1trO6ZFdC9GPiXzsL9WhzvNHFlRUDVW862tY+QWf5g3p
         Rk14Y3FbAUYvcbKc0/uVjoT9/6NHhV4UcNJ41yLv2yTpu2m+niiDM+4RffotkANrirMZ
         juTg==
X-Gm-Message-State: ANoB5pmlFq/5LRnGPm4orvynvICDml5zTaqeEtkS4tGzIL5OX5Y/4NxY
        EeQOpMpKDe/e1WwfI46KYAgxzPiHaQ==
X-Google-Smtp-Source: AA0mqf5oTyICEMlWiHTxi6GCmEp1r76YMR4075FqLwDbzujw3xTSzRE4Hcdj5i6msq/SOPlx2COTQw==
X-Received: by 2002:a92:d5c4:0:b0:302:3522:a0ba with SMTP id d4-20020a92d5c4000000b003023522a0bamr5089130ilq.7.1669241459430;
        Wed, 23 Nov 2022 14:10:59 -0800 (PST)
Received: from robh_at_kernel.org ([64.188.179.252])
        by smtp.gmail.com with ESMTPSA id b2-20020a029582000000b0037612be6830sm6668740jai.140.2022.11.23.14.10.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 14:10:58 -0800 (PST)
Received: (nullmailer pid 2595287 invoked by uid 1000);
        Wed, 23 Nov 2022 22:11:00 -0000
Date:   Wed, 23 Nov 2022 16:11:00 -0600
From:   Rob Herring <robh@kernel.org>
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Michael Walle <michael@walle.cc>,
        Robert Marko <robert.marko@sartura.hr>,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Marcin Wojtas <mw@semihalf.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Taras Chornyi <tchornyi@marvell.com>,
        linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        devicetree@vger.kernel.org, Luka Perkov <luka.perkov@sartura.hr>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH 3/6] dt-bindings: net: marvell,prestera: Convert to yaml
Message-ID: <166924146034.2595222.4336070663199193699.robh@kernel.org>
References: <20221117215557.1277033-1-miquel.raynal@bootlin.com>
 <20221117215557.1277033-4-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221117215557.1277033-4-miquel.raynal@bootlin.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Thu, 17 Nov 2022 22:55:54 +0100, Miquel Raynal wrote:
> The currently described switch family is named AlleyCat3, it is a memory
> mapped switch found on Armada XP boards.
> 
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
> This patch (and the original txt file) can also be dropped if judged not
> worth the conversion as anyway in both cases there is no driver upstream
> for these devices.
> ---
>  .../bindings/net/marvell,prestera.txt         | 29 ------------
>  .../bindings/net/marvell,prestera.yaml        | 45 +++++++++++++++++++
>  2 files changed, 45 insertions(+), 29 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/net/marvell,prestera.txt
>  create mode 100644 Documentation/devicetree/bindings/net/marvell,prestera.yaml
> 

Reviewed-by: Rob Herring <robh@kernel.org>
