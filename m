Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98A1459145C
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 18:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235840AbiHLQzD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 12:55:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbiHLQy7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 12:54:59 -0400
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ACF5B07DA;
        Fri, 12 Aug 2022 09:54:59 -0700 (PDT)
Received: by mail-il1-f180.google.com with SMTP id z13so755751ilq.9;
        Fri, 12 Aug 2022 09:54:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=fRm+MK443iv+bWqysNNlWEdx5OQMpvKZbcU7Wh8UXuE=;
        b=0h6S05Hx7CJjzexBNhziPCTLQdJkIC0j0zQpgqgTXb62uhMEULKJlePz/DmXmPFSQY
         Jm/steKaS2nz64CdFoO3hlRupQEOkm7CFt+5+zy5V19ryUZPsD+cy7yjuv7zvmWYZ7I1
         mwocLGY6PnOGn35rbLDSR++QNRebT1DbDMEmTg/xLNgH0IM1GDTEsImSDZvG+D+V2Vsc
         0U8fNuSBR+hVi1Zo3wqL4mHylRu4Kt/GHwYvW7PC6RD05Z8UnYWnsbQBsbrb3Kmj0oVN
         hzztvMPhXLSUxOg2h+209mOVerifzs+alrQ8cNX84c1k7+CmO8c8tej7H8hbogDYpZi9
         nO4g==
X-Gm-Message-State: ACgBeo3hPiuZD5ZX/Fh7bm2W3aQmIHl9zZBjFCOyAjfW7SmUkQOeLtTk
        IvFDzTWSdVAbL1jUG10xZw==
X-Google-Smtp-Source: AA6agR6tiAMmjfHF8/Q9cMoh1KscSKGBxd6+ZvSHYQseYcfmbrN92lYw48Pzhq+xNnC/wejeACiZbA==
X-Received: by 2002:a05:6e02:148c:b0:2de:c3b:91d with SMTP id n12-20020a056e02148c00b002de0c3b091dmr2342165ilk.95.1660323298542;
        Fri, 12 Aug 2022 09:54:58 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id o4-20020a927304000000b002e4c8200225sm141783ilc.39.2022.08.12.09.54.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Aug 2022 09:54:58 -0700 (PDT)
Received: (nullmailer pid 315561 invoked by uid 1000);
        Fri, 12 Aug 2022 16:54:55 -0000
Date:   Fri, 12 Aug 2022 10:54:55 -0600
From:   Rob Herring <robh@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Michael Hennerich <Michael.Hennerich@analog.com>,
        Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Pavel Machek <pavel@ucw.cz>,
        Tim Harvey <tharvey@gateworks.com>, Lee Jones <lee@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sebastian Reichel <sre@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Andrew Davis <afd@ti.com>,
        linux-hwmon@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-leds@vger.kernel.org,
        netdev@vger.kernel.org, linux-pm@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH v2 0/5] iio/hwmon/mfd/leds/net/power/ASoC: dt-bindings:
 few stale maintainers cleanup
Message-ID: <20220812165455.GA315443-robh@kernel.org>
References: <20220809162752.10186-1-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220809162752.10186-1-krzysztof.kozlowski@linaro.org>
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

On Tue, Aug 09, 2022 at 07:27:47PM +0300, Krzysztof Kozlowski wrote:
> Hi,
> 
> Changes since v1
> ================
> 1. Patch #5: Drop also Ricardo Rivera-Matos and assign TI bindings to Andrew Davis
> 2. Add acks.
> 
> A question
> ==========
> 
> Several of the bindings here had only one maintainer and history does not
> always point to a new one (although I did not perform extensive digging). I
> added subsystem maintainer, because dtschema requires an entry with valid email address.
> 
> This is not the best choice as simply subsystem maintainer might not have the
> actual device (or its datasheets or any interest in it).
> 
> Maybe we could add some "orphaned" entry in such case?

It would need to be obvious to not use for a new binding.

> 
> Best regards,
> Krzysztof
> 
> Krzysztof Kozlowski (5):
>   dt-bindings: iio: Drop Joachim Eastwood
>   dt-bindings: iio: Drop Bogdan Pricop
>   dt-bindings: Drop Beniamin Bia and Stefan Popa
>   dt-bindings: Drop Robert Jones
>   dt-bindings: Drop Dan Murphy and Ricardo Rivera-Matos

Series applied for 6.0-rc1.

Rob
