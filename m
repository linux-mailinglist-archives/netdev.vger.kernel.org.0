Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 951F01D0A85
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 10:09:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729587AbgEMIJu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 04:09:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726092AbgEMIJt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 04:09:49 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2478C061A0F
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 01:09:49 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id s10so17066697iog.7
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 01:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9UilNQk9S4BvXv27MvSXEo2VXDVsyD3FnEfjySXek3Q=;
        b=I333cevq/ZiYLBB2UEqQvcKtAGvuyLJZxdyLz+dw9rtzdUG3Rn5bsG6b+cpl7WJ7be
         gTKIH/JsA1vPwstSt1K87Da84h3nS6SdQlUWK+QTnSAYwi+CjJ/aL+J8zawKW++FhJMQ
         aAWwxITol5cIJWKXZHPmGp5Bv26XE5m8HS8GVMXZPkz9eAufEiFF137yzG71eVK31Y0h
         GRCKTv29IzTe96QDVL3EExYOvg7/+4BsAH4/rwxaCg0aboPZ4fdHNA+ZSezFo4H59XIF
         6YgL3Ztsxu7NdaF62XFuH+8rQKy6pIHash3BieKanuFtjzs07HWpQii/lNhRuYgekHNs
         jZ6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9UilNQk9S4BvXv27MvSXEo2VXDVsyD3FnEfjySXek3Q=;
        b=qyaoSketU9wha4zem9MHD6XuqBg1LNxVRsdThITVG/ngErrLfNPa0gITQnmHqFh72E
         zs5z2trfjm8Xo7I43Cx2AMg9Usmsdc6rJ/IHxpmOqynI8wTKfTrXwh8YyRYACX71MAgo
         8swJNyDFdQzQLUnpj5WZVFbqjxwhIof7s8YHd08zmCcLY2zwUy0Ve7ZmRLvB8j1qllbe
         1mhiG0sycNhAGqBi4hwRvCOS0c/gHtibEIzrLJGCaUklK2Sq/ymbTPwbjroRSqNnBkPN
         ZF0gIty+5HiISBshYU0Ukux/utZHgjIni3nWbLmD+HhjL4cVmQ87A7t7RuC/FoMuPYMX
         IpoA==
X-Gm-Message-State: AGi0PuY6mhFqQCgWgdG4w3zT2dAzmthc92XxtElNFvH9KB25uNgb/GLj
        pm0mPZMX3NKLFuyczhMxr/Wx/af7AEUNr6qRKgd3tw==
X-Google-Smtp-Source: APiQypLSKZpPbpZGWbIa6OCLB4vXnavWGW3O9jfduY7qGPjrWI211lZ+fRr7Evkrpn1Sok32KOFfgRA0O4qxfjO7Hmw=
X-Received: by 2002:a05:6602:2dd4:: with SMTP id l20mr1335649iow.13.1589357388989;
 Wed, 13 May 2020 01:09:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200505140231.16600-1-brgl@bgdev.pl> <20200505140231.16600-2-brgl@bgdev.pl>
 <20200513023855.GA23714@bogus>
In-Reply-To: <20200513023855.GA23714@bogus>
From:   Bartosz Golaszewski <brgl@bgdev.pl>
Date:   Wed, 13 May 2020 10:09:38 +0200
Message-ID: <CAMRc=MfScMKPMNeFAMA=6ObhFkU8T=8a+dVyiUyvGOXyBG8H=g@mail.gmail.com>
Subject: Re: [PATCH 01/11] dt-bindings: add a binding document for MediaTek
 PERICFG controller
To:     Rob Herring <robh@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Felix Fietkau <nbd@openwrt.org>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Fabien Parent <fparent@baylibre.com>,
        devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-mediatek@lists.infradead.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=C5=9Br., 13 maj 2020 o 04:38 Rob Herring <robh@kernel.org> napisa=C5=82(a)=
:
>
> On Tue, May 05, 2020 at 04:02:21PM +0200, Bartosz Golaszewski wrote:
> > From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> >
> > This adds a binding document for the PERICFG controller present on
> > MediaTek SoCs. For now the only variant supported is 'mt8516-pericfg'.
> >
> > Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> > ---
> >  .../arm/mediatek/mediatek,pericfg.yaml        | 34 +++++++++++++++++++
> >  1 file changed, 34 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/arm/mediatek/medi=
atek,pericfg.yaml
> >
> > diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,pe=
ricfg.yaml b/Documentation/devicetree/bindings/arm/mediatek/mediatek,pericf=
g.yaml
> > new file mode 100644
> > index 000000000000..74b2a6173ffb
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,pericfg.y=
aml
> > @@ -0,0 +1,34 @@
> > +# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
> > +%YAML 1.2
> > +---
> > +$id: "http://devicetree.org/schemas/arm/mediatek/mediatek,pericfg.yaml=
#"
> > +$schema: "http://devicetree.org/meta-schemas/core.yaml#"
> > +
> > +title: MediaTek Peripheral Configuration Controller
> > +
> > +maintainers:
> > +  - Bartosz Golaszewski <bgolaszewski@baylibre.com>
> > +
> > +properties:
> > +  compatible:
> > +    oneOf:
>
> Don't need oneOf.
>
> > +      - items:
> > +        - enum:
> > +          - mediatek,pericfg
>
> PERICFG is exactly the same register set and functions on all Mediatek
> SoCs? Needs to be more specific.
>
> > +        - const: syscon
> > +
> > +  reg:
> > +    maxItems: 1
> > +
> > +required:
> > +  - compatible
> > +  - reg
> > +
> > +additionalProperties: false
> > +
> > +examples:
> > +  - |
> > +    pericfg: pericfg@10003050 {
> > +        compatible =3D "mediatek,mt8516-pericfg", "syscon";
> > +        reg =3D <0 0x10003050 0 0x1000>;
>
> Default for examples is 1 cell for addr and size.
>
> > +    };
> > --
> > 2.25.0
> >

Hi Rob,

I somehow missed the fact that there already is an old-style txt
binding document for pericfg. I'll first convert it and then add the
new compatible.

Bart
