Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6863C62EA99
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 01:54:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240747AbiKRAyY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 19:54:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240695AbiKRAyX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 19:54:23 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18C961FCDF
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 16:54:23 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id h193so3623121pgc.10
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 16:54:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gateworks-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=eRHZ8HxlKkpc/rQw9TF/Vjc6A04s7AH3fGHGNV8IcdM=;
        b=EMdaRR5ywe+TV/FYyD9a2i+UB/WspihcuIixd5Dr21nxmE+kcbN8TtOmL46bnAWEJZ
         kOMiPHdykN4qZbMIGafcSieL2JCDwRT1Gn5eDVMjpDrz6ejrGhrSbXWcjDVzKmH4t0kI
         elpclmBAb7rzG6BXcOB8kac8xK+aTsSO/BR5vCsDUvAsEuE/cvxFv1w+4ff1loBLW96l
         0yyqyGGuegV0UUvNRmtSwuv2elmshJ+Uldj5RrMlnESTdSN+SpgwZSPmNoQlgf2HfRo7
         1pcksb6gWej+VA9v9FvtxqoTUtsJVb/9HwmI9H6HwxDLzZlotYwNIr+cOvTN/Ul7FA4r
         e5cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eRHZ8HxlKkpc/rQw9TF/Vjc6A04s7AH3fGHGNV8IcdM=;
        b=KIsxX4lxVzTTqIgXKXDDnNWJJVSI8aFf6pccegu1M3zG5dys/aRGVDhvuEMCmAk1/u
         bqv14sliQWIYFuoOPFwQVqTfjNv/6IUnvDjZcY4A+1owq/+sykO7IKykdx18Uw6BndDm
         4dI44iXFSlTq8NW6PDCwb/n7Qsl7/SJPj8qdICfEUs4fhEsU24tNmsp2P0ic2ZesUFIh
         G/rbkV6j3p41Y3fcuLsBO2LNciHZpztfkAOO+I3Lx+G+YuGvT4G11KcmGG5ekv8J0CdF
         3qGIzYGpWmnCd6nH4F94SpVSsrQh0OQqo787GHtLQtOsrq8IjMYTtq3VOOzZuZthyKMN
         SxjQ==
X-Gm-Message-State: ANoB5pnGKVibGzUp11vOq9sRWRXRxtKfhZ0h46E9xfpVpElgcuzU/9PL
        +FYrnufYBOcvFsnN6w/OHU/weCTFGwR7Ly0jFqIECg==
X-Google-Smtp-Source: AA0mqf577aAwYGvH4qpaYZECY2LNNaZytgtXT9uUrDcNBCNowZCpDJhrRK4S5gagrFXZqiA33J0kBMych14iLw5Etbc=
X-Received: by 2002:a05:6a00:4009:b0:563:2ada:30a3 with SMTP id
 by9-20020a056a00400900b005632ada30a3mr5481609pfb.27.1668732862572; Thu, 17
 Nov 2022 16:54:22 -0800 (PST)
MIME-Version: 1.0
References: <20221118001548.635752-1-tharvey@gateworks.com> <Y3bRX1N0Rp7EDJkS@lunn.ch>
In-Reply-To: <Y3bRX1N0Rp7EDJkS@lunn.ch>
From:   Tim Harvey <tharvey@gateworks.com>
Date:   Thu, 17 Nov 2022 16:54:11 -0800
Message-ID: <CAJ+vNU3P-t3Q1XZrNG=czvFBU7UsCOA_Ap47k9Ein_3VQy_tGw@mail.gmail.com>
Subject: Re: [PATCH 0/3] add dt configuration for dp83867 led modes
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 17, 2022 at 4:27 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Thu, Nov 17, 2022 at 04:15:45PM -0800, Tim Harvey wrote:
> > This series adds a dt-prop ti,led-modes to configure dp83867 PHY led
> > modes, adds the code to implement it, and updates some board dt files
> > to use the new property.
>
> Sorry, but NACK.
>
> We need PHY leds to be controlled via /sys/class/leds. Everybody keeps
> trying to add there own way to configure these things, rather than
> have just one uniform way which all PHYs share.
>
>      Andrew

Andrew,

I completely agree with you but I haven't seen how that can be done
yet. What support exists for a PHY driver to expose their LED
configuration to be used that way? Can you point me to an example?

Best Regards,

Tim
