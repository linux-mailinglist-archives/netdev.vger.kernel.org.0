Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E96254F8122
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 15:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343771AbiDGOBl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 10:01:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343774AbiDGOBa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 10:01:30 -0400
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 067181B4EAF;
        Thu,  7 Apr 2022 06:59:28 -0700 (PDT)
Received: by mail-oi1-f182.google.com with SMTP id r8so5696514oib.5;
        Thu, 07 Apr 2022 06:59:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gY4xGhFaZYmhxVHeHJPlZtUO7C+28HCY3WMACqhti8o=;
        b=SnFr9h/d0fDyUlnOJ/3zn/7OylYEcrk5nJov9H2s8pudqcqKZDYse8NeCl4PjBZv2F
         8o89vm2wrSq8CsVV53Oxtm9RsDHosNGIMULvwLt+R3Sr531AfERhKFajv0H5O+NVI6Pe
         Gh9PL3n6aqGJwCDO/RO5Fj4NFsgsy9RHDZbKaUR+s3kj56xIiJNKuqrXIGqbrtzrUcdU
         LGhJzqttKzITf+1FbKth4wYmhH/kVUpg5GaUJ5vOJTplNe57e05acaXVNxbTcZMJ+gb0
         /kvw/KBFO+zcWh6YPJJcSJCpmCMOk0D/4+P3xDANMLsoH5ZpBKTxZwgPJ53XigDwn09B
         4vMA==
X-Gm-Message-State: AOAM5335NPnwtGmhhBZafwnRTBgp/jhJbKJi5J3erjKfaxLqOJa3WHnt
        IO6OrixshWawPGg4FEkTAoDdYYg4jg==
X-Google-Smtp-Source: ABdhPJwBgLGWhJPXEEX8MOytgZffLUBkzsQJtfyBPTbwAUQxqbH1+mVSpxYvMc+vk8saZ3UbfK3Xog==
X-Received: by 2002:a05:6808:1528:b0:2f9:65fa:b878 with SMTP id u40-20020a056808152800b002f965fab878mr5862331oiw.99.1649339967361;
        Thu, 07 Apr 2022 06:59:27 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id e12-20020a4aa60c000000b00324bb45d7ecsm7055221oom.48.2022.04.07.06.59.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 06:59:27 -0700 (PDT)
Received: (nullmailer pid 807680 invoked by uid 1000);
        Thu, 07 Apr 2022 13:59:26 -0000
Date:   Thu, 7 Apr 2022 08:59:26 -0500
From:   Rob Herring <robh@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Masami Hiramatsu <mhiramat@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>
Subject: Re: [PATCH 0/2] dt-bindings: net: Fix ave descriptions
Message-ID: <Yk7uPkFiLjTFTySI@robh.at.kernel.org>
References: <1649145181-30001-1-git-send-email-hayashi.kunihiko@socionext.com>
 <62711467c3990d38ed8a11bf1c7c2594e8e1b436.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62711467c3990d38ed8a11bf1c7c2594e8e1b436.camel@redhat.com>
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

On Thu, Apr 07, 2022 at 10:18:29AM +0200, Paolo Abeni wrote:
> Hi,
> 
> On Tue, 2022-04-05 at 16:52 +0900, Kunihiko Hayashi wrote:
> > This series fixes dt-schema descriptions for ave4 controller.
> > 
> > Kunihiko Hayashi (2):
> >   dt-bindings: net: ave: Clean up clocks, resets, and their names using
> >     compatible string
> >   dt-bindings: net: ave: Use unevaluatedProperties
> > 
> >  .../bindings/net/socionext,uniphier-ave4.yaml | 57 +++++++++++++------
> >  1 file changed, 39 insertions(+), 18 deletions(-)
> 
> @Rob: since you acked this series, I guess you prefer/except this will
> go via net net-next tree, is that correct?

Yes, please. Though often I pick up the standalone DT net patches 
because the netdev maintainers haven't. 

Rob
