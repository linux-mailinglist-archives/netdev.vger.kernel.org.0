Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01FFA1C2014
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 23:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbgEAVxV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 17:53:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726045AbgEAVxV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 17:53:21 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA60DC061A0C;
        Fri,  1 May 2020 14:53:20 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id e2so8589414eje.13;
        Fri, 01 May 2020 14:53:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aU6xJ+iSFx7gADks0AYYV1385t8GYvkG8uv7MDkA/d8=;
        b=bZuN+obOrRVaaAyoc1isLnub49EQILFTo9ue9JKAVyyLXaa8HlcC3dU14wWXgdBYYe
         hw0Q4ZAv0VyT6nzTWi0eJu05p5vWuxEQoc6lzwUVKytcwmFqmxtnY7uObPjBu+YSWgpP
         +YgupdjAvyTotb2rbi2gcBoKKZBJLQxt9Rpw7EbH47oQWKzi286pLlL0kQy9gaJCJihZ
         2jOHqxoNEOK5i2nJde4qZMEGE8/+RUvZG2sDs06GOM01hKmGE5P0iyAD+M6PB19IKjIC
         ia0NF9A7QOTv2sTkzkUFNJOEjMXQQwh370jtD+qmeCamJrxSQfENmu2E+TbCyrHx5Qn9
         frog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aU6xJ+iSFx7gADks0AYYV1385t8GYvkG8uv7MDkA/d8=;
        b=YtnAS4NshaKEZvz8FEurwC60ATBI+FK/ypi/3uKqghKA8CGceGgFNoLdnfRXg23Fmw
         Y2cXSynfYUrdgaqqxASw/1i53cirEBm2jfJb35TuJ/9280dxEMpceLAFNEDQ4oTFt9wC
         sQw8449z5qC2NQb9w9giJbSUJBTqhk70K2owqEcGCkjWtFtElGy62RhJEdmrdxv+eaSd
         Jm4/ju8XB04MzRsVB3jLZd4u5ShdWNz9eaJY8Ze+kUEF1paQMdyiNis2HZuhVl7erMVj
         KVfk3mOD2SsOR0PVJghzCLXjst1zpWHSGWjWB6Qkrgfvijf2XV2YJ2LYw4I1nd5XxPi+
         KOWw==
X-Gm-Message-State: AGi0PuasMnieI3/VPMKtcq1srH+judWm1SG6mup//b814LNbEsdS+H63
        SnSNbI948/uOMBNTkBsHMmWqTBwZiuuhfqaCkq7uVODKhyk=
X-Google-Smtp-Source: APiQypJE6wRFk+W8/TX/hPebgvtvgJCEAM+/GlY3LrmThP8OdxemOb2dFwAO5d/KHVF7CH5V0uzlyXhD8yOdX5Yeq5M=
X-Received: by 2002:a17:906:3004:: with SMTP id 4mr5235939ejz.381.1588369999417;
 Fri, 01 May 2020 14:53:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200429201644.1144546-1-martin.blumenstingl@googlemail.com>
 <20200429201644.1144546-3-martin.blumenstingl@googlemail.com> <20200501210942.GA27082@bogus>
In-Reply-To: <20200501210942.GA27082@bogus>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Fri, 1 May 2020 23:53:08 +0200
Message-ID: <CAFBinCDmps-Nd-HokSa5P7=bR+o3nuwxsS_eiH9A6CCYywpabQ@mail.gmail.com>
Subject: Re: [PATCH RFC v2 02/11] dt-bindings: net: dwmac-meson: Document the
 "timing-adjustment" clock
To:     Rob Herring <robh@kernel.org>
Cc:     robh+dt@kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org,
        jianxin.pan@amlogic.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rob,

On Fri, May 1, 2020 at 11:09 PM Rob Herring <robh@kernel.org> wrote:
>
> On Wed, 29 Apr 2020 22:16:35 +0200, Martin Blumenstingl wrote:
> > The PRG_ETHERNET registers can add an RX delay in RGMII mode. This
> > requires an internal re-timing circuit whose input clock is called
> > "timing adjustment clock". Document this clock input so the clock can be
> > enabled as needed.
> >
> > Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> > ---
> >  .../devicetree/bindings/net/amlogic,meson-dwmac.yaml   | 10 +++++++---
> >  1 file changed, 7 insertions(+), 3 deletions(-)
> >
>
> My bot found errors running 'make dt_binding_check' on your patch:
>
> /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/amlogic,meson-dwmac.example.dt.yaml: ethernet@c9410000: clocks: Additional items are not allowed ([4294967295] was unexpected)
> /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/amlogic,meson-dwmac.example.dt.yaml: ethernet@c9410000: clocks: [[4294967295], [4294967295], [4294967295], [4294967295]] is too long
> /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/amlogic,meson-dwmac.example.dt.yaml: ethernet@c9410000: clocks: Additional items are not allowed ([4294967295] was unexpected)
> /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/amlogic,meson-dwmac.example.dt.yaml: ethernet@c9410000: clocks: [[4294967295], [4294967295], [4294967295], [4294967295]] is too long
I am seeing this on my own build machine as well, but only for the .yaml example
The .dts example does not emit this warning

Also I don't see what's wrong with my way of describing the new,
optional clock and it's clock-name
Can you please point me in the right direction here?


Thank you!
Martin
