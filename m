Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33D955A027B
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 22:09:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239400AbiHXUJh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 16:09:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbiHXUJf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 16:09:35 -0400
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AD6D7C192;
        Wed, 24 Aug 2022 13:09:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1661371731; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=XgjFwLYa7IBedppKBr0lLTdnZbp/TPpl8VwTvpe3PsAd2sv2DCzAKEd2AJax31Iex4F+WMiZSX/uz7zNE0HzIjRe7nDzgtVaiH+hgPJ3xBVogMm6HtxcOtHjGeTDFoYAfKVhWey6zTW/YOrQCDXkwFUdKB7gJJ1is3fppqo6j64=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1661371731; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=bS9tansBU/mS+uLByVfBLtD82ZsrEu9pPMJgjJjQdUo=; 
        b=EWN66Zd8S+jZ5y7vztJxZeCtA29ChJ/tOAlmPXK54B4Y/1QkcPM5OKa1Qg8SS2t+Uqa5AhJxfVdE9a1I7praE9cEVLeug9dGPDOd/Exl7uRPTNiIgWN6gR7nZrHq9XNNDveHSkgaJ56/LyxmKZwrwEv1+pm4cThZq56agEvqHrE=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1661371731;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Content-Type:Content-Transfer-Encoding:From:From:Mime-Version:Subject:Subject:Date:Date:Message-Id:Message-Id:References:Cc:Cc:In-Reply-To:To:To:Reply-To;
        bh=bS9tansBU/mS+uLByVfBLtD82ZsrEu9pPMJgjJjQdUo=;
        b=kKccrKLa1Q2FHhRwlP7KyOqdNW0H1uLfj8lhqPnSd5Kw98/4245wTO6nTScl1MgQ
        G9iZ4KVCDJuqvg56uFxLLT+XwhQAcLgoevgWvyDDPboILR05sO1RahksjUmudfm2XOT
        +uk9gjIoZqjAaxzgndtgoop402w6i9kWx1FJy2BE=
Received: from [10.10.10.4] (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1661371729628874.3633283035331; Wed, 24 Aug 2022 13:08:49 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   =?utf-8?Q?Ar=C4=B1n=C3=A7_=C3=9CNAL?= <arinc.unal@arinc9.com>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v5 1/7] dt-bindings: net: dsa: mediatek,mt7530: make trivial changes
Date:   Wed, 24 Aug 2022 23:08:40 +0300
Message-Id: <C36EB263-8C1E-414C-B7FF-E6359AA6031A@arinc9.com>
References: <20220824194454.GA2768100-robh@kernel.org>
Cc:     Matthias Brugger <matthias.bgg@gmail.com>,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, DENG Qingfang <dqfext@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sander Vanheule <sander@svanheule.net>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Rob Herring <robh+dt@kernel.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        devicetree@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>, erkin.bozoglu@xeront.com
In-Reply-To: <20220824194454.GA2768100-robh@kernel.org>
To:     Rob Herring <robh@kernel.org>
X-Mailer: iPhone Mail (17H35)
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On 24 Aug 2022, at 22:44, Rob Herring <robh@kernel.org> wrote:
>=20
> =EF=BB=BFOn Wed, 24 Aug 2022 13:40:34 +0300, Ar=C4=B1n=C3=A7 =C3=9CNAL wro=
te:
>> Make trivial changes on the binding.
>>=20
>> - Update title to include MT7531 switch.
>> - Add me as a maintainer. List maintainers in alphabetical order by first=

>> name.
>> - Add description to compatible strings.
>> - Stretch descriptions up to the 80 character limit.
>> - Remove lists for single items.
>> - Remove quotes from $ref: "dsa.yaml#".
>>=20
>> Signed-off-by: Ar=C4=B1n=C3=A7 =C3=9CNAL <arinc.unal@arinc9.com>
>> ---
>> .../bindings/net/dsa/mediatek,mt7530.yaml     | 39 +++++++++++--------
>> 1 file changed, 23 insertions(+), 16 deletions(-)
>>=20
>=20
>=20
> Please add Acked-by/Reviewed-by tags when posting new versions. However,
> there's no need to repost patches *only* to add the tags. The upstream
> maintainer will do that for acks received on the version they apply.
>=20
> If a tag was not added on purpose, please state why and what changed.

Thanks for the info. This is what I did on the composition for this patch se=
ries.

Ar=C4=B1n=C3=A7

