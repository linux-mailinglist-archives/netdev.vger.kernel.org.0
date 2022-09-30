Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3F6C5F0DC4
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 16:42:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbiI3Omd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 10:42:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiI3Omc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 10:42:32 -0400
Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BC3010974D;
        Fri, 30 Sep 2022 07:42:31 -0700 (PDT)
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-12803ac8113so5662911fac.8;
        Fri, 30 Sep 2022 07:42:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=ULKqoJL+u08i7TmlDcuxHr17Y1/Swu2KF7s2tCvv9uQ=;
        b=A6wBsk1f50HEf44Dsakjb7RrD34Q5/rLROGu4gsSe3NRFfCA6YKKtuZ8HyS3V7IFlF
         HnQKlb5AcAUjRIjc6Xq38+4r6DJ4yAWHNMkz49fDP/AkiPgPsKQLbbh1CYPd/k11mmUE
         TzxqEeVhuzWhWLXHErD4+cfiAcWWkjT0fU9f0PGg4ejC1YV2Ca0hVlN6LPSxNniJaiPj
         NwTQbZCYOfNq1qTlvyo7Fdg6UACVCBCOGxgGBGKep3THe3dtrOsviIlLPC3MY2UQfumo
         AUIJ4vr0kUHGl65mSFTpBTou9u+ynzfTpaHiE0RIRC+zbvZACUBYnhQvKcPuQwy81GLP
         EkOA==
X-Gm-Message-State: ACrzQf27V2tGpY2zhZyzCDCh2y8/iu3tnP1Rw3zj22DZW8e4DWI9T3eA
        Fldt5Y1Qj4+ot60k5CVeyg==
X-Google-Smtp-Source: AMsMyM5izub2pgMDvY9bxBUdbKRxcSMzllr51EpfC6hmebhPFCjpclH4yUaf06lrdDbaRB/UZqll2g==
X-Received: by 2002:a05:6870:310:b0:f1:f473:a53f with SMTP id m16-20020a056870031000b000f1f473a53fmr11658609oaf.34.1664548950657;
        Fri, 30 Sep 2022 07:42:30 -0700 (PDT)
Received: from macbook.herring.priv (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id e6-20020a4aa606000000b004762a830156sm489963oom.32.2022.09.30.07.42.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 07:42:30 -0700 (PDT)
Received: (nullmailer pid 287203 invoked by uid 1000);
        Fri, 30 Sep 2022 14:42:29 -0000
Date:   Fri, 30 Sep 2022 09:42:29 -0500
From:   Rob Herring <robh@kernel.org>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     kuba@kernel.org, edumazet@google.com, netdev@vger.kernel.org,
        pabeni@redhat.com, devicetree@vger.kernel.org,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org,
        davem@davemloft.net
Subject: Re: [PATCH net-next v4 2/6] dt-bindings: net: tsnep: Allow
 additional interrupts
Message-ID: <166454894890.287139.18142755949749369794.robh@kernel.org>
References: <20220927195842.44641-1-gerhard@engleder-embedded.com>
 <20220927195842.44641-3-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220927195842.44641-3-gerhard@engleder-embedded.com>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Sep 2022 21:58:38 +0200, Gerhard Engleder wrote:
> Additional TX/RX queue pairs require dedicated interrupts. Extend
> binding with additional interrupts.
> 
> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
> ---
>  .../bindings/net/engleder,tsnep.yaml          | 41 ++++++++++++++++++-
>  1 file changed, 39 insertions(+), 2 deletions(-)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
