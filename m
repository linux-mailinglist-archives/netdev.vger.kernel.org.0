Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 655AE5B8429
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 11:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231222AbiINJH7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 05:07:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231209AbiINJGo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 05:06:44 -0400
Received: from mail-oa1-x31.google.com (mail-oa1-x31.google.com [IPv6:2001:4860:4864:20::31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC14E77540;
        Wed, 14 Sep 2022 02:03:45 -0700 (PDT)
Received: by mail-oa1-x31.google.com with SMTP id 586e51a60fabf-12b542cb1d3so29443603fac.13;
        Wed, 14 Sep 2022 02:03:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=D+SZ90LOGKr6PSOG3NHenig+A+JoVupnzjOX8oY/5mM=;
        b=nExX2H2C6WrTnNGSpxdkS/T1FL5M+Sr7vDYZT64HVjqQ5M/Pa7eAR4by6hMu0qfyxJ
         3qbx21WcZf9gvJ23WYaYT5830WSHS9I0fxKg5PWV043q44CqnXwRpghkSNe3CAkC/uqg
         JPNtPeZPgYSXBQ7jaLQMuYgYFWkLBrzEBMKeRSjk84LrI9NFp8PEgHV3rrvI5gEoAegf
         f0oQrUcSA3nLHzjEbTP2bLpRjk3SI89VDDLBFyZfxUCyDyebpuKlXPAIT+G/kgKm4CcM
         Wx3w7v7TzkDjxerXa+Q1jnVQXJueeoxUDhwHa49rCdpFkjQAs1c6QaIyJ738DjN9kXJM
         8TQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=D+SZ90LOGKr6PSOG3NHenig+A+JoVupnzjOX8oY/5mM=;
        b=mS2ni3e0ADsFiF1qCeBITsk7T8O8LmLeE91HIMJy19qDftYRJFvwM2dy/t6oT+B6yi
         f7Htf5q7tcGNsxRJUGOz/K8zQmjphWgNJnQ3jOXpGz/tP69LfQX8EgUl4KSRCJtAplc0
         HoseSD7WQOoylt+wR7eXB79RUEDz+tNXAFCPVVcHYfyLkhHqSZJ569gbIRa2/AYRRpds
         bCij+EtBiybsKXXqm+DVZdRpCdMEHozWFnv75d+Hpj8fNTuJz1oLWg00IKRA0sDvJKrf
         zMInELL+E2TEvGfcEypT+flN4wzIk6pkfcqrrUvSINfXQayZdy5HP3RUhiEWNacDn/fu
         LpXg==
X-Gm-Message-State: ACgBeo0EjWnu/dm5J0Fju19ojj3p57mh3j0FuhXGog2xSFp3D+QJMDvR
        HA2ReI4Fn4LirnlHPvlmsaBEoESWmY+9efg7Twg=
X-Google-Smtp-Source: AA6agR6ka3E1cNjL/pn5j8TiAFXOCTm4ghY2UhrM1mmRzKbdO8p0jFiJ1HzoekaKmYo3JI4vfIcTz0ZDPjt6wYynFCE=
X-Received: by 2002:a05:6808:bcb:b0:345:aa85:6f33 with SMTP id
 o11-20020a0568080bcb00b00345aa856f33mr1451152oik.83.1663146214114; Wed, 14
 Sep 2022 02:03:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220914085451.11723-1-arinc.unal@arinc9.com> <20220914085451.11723-5-arinc.unal@arinc9.com>
In-Reply-To: <20220914085451.11723-5-arinc.unal@arinc9.com>
From:   Sergio Paracuellos <sergio.paracuellos@gmail.com>
Date:   Wed, 14 Sep 2022 11:03:23 +0200
Message-ID: <CAMhs-H8MohXO6xNf+vNodv9hDyCog5_Hjcb6_=_ujmYmmeEdSg@mail.gmail.com>
Subject: Re: [PATCH 04/10] dt-bindings: memory: mt7621: add syscon as
 compatible string
To:     =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, erkin.bozoglu@xeront.com,
        netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, linux-arm-kernel@lists.infradead.org,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "open list:MIPS" <linux-mips@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 14, 2022 at 10:55 AM Ar=C4=B1n=C3=A7 =C3=9CNAL <arinc.unal@arin=
c9.com> wrote:
>
> Add syscon as a constant string on the compatible property as it's requir=
ed
> for the SoC to work. Update the example accordingly.
>
> Fixes: 5278e4a181ff ("dt-bindings: memory: add binding for Mediatek's MT7=
621 SDRAM memory controller")
> Signed-off-by: Ar=C4=B1n=C3=A7 =C3=9CNAL <arinc.unal@arinc9.com>
> ---
>  .../bindings/memory-controllers/mediatek,mt7621-memc.yaml   | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)

Acked-by: Sergio Paracuellos <sergio.paracuellos@gmail.com>

Thanks,
    Sergio Paracuellos
