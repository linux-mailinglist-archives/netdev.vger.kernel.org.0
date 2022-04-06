Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 484D04F5CE1
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 13:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbiDFLng (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 07:43:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231648AbiDFLnT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 07:43:19 -0400
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C83135826C2;
        Wed,  6 Apr 2022 01:29:36 -0700 (PDT)
Received: from mail-wr1-f42.google.com ([209.85.221.42]) by
 mrelayeu.kundenserver.de (mreue009 [213.165.67.97]) with ESMTPSA (Nemesis) id
 1MUGmJ-1nTSAf49gp-00RGcd; Wed, 06 Apr 2022 10:29:35 +0200
Received: by mail-wr1-f42.google.com with SMTP id z1so2052634wrg.4;
        Wed, 06 Apr 2022 01:29:34 -0700 (PDT)
X-Gm-Message-State: AOAM531OqtwpTUOg/EVfV2+UmJYA0dXu/AnjpJjfw+EM4q16jICsyIML
        tf37VFHTca6RTkr9lTjXbOaswI6c/kFG7cPnJtk=
X-Google-Smtp-Source: ABdhPJzqKjimJ4xZnU9IPYt6fad20KHtM3TIsGz7LIfUNSAEh1Re0WD0ken3T+oCqWElZNVdr0ug0qBt3+5Wlumu5QE=
X-Received: by 2002:a05:6000:178c:b0:204:648:b4c4 with SMTP id
 e12-20020a056000178c00b002040648b4c4mr5517385wrg.219.1649233774585; Wed, 06
 Apr 2022 01:29:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220405195755.10817-1-nbd@nbd.name> <20220405195755.10817-5-nbd@nbd.name>
 <d0bffa9a-0ea6-0f59-06b2-7eef3c746de1@linaro.org> <e3ea7381-87e3-99e1-2277-80835ec42f15@nbd.name>
In-Reply-To: <e3ea7381-87e3-99e1-2277-80835ec42f15@nbd.name>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 6 Apr 2022 10:29:18 +0200
X-Gmail-Original-Message-ID: <CAK8P3a1A6QYajv_HTw79HjiJ8CN6YPeKXc_X3ZFD83pdOqVTkQ@mail.gmail.com>
Message-ID: <CAK8P3a1A6QYajv_HTw79HjiJ8CN6YPeKXc_X3ZFD83pdOqVTkQ@mail.gmail.com>
Subject: Re: [PATCH v2 04/14] dt-bindings: arm: mediatek: document WED binding
 for MT7622
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Networking <netdev@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        DTML <devicetree@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC..." 
        <linux-mediatek@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:LqaHr6zQfU63/KWC6IeHSigHnsL9BIJjTNGAo+pOtFMNqkYgWK+
 qUDoplE/Sw83CfpzQULwxHJ1W39zwgAd79ykAa/+fe0ExWXw7ftfen8XLjT7gYwvaNy4BPA
 3KuKZG3aMpEW6CuAyECDaQAnlIA+VuavkpT64DltnENZgd+kr2pa6LnNklCAdqE7hudEIjS
 A9GRnXOMY6UbCs4JsAz6A==
X-UI-Out-Filterresults: notjunk:1;V03:K0:BzheXsG6FwM=:lg/g4Wyl4/RF5LqxEvpfvk
 KKYJWvaS+wvWRZtVArZ/ClXOWia8PVjNVm9si85mcWYixRVc/aRdfzIMpy+tUiYinSaKfjG4+
 hdrDYGeExr9bn1ct26akXZ+DDFtFII4AFZ4m0njrWitiNEwUTV33lDXAaR2FjqOhJnUCbHL2g
 E4E1g/pIi7dF2QUrpUCUUM5Zgco7yTrqoC1Y7NNIWrZjNfRuvR/5zM8mBfRxd+rn+8z9FxDxj
 M934Rd0egAkdXZjNk0EyjvFvgsYVVPG0k1zDuvJ5eXxpWsGUX6uF2abfyRswd161OkVCEXCZA
 QSSEuW/5VAdAOQbyyFkCWQ3oZAzUnerlmSjukdDCbnxQjkOd7ZisOS1ocdvQKMnExWZ+D0rmk
 xdHggtD8TWKFmZDo5UE9hN+slc8mM+2IxIhDdRzsLZjRxSdF11zRfMvoeSuumj9Gpp/il2q3U
 xD/XngG83S1iCDLrV8LkcUt/YQA8OR4CckWCQ13gR3cP5EapDHPKIFmZAdUh1MeGG727aK0iC
 x0Nbwh/avUzfvZFDgI+JQfJ1vWMBCHx686wpb9h7Hms9hUmmf0vEXm2eyt84f5t1q4ftX2P+P
 YGs8tilrlLW2N0ibBxnYY2If4knWoFDohzhE7BG7K2yWgKQ/o7p7HyJ0ZEN8hIGfvnHmF/1CZ
 KK+Dzkf6eBd8zqCK7cpXK4f6iFHU6gaVPL6DBGp7TMXhnZMBCPbP4CprSftVytQ/xvKSFFtQI
 +OVn74Rm2A+faAFh6VQPFV9bFKFak2GydaBuQmSJCCsI0PiW9QxWZcL5XQf86yMLxRFRxEgpt
 cAZ47H5qjCXwXhea4f5I4x5ux1RwZ25ZVpwMz+HbsdsDiEHVG4=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 6, 2022 at 10:18 AM Felix Fietkau <nbd@nbd.name> wrote:
> On 06.04.22 10:09, Krzysztof Kozlowski wrote:
> > On 05/04/2022 21:57, Felix Fietkau wrote:
> >> From: Lorenzo Bianconi <lorenzo@kernel.org>
> >>
> >> Document the binding for the Wireless Ethernet Dispatch core on the MT7622
> >> SoC, which is used for Ethernet->WLAN offloading
> >> Add related info in mediatek-net bindings.
> >>
> >> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> >> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> >
> > Thank you for your patch. There is something to discuss/improve.
> >
> >> ---
> >>  .../arm/mediatek/mediatek,mt7622-wed.yaml     | 50 +++++++++++++++++++
> >>  .../devicetree/bindings/net/mediatek-net.txt  |  2 +
> >>  2 files changed, 52 insertions(+)
> >>  create mode 100644 Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-wed.yaml
> >
> > Don't store drivers in arm directory. See:
> > https://lore.kernel.org/linux-devicetree/YkJa1oLSEP8R4U6y@robh.at.kernel.org/
> >
> > Isn't this a network offload engine? If yes, then probably it should be
> > in "net/".
> It's not a network offload engine by itself. It's a SoC component that
> connects to the offload engine and controls a MTK PCIe WLAN device,
> intercepting interrupts and DMA rings in order to be able to inject
> packets coming in from the offload engine.
> Do you think it still belongs in net, or maybe in soc instead?

I think it belongs into drivers/net/. Presumably this has some kind of
user interface to configure which packets are forwarded? I would not
want to maintain that in a SoC driver as this clearly needs to communicate
with both of the normal network devices in some form.

         Arnd
