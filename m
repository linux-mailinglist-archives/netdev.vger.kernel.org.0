Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEBE656D80B
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 10:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbiGKIbv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 04:31:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbiGKIbt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 04:31:49 -0400
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E138D1F2CF
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 01:31:47 -0700 (PDT)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-31cac89d8d6so41687807b3.2
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 01:31:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3J9IyHuNdf4RzUYhyAwrvjFLRiRYfpINA65MRt4kKgM=;
        b=WxLDiTDJ/cGeyxc13LPwdMBwqy9mf7NUwb8pTiIlyxslwk4PbnCJ5wM4ZxQ35hQTGW
         6TdMU9/dafniNVuenzFjx8a4yzjl2UN+41lCphU9wQ862bHH/avz5vqbTBj9jqQaFTop
         t8HZ+LNAl5fhEr5lPMGTw8emV50wpE1Z0y/D+PtanoEug9S0I/UR/GQ0bIkGpXqWChXT
         CkuPZLS4pRGNHOkZbqcNlOGOWC5EV6GRURwUkV01gXNwuLub3EVxobjhfETIqSQVT9b+
         wP0ObIClelaK0DwNKkMyl6qbPjhB/sHo2bzFrYhWWiwB5gnKjXI2bQ5PXWtp/oubc5um
         +6Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3J9IyHuNdf4RzUYhyAwrvjFLRiRYfpINA65MRt4kKgM=;
        b=G7hksnWQcSWb9FIA6mlPGhkqqUJG4ufAHxOITec0tItQYZK4nbrGp0gEB7B7QdGZGP
         rN1szOcpHy/77qgIoZPrJ5s2A56C+vIuaYTJngYuln7uHU6ETAVYKaDnZetqh4QdedJ1
         eOHt9UI3tEVdUBUjULwdmawo5kTKTiQJvYQWNgFFDnSX3UQyAdhGaXf2qGkIlHVjjzz4
         v14suNpt0HBnqB+mWV0b8y3ZcPtVyiDql8cw9mLnxnaAcqv0cdVIIeH3NcO4n7dtraY+
         DmVc6V8PcTaCy3IGd95OuXo6ZFJyMak/jy3zMeyX1YoyBbwOJzdkncv1gXgaEbWy3GSE
         5pMA==
X-Gm-Message-State: AJIora8Eaubhg5PyR1Y7aTIsmJq5yAwkkjS89WGZNkFGknoStuCX/cxu
        ggv7Ez3aXKoMR8v8Y+CWjptJRNokfbkXHDog22f1rg==
X-Google-Smtp-Source: AGRyM1u/2OXTB+9LffDEL+06zw4GuQSG0hG72hUyRzuw00qzHcEs9iDFO58dE3J4U/ALR03h0POcpnK5re78d+8pfSI=
X-Received: by 2002:a81:6cf:0:b0:31c:913c:144c with SMTP id
 198-20020a8106cf000000b0031c913c144cmr18316528ywg.437.1657528307206; Mon, 11
 Jul 2022 01:31:47 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1656583541.git.hakan.jansson@infineon.com> <e3f949c067ad07a1dd34247efc49f3d913c4f7c6.1656583541.git.hakan.jansson@infineon.com>
In-Reply-To: <e3f949c067ad07a1dd34247efc49f3d913c4f7c6.1656583541.git.hakan.jansson@infineon.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Mon, 11 Jul 2022 10:31:36 +0200
Message-ID: <CACRpkdYoe1-kCepz2J3h7H15rcG-a2o6y-GHOwaC6f+ipLTQhg@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] dt-bindings: net: broadcom-bluetooth: Add CYW55572
 DT binding
To:     Hakan Jansson <hakan.jansson@infineon.com>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
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

On Thu, Jun 30, 2022 at 2:46 PM Hakan Jansson
<hakan.jansson@infineon.com> wrote:

> CYW55572 is a Wi-Fi + Bluetooth combo device from Infineon.
> Extend the binding with its DT compatible.
>
> Signed-off-by: Hakan Jansson <hakan.jansson@infineon.com>
> Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
