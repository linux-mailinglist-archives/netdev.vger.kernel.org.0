Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2935B52A5B8
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 17:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349700AbiEQPLp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 11:11:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiEQPLo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 11:11:44 -0400
Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACA2E3BF83;
        Tue, 17 May 2022 08:11:43 -0700 (PDT)
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-edf9ddb312so24526537fac.8;
        Tue, 17 May 2022 08:11:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vKffu75/JaeR+3h2YIHGd7s27VZFAWG85y0Vy+z5Neg=;
        b=R5LJbXV+ZGR9lmAPfNdMmGsMMlE9iNM2qbDYN7PQItrkV+M7P9VHtHmv1jCVYUTKKg
         W//gn54YTc2A8TLfX59D37HHvRDMiFqhLoDUUwHY//o+J1sY0CuIyP9ZfBc87FqGL5o2
         oPEPwPbe974+LYgaQ+CyMmyj7TKrOheVu4qUlEhaDkwTeCIQRuQp3i1jkke2rfWENNbj
         DhX8W8wcnPX6qlqErY9OPwJLrryi9wsZpui1XHgS4U0ArYRVOoSs59L9II6CQe453e5k
         vlkLsvSxGsn80SdBQF+COHQUCEobrh+Ha9Tdbcln6uFUSnXO4rWI+cofIPxMHPLSPbkM
         KixA==
X-Gm-Message-State: AOAM5303QcXVORTQOFNgMf1tuJ98YJvO+kqed8chEOeXDQhK2GA6dwVj
        zzgyEg5QnZUGQIPI9fQE0g==
X-Google-Smtp-Source: ABdhPJy8jacFLS6QJGBGYc5xwP/7byPwy7Vt4hC+lhvsItbre7bDr1MI4/AWGviHlME6OAqLa0hvVw==
X-Received: by 2002:a05:6870:a928:b0:da:b3f:320a with SMTP id eq40-20020a056870a92800b000da0b3f320amr12236838oab.186.1652800302955;
        Tue, 17 May 2022 08:11:42 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id t18-20020a056870609200b000f1952c6bc1sm3660979oae.31.2022.05.17.08.11.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 08:11:42 -0700 (PDT)
Received: (nullmailer pid 1043899 invoked by uid 1000);
        Tue, 17 May 2022 15:11:41 -0000
Date:   Tue, 17 May 2022 10:11:41 -0500
From:   Rob Herring <robh@kernel.org>
To:     Chris Packham <chris.packham@alliedtelesis.co.nz>
Cc:     sebastian.hesselbarth@gmail.com, robh+dt@kernel.org,
        davem@davemloft.net, pabeni@redhat.com, andrew@lunn.ch,
        edumazet@google.com, kuba@kernel.org, kabel@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregory.clement@bootlin.com
Subject: Re: [PATCH 2/2] dt-bindings: net: marvell,orion-mdio: Set
 unevaluatedProperties to false
Message-ID: <20220517151141.GA1043840-robh@kernel.org>
References: <20220516224801.1656752-1-chris.packham@alliedtelesis.co.nz>
 <20220516224801.1656752-3-chris.packham@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220516224801.1656752-3-chris.packham@alliedtelesis.co.nz>
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

On Tue, 17 May 2022 10:48:01 +1200, Chris Packham wrote:
> When the binding was converted it appeared necessary to set
> 'unevaluatedProperties: true' because of the switch devices on the
> turris-mox board. Actually the error was because of the reg property
> being incorrect causing the rest of the properties to be unevaluated.
> 
> After the reg properties are fixed for turris-mox we can set
> 'unevaluatedProperties: false' as is generally expected.
> 
> Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
> ---
>  Documentation/devicetree/bindings/net/marvell,orion-mdio.yaml | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Acked-by: Rob Herring <robh@kernel.org>
