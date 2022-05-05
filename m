Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33BF151C210
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 16:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380471AbiEEORX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 10:17:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380466AbiEEORU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 10:17:20 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BACCE5A0BF
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 07:13:39 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id s30so7833488ybi.8
        for <netdev@vger.kernel.org>; Thu, 05 May 2022 07:13:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lW6YmRKgJEIh2eED/+IVKB8oDvU0WH+BiMyppYMx/nM=;
        b=zRf9tcadFcwynKQBoYA64Lhbx0xApTOpYvVH3ChFo8G0O3Q42LTXvPFy2avUIosaxs
         eI/9NDOOxChHWnLG9j4KMH1uDozXcWHLqD3rKvkn5P23hu+BjPvG80E6Hlt4re4yEGOF
         a79yE0QSTarwGHbPm6yGYVug/rEklsGNWdDx5+KZ4wjvdY+EUhliF6eG0s+GFTq4eJkF
         Rt+Z8xSbn0iWUAUnW5ICTnVTzmiWmGIB1xU4+yGAfmm94gCu/hhO/dPsjt5+9naj70cu
         6K/ixeB/Yxgj6A+L3PD1a7oxLfQNvwRRGO8f5qfrT4DvlUlG/WVwVNWxp6EBMIP9b6AY
         Y8eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lW6YmRKgJEIh2eED/+IVKB8oDvU0WH+BiMyppYMx/nM=;
        b=lyhwImbd/rVs2uWMRUz+IuR7PjgwA7eMKBHr6NtOCKnFySHYhIfld123v110Hhcd3M
         wzvN3ymSguHHLdtf4nutVn8EB9fE6ddXrLIB30133RIG0XnEfi/2ruTO5BtRb5gL8n+0
         WR7HX0Pec6krFDopn4MkujCJ8lYrNN64dzpjqcZYZDke3TuXVt5Z6BuPQOfkJZebfhek
         uId8Fn4yGKX4+VF2xcTN8aS5EUoNeh1Dqe9C/WhCFHLBcvcFM0XvGopBVbRehRotYTEK
         GFO7IvHbk2CebXAcB1fwKSMj5W55wLj9WjKN4/M0k093jwnkEl2YLQe5NzqM5D8MGg5S
         5Axg==
X-Gm-Message-State: AOAM531VHXn1g+Wcss2W1Vocchfl9R91dhNvfluxBPhF0U1R8BCkl9Ex
        dMOXmmPCXzvXBrknfcihjUTUUtsXbCwrmkezDYwfqw==
X-Google-Smtp-Source: ABdhPJxQAuCxjgHTzW1wkwTxSKVB4kNQ0PrFCSz6LO6VQMK/t4AKo5edK5uR1u6CXZQ9Z3o/wrUqc+6yWQKD7cWSC+8=
X-Received: by 2002:a25:bcc7:0:b0:648:d728:d39 with SMTP id
 l7-20020a25bcc7000000b00648d7280d39mr22100634ybm.514.1651760019039; Thu, 05
 May 2022 07:13:39 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1651647576.git.hakan.jansson@infineon.com>
 <64b59ca66cc22e6433a044e7bba2b3e97c810dc2.1651647576.git.hakan.jansson@infineon.com>
 <CACRpkdY3xPcyNcJfdGbSP5rdcUV6hr87yJNDVDGZdRCfN+MqLA@mail.gmail.com> <1e8cfbc6-8452-0e87-9713-536d235e5b51@infineon.com>
In-Reply-To: <1e8cfbc6-8452-0e87-9713-536d235e5b51@infineon.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Thu, 5 May 2022 16:13:26 +0200
Message-ID: <CACRpkda4ByrS8RGAunno_S59+Y2yado4eObzwsVkM2Q=n-B+CQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] dt-bindings: net: broadcom-bluetooth: Add property
 for autobaud mode
To:     Hakan Jansson <hakan.jansson@infineon.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-bluetooth@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 5, 2022 at 3:11 PM Hakan Jansson <hakan.jansson@infineon.com> wrote:

> I suppose a general flag could be useful but to be honest I don't know
> if any other devices besides the ones using the Broadcom driver has any
> use for it. You would probably also still want to be able to use
> current-speed to set the link speed and end up using both
> current-speed=x and current-speed-auto at the same time, which might
> look a little confusing?

I do not think it is more confusing than being able to use
current-speed and brcm,uses-autobaud-mode at the same time.

> Please let me know if you'd still prefer "current-speed-auto" over
> "brcm,uses-autobaud-mode" and I'll revise the patch and rename it!

It actually depends a bit.

This:

> >> +      The controller should be started in autobaud mode by asserting
> >> +      BT_UART_CTS_N (i.e. host RTS) during startup. Only HCI commands supported
> >> +      in autobaud mode should be used until patch FW has been loaded.

sounds a bit vague?

Does it mean that CTS is asserted, then you send a bit (CTS then goes low)
and then CTS is asserted again when the device is ready to receieve more
data? i.e is this some kind of one-bit mode, because it doesn't sound like
it is using CTS as it was used in legacy modems.

Some more explanation of this mode is needed so we can understand if
this is something generic or a BRCM-only thing.

Yours,
Linus Walleij
