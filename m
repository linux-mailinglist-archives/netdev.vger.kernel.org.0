Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B09E1DAE8C
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 11:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbgETJTo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 05:19:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726510AbgETJTo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 05:19:44 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30E5EC061A0F
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 02:19:44 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id k18so2405514ion.0
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 02:19:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=4MtCeXtYJztBAdny7JMpr9tFuQgehgsjdymzaj9y89A=;
        b=gr9GMxtdJnZ4/HGUFlPqG3223EEHFYHgbywWo5fZ7nEcHZ/0L6m/rPRz9EMomdinGX
         gw+4y2Ot7K3hqcXBlicBJGhv59sV6FTdDVXFBbOpizlDxwLs1N1BwdpncaefpyUFWwiT
         2J4oHkfgE9Q7nJ/GxD0HVIozJ54ni07wwhAoUxEzFtI34chD+Iv01o/teHe3Gqw7nvHW
         V2Rks6kPST1qvYf+/zQ49dKrWE79INi0q4sdTLF9TbU36N9xr5znY/VfLju3YaIUC3Zl
         oldzyJFzVLpQtquHM9cyLQrc+K1nX2S9NO+aqt/tmtrmU/a97iKz1e8XIocgiaitIdS7
         UccQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=4MtCeXtYJztBAdny7JMpr9tFuQgehgsjdymzaj9y89A=;
        b=AkdcqARCwMpdFRxBbVLj66/v0gBddrTH2vJG/e6dT2DhA/fop71VtZsRAHNrs2dPqD
         LHJ50tGU28MaIQXQVaaTwl7nZQXCK30g6B7giHgC8B0toN4K9vQICbyDlwG3AU1QUAH+
         5cGgZUwPiQzc1lxTvHkb7m/wRcdHaonG5IsxRFmsuE3glncd66xQwHPmuM4U0QLHlTXz
         0Vp9szPSJk2Qse4GTuWNCyntyyJIqFa+IkJ/jTTGGsHGWdPG3Q4oqeN7FP9yT5sPXNKE
         1NRnG0asHqbU5dFSHTGtFEBjeh49u/+kth6dnlB4aEeRowHtxQ99aruRMbXtiGAs64I0
         WCvw==
X-Gm-Message-State: AOAM532X7U36Ss5+cZA/2NjQtn1PxAGGAiokphwbOG69YeVLJaA70q9q
        LU/7koI9DDSk0cLQqrSH+OWI8sqvY38GU44dx0y9RA==
X-Google-Smtp-Source: ABdhPJxfcMFcRpgMe3jPhIr7dlnaeApgO41HN00hg/DL0f0uo79Shv8ju19FCk5CWaCaCcGPEVG3ppJTh2gjtP/n54o=
X-Received: by 2002:a5d:9e11:: with SMTP id h17mr2551601ioh.119.1589966383474;
 Wed, 20 May 2020 02:19:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200511150759.18766-1-brgl@bgdev.pl> <20200511150759.18766-2-brgl@bgdev.pl>
 <20200519182831.GA418402@bogus>
In-Reply-To: <20200519182831.GA418402@bogus>
From:   Bartosz Golaszewski <brgl@bgdev.pl>
Date:   Wed, 20 May 2020 11:19:32 +0200
Message-ID: <CAMRc=Md6Be41XEu3ZnR1Du_hSMaAcPn4t4Ci9jAOZ1VXz6vbfA@mail.gmail.com>
Subject: Re: [PATCH v2 01/14] dt-bindings: arm: add a binding document for
 MediaTek PERICFG controller
To:     Rob Herring <robh@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Fabien Parent <fparent@baylibre.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Edwin Peer <edwin.peer@broadcom.com>,
        devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC..." 
        <linux-mediatek@lists.infradead.org>,
        Stephane Le Provost <stephane.leprovost@mediatek.com>,
        Pedro Tsai <pedro.tsai@mediatek.com>,
        Andrew Perepech <andrew.perepech@mediatek.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

wt., 19 maj 2020 o 20:28 Rob Herring <robh@kernel.org> napisa=C5=82(a):
>
> On Mon, May 11, 2020 at 05:07:46PM +0200, Bartosz Golaszewski wrote:
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
> Don't need oneOf here.
>
> > +      - items:
> > +        - enum:
> > +          - mediatek,pericfg
>
> Doesn't match the example (which is correct).
>

Hi Rob,

FYI this was superseded by v3 which should now be correct.

Bart
