Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB062ADCC5
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 18:20:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730660AbgKJRUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 12:20:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:43840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730468AbgKJRUp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 12:20:45 -0500
Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64CD4207D3;
        Tue, 10 Nov 2020 17:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605028844;
        bh=CCTnDCAuuzm6mDIFcu8KCQsuUDMrKrxDKK90okxS4fk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Vr0EYzw3G94OIGuCW5pc5gp1CS6c8tExs5si/3znnJA8VirbiEzX7PVpZJR9FP0me
         6te5OHu0md9FgCMdhGD8Ia7VTUDYBcvSMkW7ykIhwvYwW6DNMIxS2hSme8xiPvIzeY
         h8Ft6t25keqfxhMIv34lD+CzZeyFrXpwLjrutDUg=
Received: by mail-ot1-f43.google.com with SMTP id a15so11543775otf.5;
        Tue, 10 Nov 2020 09:20:44 -0800 (PST)
X-Gm-Message-State: AOAM530i/qsvWIpUebCUdfB8d3AK05MvtBJl+uyvgyqwsv1CUbjPtSaP
        vQGBSzojVgfp8xkG+Jpw9Py3Xi18breqjklZLA==
X-Google-Smtp-Source: ABdhPJxTW1zyuuGU0nYnE6jokSTkRx0L3GaMfd1E8nJiIRwJDoTnjiX+oRJAcTo4UeF55RMhc+xmv2NCRRQ3bMrB4kg=
X-Received: by 2002:a9d:5e14:: with SMTP id d20mr13751749oti.107.1605028843571;
 Tue, 10 Nov 2020 09:20:43 -0800 (PST)
MIME-Version: 1.0
References: <20201109104635.21116-1-laurentiu.tudor@nxp.com>
 <20201109104635.21116-2-laurentiu.tudor@nxp.com> <20201109221123.GA1846668@bogus>
In-Reply-To: <20201109221123.GA1846668@bogus>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Tue, 10 Nov 2020 11:20:32 -0600
X-Gmail-Original-Message-ID: <CAL_JsqJ2Ew6GdQmE0gcTgFX9cMZKtkL_rO1F+0EMNy88wF+gXw@mail.gmail.com>
Message-ID: <CAL_JsqJ2Ew6GdQmE0gcTgFX9cMZKtkL_rO1F+0EMNy88wF+gXw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] dt-bindings: misc: convert fsl, qoriq-mc from txt
 to YAML
To:     Laurentiu Tudor <laurentiu.tudor@nxp.com>
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Yang-Leo Li <leoyang.li@nxp.com>,
        David Miller <davem@davemloft.net>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        devicetree@vger.kernel.org,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Ionut-robert Aron <ionut-robert.aron@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 9, 2020 at 4:11 PM Rob Herring <robh@kernel.org> wrote:
>
> On Mon, 09 Nov 2020 12:46:35 +0200, Laurentiu Tudor wrote:
> > From: Ionut-robert Aron <ionut-robert.aron@nxp.com>
> >
> > Convert fsl,qoriq-mc to YAML in order to automate the verification
> > process of dts files. In addition, update MAINTAINERS accordingly
> > and, while at it, add some missing files.
> >
> > Signed-off-by: Ionut-robert Aron <ionut-robert.aron@nxp.com>
> > [laurentiu.tudor@nxp.com: update MINTAINERS, updates & fixes in schema]
> > Signed-off-by: Laurentiu Tudor <laurentiu.tudor@nxp.com>
> > ---
> > Changes in v2:
> >  - fixed errors reported by yamllint
> >  - dropped multiple unnecessary quotes
> >  - used schema instead of text in description
> >  - added constraints on dpmac reg property
> >
> >  .../devicetree/bindings/misc/fsl,qoriq-mc.txt | 196 ----------------
> >  .../bindings/misc/fsl,qoriq-mc.yaml           | 210 ++++++++++++++++++
> >  .../ethernet/freescale/dpaa2/overview.rst     |   5 +-
> >  MAINTAINERS                                   |   4 +-
> >  4 files changed, 217 insertions(+), 198 deletions(-)
> >  delete mode 100644 Documentation/devicetree/bindings/misc/fsl,qoriq-mc.txt
> >  create mode 100644 Documentation/devicetree/bindings/misc/fsl,qoriq-mc.yaml
> >
>
> Applied, thanks!

And now dropped. This duplicates what's in commit 0dbcd4991719
("dt-bindings: net: add the DPAA2 MAC DTS definition") and has
warnings from it:

/builds/robherring/linux-dt-bindings/Documentation/devicetree/bindings/misc/fsl,qoriq-mc.example.dt.yaml:
dpmac@1: $nodename:0: 'dpmac@1' does not match '^ethernet(@.*)?$'
 From schema: /builds/robherring/linux-dt-bindings/Documentation/devicetree/bindings/net/fsl,qoriq-mc-dpmac.yaml

Rob
