Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C30FB2B71D0
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 23:51:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729238AbgKQWup (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 17:50:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726182AbgKQWuo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 17:50:44 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23C7AC0613CF;
        Tue, 17 Nov 2020 14:50:44 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id a15so24252943edy.1;
        Tue, 17 Nov 2020 14:50:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wVFMj1y28y9lr6i3Dua9IiKKVDRLL249TgbSSA9JSCo=;
        b=REHKISixART/wrV+ZOVp3ijOYlxb3WgEeV1AGG0ndKx8Vp1KielOgtykVIScLLiILW
         eHQvntNLmDdkKqNHFQ5t/zDYDKnPV02kl9WeYKzCODIjQtae5+aRQrjaAtkIAuc/CAao
         mXcqjOJm8nM++k8Rf4hg6TsSVCjS06iPMVx2yu08U7AXFKeYJyTAcXOj0cgxT+lhPH+S
         foZbO7ZAshb9uO3lzqd9D6FLjzkzFEILKOY+Uz67HmR6eFZIiPGnboNtNNzALtm3Ffky
         pQbsdK56pX2bw0ZDHDhauYB1EJ5+aPw5bWE1sdFw4TD1TuNbWDQgjx/AtW536hK+IIx8
         Yo2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wVFMj1y28y9lr6i3Dua9IiKKVDRLL249TgbSSA9JSCo=;
        b=nW7DOnCpIgv1HJxHOYVKDTto2KQhZujepKwnctQIsL4ljhQwmr/OqYAPsivbfo1kgF
         TpoT3j/UhvnyVHaAb9paRirhDzdwdo9Vva1KA+BZrs43gPB6+L1l5JmAvCpndAv1I3f+
         AzR6EYPBspnOmFtxBT93b5kKH2cvH0jx1pcLRTThYuovCPUOPF648RNZ2k5Jz2SQkHEO
         pH+4IkJKGZtzaKC9seerxBlqcwmJ3qKW/pf9Ha/w7RSAmPM83O8RON+cSL34IssTnza4
         avNrf6wFAPzOr+et3Bapzlf9XHSH0sd0YIC+BM9D3c0CiqmJ7YCfS+y3Rllx/cfXpm0y
         nH2A==
X-Gm-Message-State: AOAM532F+GXuH/nMOvvw8Piu/DzVU4e/f/wAtTl7OX0VmNtC2T3bbXdr
        wtUymlojVPcsm4mzpsiXMFa/xLXHda7iHSxYEGg=
X-Google-Smtp-Source: ABdhPJwxnZw7fIrQBMEeIJ22JQkOmnYSBJCCB1bD2WqJ0lVQ2RE3nYgJiV9dfPiwS1OUR85WGbfkhGf+bUYog4KweqA=
X-Received: by 2002:a05:6402:3d9:: with SMTP id t25mr23308333edw.338.1605653442816;
 Tue, 17 Nov 2020 14:50:42 -0800 (PST)
MIME-Version: 1.0
References: <20201115185210.573739-1-martin.blumenstingl@googlemail.com>
 <20201115185210.573739-4-martin.blumenstingl@googlemail.com> <88c043ba-e7a4-6b4d-f93f-efdf6c525e95@gmail.com>
In-Reply-To: <88c043ba-e7a4-6b4d-f93f-efdf6c525e95@gmail.com>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Tue, 17 Nov 2020 23:50:31 +0100
Message-ID: <CAFBinCDM=COSpZLSaqqDwpk48QC-sjASwD9O3VJU_SRgB_H_1A@mail.gmail.com>
Subject: Re: [PATCH RFC v2 3/5] net: stmmac: dwmac-meson8b: use picoseconds
 for the RGMII RX delay
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org,
        robh+dt@kernel.org, netdev@vger.kernel.org,
        jianxin.pan@amlogic.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, khilman@baylibre.com,
        Neil Armstrong <narmstrong@baylibre.com>, jbrunet@baylibre.com,
        andrew@lunn.ch
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

On Tue, Nov 17, 2020 at 7:36 PM Florian Fainelli <f.fainelli@gmail.com> wrote:
>
> On 11/15/20 10:52 AM, Martin Blumenstingl wrote:
> > Amlogic Meson G12A, G12B and SM1 SoCs have a more advanced RGMII RX
> > delay register which allows picoseconds precision. Parse the new
> > "amlogic,rgmii-rx-delay-ps" property or fall back to the old
> > "amlogic,rx-delay-ns".
> >
> > Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
first of all: thanks for reviewing this (and the rest of the series)!

> Maybe also issue a warning when the 'amlogic,rx-delay-ns' property is
> found in addition to the 'amlogic,rgmii-rx-delay-ps'? Up to you how to
> manage existing DTBs being deployed.
none of the upstream DTBs uses amlogic,rx-delay-ns - and I am also not
aware of anything being in use "downstream".
I will add a sentence to the commit description when I re-send this
without RFC, something along those lines: "No upstream DTB uses the
old amlogic,rx-delay-ns (yet). Only include minimalistic logic to fall
back to the old property, without any special validation (for example:
old and new property are given at the same time)"

What do you think?


Best regards,
Martin
