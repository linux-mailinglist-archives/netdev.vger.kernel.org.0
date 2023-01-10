Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2613F664E80
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 23:05:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233728AbjAJWFb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 17:05:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233940AbjAJWFM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 17:05:12 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F5CF6219B;
        Tue, 10 Jan 2023 14:05:11 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id 18so19683383edw.7;
        Tue, 10 Jan 2023 14:05:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WrKmlWHDUV61DahQUIaVkiL3+243B01IgkXVVlGEa8Y=;
        b=IU6f2FJsgTYlQlUxPC3SgJJ3nHFscGea08quQshVivr8hFfTaCsq0s0LtncJiE9VM6
         3mP91XMs097IQMqGrGDeR9Q+Nn9BKmtDOAQCWiDZ2Q8eVwcQryoz9SH1KeWnpPHN45c3
         rPkRe1EqQB8QmpZv3Xy+dztrHgOb2VFHNMCQaPsGirHXniNzQLu5bPySZcqFWzYtaPmq
         5A2dtC34COH9kL8iMQXmAHCiJ4F7MQp47VlpgBt+vNEbw1EwcfbsX8aGYfoKUM8gt1hz
         GDPLFshOAOL8YRSF/7Z9ozAVNX/9vQQ2R1X1DLFRvX0Cj+ub7mHHtQz157FGqOyEOaRD
         YtfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WrKmlWHDUV61DahQUIaVkiL3+243B01IgkXVVlGEa8Y=;
        b=QgDf5nTv+yAN18kKdiPKO8rTPLJTbBnR7UZ6YoYmVmniPdrg+g/QQYmCtoa0qAQRNX
         lcZ7TPFtzj1wEYFwvj89tPvBTWGqdhcnG2K9zTPJwQmcpadPFEJq6rVeFBIz9N3iYo78
         Ieb04EmGw0FpTp6j7ESrsPOcb+IF/KqAOGg8OVjICMamRTZB8VZiDBev+f++URHNwKYs
         5NE0SjUOT3eSfqAGp2Z4YSIWrufw/k3awvHkbdEaSKfpptMUSPA3algFSREZV02N0JBI
         NLvsQMYdLOzub805SLcRs3//S8NfkBd74fA7hN1nym17jXiJnnnnV54YbUnyJs4x1l5+
         iLnQ==
X-Gm-Message-State: AFqh2ko4ZfbrA2OTRBKkBHrczX3rqwFUDXPYb00Yfx8OuBcbvIGSN6mt
        hvxn88dOZjMKLDojMs3YWw/95FOL6kayzS1t+y4=
X-Google-Smtp-Source: AMrXdXslMt+extOJ67lNrPk/gzoVhLdRWwj56JScPZGQacLbHpwmoFzQ7g3CAvQIElO72fbF6+niQAf0El2SmKxOxfk=
X-Received: by 2002:a05:6402:78b:b0:494:cb79:1ff3 with SMTP id
 d11-20020a056402078b00b00494cb791ff3mr2392529edy.291.1673388309924; Tue, 10
 Jan 2023 14:05:09 -0800 (PST)
MIME-Version: 1.0
References: <20221117-b4-amlogic-bindings-convert-v2-0-36ad050bb625@linaro.org>
 <20221117-b4-amlogic-bindings-convert-v2-3-36ad050bb625@linaro.org> <5c59d432-3785-8eaa-af77-03fee09b5fd3@linaro.org>
In-Reply-To: <5c59d432-3785-8eaa-af77-03fee09b5fd3@linaro.org>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Tue, 10 Jan 2023 23:04:58 +0100
Message-ID: <CAFBinCCjDLN5owiD1x5UNcBiE7P6czkS1wrSYKn-bBPCHQxT9Q@mail.gmail.com>
Subject: Re: [PATCH v2 03/11] dt-bindings: nvmem: convert amlogic-meson-mx-efuse.txt
 to dt-schema
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Neil Armstrong <neil.armstrong@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, linux-media@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-mmc@vger.kernel.org, linux-pci@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Neil, Hi Krzysztof,

On Tue, Jan 10, 2023 at 11:15 AM Krzysztof Kozlowski
<krzysztof.kozlowski@linaro.org> wrote:
[...]
> > +  secure-monitor:
> > +    description: phandle to the secure-monitor node
>
> Missing $ref
Actually this IP does not connect to a secure-monitor. So the
secure-monitor property can be removed.


Best regards,
Martin
