Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BFBD5184EE
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 15:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235768AbiECNIN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 09:08:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231274AbiECNIM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 09:08:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6539E22510;
        Tue,  3 May 2022 06:04:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1DD7CB81E5F;
        Tue,  3 May 2022 13:04:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D99E7C385B3;
        Tue,  3 May 2022 13:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651583077;
        bh=IdSAzMybVRLKN4AFDOTIxWqFez/RALrhrUunMeJzeKE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=CqnpHbyKGE0sKKpZMtH3fXMylGqWPteGkZ9aZrOqXT208NXckFU78g9AC+/VPFy/t
         Qn7jaKdgDOx5QfHpFFf7bc9LXYUa/NPGKgDWKhFfKnwh/f1OtoXnM97TwxpCJ9vKim
         kcUZjrLhXxyY1S8t+a28pimurmNfrbQb/KD+xCNBcwiEGDwBHUVsc9g1+FreX+O2nA
         tKw1MITmoSF/W+iyRrZUM9D1hwkj7IBeQ5fM3oiOh4EQjow0h4MLJuKZ1urApAEHmy
         4/5OU6Ve6HzZmPh5HaAyCV75QfMZLjXk5tZXNm6LkDuNEOhp2bKetoSQifJXcw3DL9
         T/tMvQnfEvJuA==
Received: by mail-pj1-f43.google.com with SMTP id r9so15234422pjo.5;
        Tue, 03 May 2022 06:04:37 -0700 (PDT)
X-Gm-Message-State: AOAM532xz46HDYJ9p/gIAVkc5R1oSIrvi4aivhzH+Ux0ncA/G+19Gxdy
        azuiMyesCY7Ry1Mm9cJm1j5YqNae1MluqeU92g==
X-Google-Smtp-Source: ABdhPJyahR+0DO3NSgFi6ExO8mn7JDDzpO5E6qP01/f5TuYbXi/hLZSVssQ3itrMFpAjw2J/Bw41+w2gNHG+Q0pRbpU=
X-Received: by 2002:a17:902:6a8a:b0:156:8ff6:daf0 with SMTP id
 n10-20020a1709026a8a00b001568ff6daf0mr16347250plk.117.1651583077384; Tue, 03
 May 2022 06:04:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220428114049.1456382-1-michael@walle.cc> <20220428114049.1456382-2-michael@walle.cc>
In-Reply-To: <20220428114049.1456382-2-michael@walle.cc>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Tue, 3 May 2022 08:04:23 -0500
X-Gmail-Original-Message-ID: <CAL_JsqKmgsErk41D8MBsQxLfmk16UYVu8+Z5SkwJ6W-obhtysQ@mail.gmail.com>
Message-ID: <CAL_JsqKmgsErk41D8MBsQxLfmk16UYVu8+Z5SkwJ6W-obhtysQ@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] dt-bindings: net: lan966x: remove PHY reset
To:     Michael Walle <michael@walle.cc>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 28, 2022 at 6:40 AM Michael Walle <michael@walle.cc> wrote:
>
> The PHY reset was intended to be a phandle for a special PHY reset
> driver for the integrated PHYs as well as any external PHYs. It turns
> out, that the culprit is how the reset of the switch device is done.
> In particular, the switch reset also affects other subsystems like
> the GPIO and the SGPIO block and it happens to be the case that the
> reset lines of the external PHYs are connected to a common GPIO line.
> Thus as soon as the switch issues a reset during probe time, all the
> external PHYs will go into reset because all the GPIO lines will
> switch to input and the pull-down on that signal will take effect.
>
> So even if there was a special PHY reset driver, it (1) won't fix
> the root cause of the problem and (2) it won't fix all the other
> consumers of GPIO lines which will also be reset.
>
> It turns out, the Ocelot SoC has the same weird behavior (or the
> lack of a dedicated switch reset) and there the problem is already
> solved and all the bits and pieces are already there and this PHY
> reset property isn't not needed at all.
>
> There are no users of this binding. Just remove it.

Seems there was 1 user:

/builds/robherring/linux-dt/Documentation/devicetree/bindings/net/microchip,lan966x-switch.example.dtb:
switch@e0000000: resets: [[4294967295, 0], [4294967295, 0]] is too
long
 From schema: /builds/robherring/linux-dt/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml
/builds/robherring/linux-dt/Documentation/devicetree/bindings/net/microchip,lan966x-switch.example.dtb:
switch@e0000000: reset-names: ['switch', 'phy'] is too long
 From schema: /builds/robherring/linux-dt/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml

Please fix as this is now failing in linux-next.

Rob
