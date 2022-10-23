Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEDC6609437
	for <lists+netdev@lfdr.de>; Sun, 23 Oct 2022 17:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230208AbiJWPE2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Oct 2022 11:04:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbiJWPE2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Oct 2022 11:04:28 -0400
Received: from mail-oa1-x29.google.com (mail-oa1-x29.google.com [IPv6:2001:4860:4864:20::29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DED05B1E3
        for <netdev@vger.kernel.org>; Sun, 23 Oct 2022 08:04:25 -0700 (PDT)
Received: by mail-oa1-x29.google.com with SMTP id 586e51a60fabf-1322fa1cf6fso9313523fac.6
        for <netdev@vger.kernel.org>; Sun, 23 Oct 2022 08:04:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=A6yRufizX+sJOw9PwTba9rH6bgoIJN2K17tk3nl03P4=;
        b=O6RVOCLroMjlj9fZLcZPuWWVdcDJai2Yb1j4xpcBYq6Mzom6LpEiLlAv5zgeLtQt8m
         ryiCUwYjiU8ilgYemdd3Iy2Fl9qbRF/S2blFUEReWdacqRbsycnPuLsjhG1zZNWWe/rh
         f4mfQWQNbnSYE1SrSrS58/GCobsDgpyA8/eQdHeT2j9gWR+YKwYnELrA4tYmwRFST+Ps
         EbvIzhZ+rSc+XQiv444kj14RZC+xkPEVYG/GH/DJFl7KXnWaMQBWmApLYzIR0t73+Es8
         vycJ72MccEI7NN/rTCtwZfprOqn6v7VWut15IqN4hLashDEIN4aatyD/0El1M4aISJv9
         7+fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=A6yRufizX+sJOw9PwTba9rH6bgoIJN2K17tk3nl03P4=;
        b=s3bR6xDC8k13RHdea7yVxUEaQiIlJMUH+aiygyRBlqiDEydHKN0busivj77jfU3dgS
         2p//RFWcUHxaztL0mqNZp+Rw6TFovjhR9I4Mdmjccj7aUeNTCfrshQPfcEH0LmnsoagP
         LunwpvuA+uZtJqn0kkg6CCxM2DQHtBCTtFGPrx0tdtsUBOYDrvyxXwly5HcqFmUZrcCR
         D8QyxTlFobT7fufnEdeSnshxvUEf1MmbOS7/9VPi463B0gaxLcKq8DvE1oKarlL65+wQ
         CYRUaWmsc4eZbrutdAFZArOnbtOL1YT7fbwPH4/HlyeQ5ySjbA1IH9grH0Kk2gdwOd50
         HAUA==
X-Gm-Message-State: ACrzQf3d/L2Npx8s+yKwzvRvhkAWW3rO6y4I8DZjGSFKSrZC47OdtOi8
        bziECwyTuuYwGBxvMVZySfIMaivm4FMN850NpHqkVg==
X-Google-Smtp-Source: AMsMyM439AW6P9IaP2apO1Mdlg3gm2c/a4wPzbpLN/az/ZKKAp6G4BubqWiavTKTjegvXS+TIMLRzw70bq9vTJkeQsk=
X-Received: by 2002:a05:6870:a414:b0:131:25e5:df0e with SMTP id
 m20-20020a056870a41400b0013125e5df0emr17702847oal.285.1666537465256; Sun, 23
 Oct 2022 08:04:25 -0700 (PDT)
MIME-Version: 1.0
References: <20221020094106.559266-1-andy.chiu@sifive.com> <20221020094106.559266-3-andy.chiu@sifive.com>
 <495eb398-bec4-5d68-ef5d-4f02d0122a7c@amd.com> <20221021022058.GA2191302-robh@kernel.org>
In-Reply-To: <20221021022058.GA2191302-robh@kernel.org>
From:   Andy Chiu <andy.chiu@sifive.com>
Date:   Sun, 23 Oct 2022 23:04:14 +0800
Message-ID: <CABgGipWHztqv=8qNNWSc1srcy0tyKg9tUcD-1qKBO-FzGFfR8w@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] dt-bindings: add mdio frequency description
To:     Rob Herring <robh@kernel.org>
Cc:     Michal Simek <michal.simek@amd.com>, davem@davemloft.net,
        kuba@kernel.org, michal.simek@xilinx.com,
        radhey.shyam.pandey@xilinx.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        krzysztof.kozlowski+dt@linaro.org, pabeni@redhat.com,
        edumazet@google.com, greentime.hu@sifive.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > +- xlnx,mdio-freq: Define the clock frequency of the MDIO bus. If the property
> > > +                 does not pressent on the DT, then the mdio driver would use
> > > +                 the default 2.5 MHz clock, as mentioned on 802.3 spc.
> >
> > Isn't it better to specify it based on ccf description. It means &clk and
> > used clock framework to find value?
>
Maybe I missed something, but I'd prefer using a number to define the
frequency of the bus rather than basing on the ccf description for our
use case. First, it is more straightforward because ccf requires us to
define a separate DT node and point to it. And currently we don't need
to do extra management that would benefit from using ccf. All we need
to do with the clock is to get its frequency.

> Or use 'bus-frequency' which IIRC is defined for MDIO.
>
I found that "bus-frequency" first appeared in fsl driver but was
replaced later by the standard one, which is "clock-frequency" as
defined in mdio.yaml. We will submit a v2 patch to configure
non-convention MDIO bus frequency with that DT entry.

Thanks and regards,
Andy
