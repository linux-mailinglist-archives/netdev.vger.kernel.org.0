Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 668815E940B
	for <lists+netdev@lfdr.de>; Sun, 25 Sep 2022 17:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbiIYPpE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Sep 2022 11:45:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232535AbiIYPpD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Sep 2022 11:45:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0B581A234;
        Sun, 25 Sep 2022 08:45:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6F092B81244;
        Sun, 25 Sep 2022 15:45:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 046CAC43470;
        Sun, 25 Sep 2022 15:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664120699;
        bh=56m/znKoTqndib5n/0vCAB2QHcSxXEmvepAWYlZLhWk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=QQLd9wkzmzjg2Y9MYtxD7yTDj0m/R13xWOkIr4gOzrwcYyNlUgMPBz2WoG2Iifo6M
         b4rdth7ywIDrJBzjsGx9/3pA892Nu7JSCiwCt00ttI8lC+zO65TZzIhIu9/0a6S5gL
         luaMcuQf8AoQvud3q4Tbgl3bMH5wv5HyXF8xhFoNXrB6eXEHWBU6BDndY/uRlGq0dB
         Tx3OeBlCcX1n2uFAEL7a/yV2Ri7rcV+PJqI3gxvZMc8gkrraex+SULO0JGse3zdmqq
         79WH+Y7L+Dg3RWKZiO3+urVehnbcfloeJgVSb3+wXu5djvw+S8c4Z0KZATiWO5cAfz
         F+pYCgtLhrm3w==
Received: by mail-vs1-f50.google.com with SMTP id d187so4431864vsd.6;
        Sun, 25 Sep 2022 08:44:58 -0700 (PDT)
X-Gm-Message-State: ACrzQf01Z999lfLO0f+iVso7Hb0sxNvAbXXkDhX/zG1Tatsc1eMYwksT
        ERnUJU6IB1ErqncNhMRX3jWtz4pDkZD2Qt5kLQ==
X-Google-Smtp-Source: AMsMyM7/3q9FshtDglD88xmTCGAJX/8emrrdhymK14qX1nCmQ86CE+9eL8oqG7N/RaB47ay+Ukfhad/Do05B2gOjn7g=
X-Received: by 2002:a67:c18a:0:b0:398:4c72:cafb with SMTP id
 h10-20020a67c18a000000b003984c72cafbmr6274564vsj.53.1664120697844; Sun, 25
 Sep 2022 08:44:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220919164834.62739-1-sven@svenpeter.dev> <20220919164834.62739-3-sven@svenpeter.dev>
In-Reply-To: <20220919164834.62739-3-sven@svenpeter.dev>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Sun, 25 Sep 2022 10:44:46 -0500
X-Gmail-Original-Message-ID: <CAL_Jsq+32LpvsFC+sCVsqzncgokYRd+oXUQYirumr-boz_RwKQ@mail.gmail.com>
Message-ID: <CAL_Jsq+32LpvsFC+sCVsqzncgokYRd+oXUQYirumr-boz_RwKQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/7] dt-bindings: net: Add Broadcom BCM4377 family PCIe Bluetooth
To:     Sven Peter <sven@svenpeter.dev>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hector Martin <marcan@marcan.st>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        asahi@lists.linux.dev, netdev <netdev@vger.kernel.org>,
        devicetree@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "open list:BLUETOOTH DRIVERS" <linux-bluetooth@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 19, 2022 at 11:49 AM Sven Peter <sven@svenpeter.dev> wrote:
>
> These chips are combined Wi-Fi/Bluetooth radios which expose a
> PCI subfunction for the Bluetooth part.
> They are found in Apple machines such as the x86 models with the T2
> chip or the arm64 models with the M1 or M2 chips.
>
> Signed-off-by: Sven Peter <sven@svenpeter.dev>
> ---
> changes from v2:
>   - extended example to include parent pcie node to make
>     node name validation work
>   - moved to bluetooth/ subdirectory
>   - added maxItems to reg and dropped description
>   - moved bluetooth-controller.yaml reference after description
>
> changes from v1:
>   - added apple,* pattern to brcm,board-type
>   - s/PCI/PCIe/
>   - fixed 1st reg cell inside the example to not contain the bus number
>
>  .../net/bluetooth/brcm,bcm4377-bluetooth.yaml | 81 +++++++++++++++++++
>  MAINTAINERS                                   |  1 +
>  2 files changed, 82 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/bluetooth/brcm,bcm4377-bluetooth.yaml

Reviewed-by: Rob Herring <robh@kernel.org>
