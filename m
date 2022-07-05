Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABD1556795B
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 23:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbiGEVaF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 17:30:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiGEVaE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 17:30:04 -0400
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D820B92;
        Tue,  5 Jul 2022 14:30:03 -0700 (PDT)
Received: by mail-io1-f43.google.com with SMTP id z191so12381817iof.6;
        Tue, 05 Jul 2022 14:30:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GG1TaxPEH084yANxHAVT8rDvfERSSgkpujDEy9BUhjg=;
        b=eNG6kUDgC9YLxfgkYlYxEPIldIPMBVfJn8e7oZmuIDWi1X6T/vdYMiRoa6B9FZQa5g
         qFFpJjjsw2mIklq1/7Fgca6CzdejU1evFDJOufyIM27yXWq5yE2GOPe70acbN1N2kOrE
         rNcc9jtvG2+oAM/nep2ApP+PkZtbyoUsvNL6GtDLUaTWhv0Gt3jl3LrwMpQQ74z3SBWH
         kUIvblQhaseuKglpP0pcHPe+RwthW8rA0Q/Fr2R689zBiS3jfY7rDP0b/D1C17kfyw/F
         BL5JVhrBaV4wCNpxHs20RRvk8NFKYbttIr7FIN6GP+a0c7GJoAfYBSZqNpAgC/g3ZANr
         41Ng==
X-Gm-Message-State: AJIora+ignDDU5g4PUm0H+LvFOjKkzEmq3K1BQrMKQVGYW7Kkjn3G+sc
        3j07aVFsYmxSJ254F/bQutgxEIsnhA==
X-Google-Smtp-Source: AGRyM1sbx5XIOr7a8+UyrQtQEzd9v6gqI013zxRiYadBZ6rOvFNPa1+D6olRq1rRWA3KgAhoW6Dhug==
X-Received: by 2002:a05:6638:3043:b0:314:7ce2:4a6e with SMTP id u3-20020a056638304300b003147ce24a6emr22641145jak.258.1657056602728;
        Tue, 05 Jul 2022 14:30:02 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id c35-20020a023b23000000b00339e158bd3esm15014511jaa.38.2022.07.05.14.30.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jul 2022 14:30:02 -0700 (PDT)
Received: (nullmailer pid 2674163 invoked by uid 1000);
        Tue, 05 Jul 2022 21:30:01 -0000
Date:   Tue, 5 Jul 2022 15:30:01 -0600
From:   Rob Herring <robh@kernel.org>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     linux@armlinux.org.uk, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, robh+dt@kernel.org
Subject: Re: [PATCH v2 net-next 2/4] dt-bindings: net: sff,sfp: rename
 example dt nodes to be more generic
Message-ID: <20220705213001.GA2674108-robh@kernel.org>
References: <20220704134604.13626-1-ioana.ciornei@nxp.com>
 <20220704134604.13626-3-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220704134604.13626-3-ioana.ciornei@nxp.com>
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

On Mon, 04 Jul 2022 16:46:02 +0300, Ioana Ciornei wrote:
> Rename the dt nodes shown in the sff,sfp.yaml examples so that they are
> generic and not really tied to a specific platform.
> 
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> ---
> Changes in v2:
>  - new patch
> 
>  .../devicetree/bindings/net/sff,sfp.yaml       | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 

Acked-by: Rob Herring <robh@kernel.org>
