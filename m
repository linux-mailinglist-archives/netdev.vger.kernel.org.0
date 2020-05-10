Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53CB61CCE94
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 00:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729466AbgEJWe4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 18:34:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729270AbgEJWe4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 May 2020 18:34:56 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6A97C061A0C;
        Sun, 10 May 2020 15:34:55 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id g16so6327033eds.1;
        Sun, 10 May 2020 15:34:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=B3Liuw5jPj3QJFxFHfKfy7ZMc74PTLZnt3p5YASlDKM=;
        b=SdcvbjcF3JdGMCmXQKjJC4VrtNbyZL7JnFCg8ME3uRhjoiXwEB15CrSZnQME4J2DD2
         DxO4QSlh81F3TWn9aryJtCbHpShD922IGnJbIUvodcpjRjZLGr+jYf2kaVsme2IXDLbY
         4rDOHXaVnxiGBT4BqaQ8kI/nbf5iEGKYqTLSMz9cVTfRW+HNuhVcado+L3P1sCjh8SB5
         rMEASJykb5AlP1LYw0dBugwJWhrgwISrTmI+VLnQC02LFbbzw4WoeRl2c3TUDuWrEqJJ
         1dRey1jKhuUMz+aWUWNgJbUMfAtTbiJvPvHBorrsnrosXO1eItyzVsBZo99mbhd15P+C
         pjzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=B3Liuw5jPj3QJFxFHfKfy7ZMc74PTLZnt3p5YASlDKM=;
        b=ljX5q4qh/yih1Cb4Q6sw7LdvWuhRUrxj8l7yc5ofA4EEHe3sav9tnD9nxvCq3SMJbP
         LzUw8Djs9us96lVlSZFP+asp/oJfMPAdDX0mkhhxXDvOBnwlZ8bDF0S9jN561Xy3kc84
         cvYBIZFBsNLoP4y8FQKhX8x2DfZnB98A1U/XlbCBRnFc9+HxXI9U7P7MaH9qQD4FQ3sL
         lcDlb0Y8+vh9uR4VfK7IGwNniQgdFgF/nl7/Vzo9QDtwP/yVg8K+V7ibAj3sstrI3Rl5
         SkUonmChdIjpZWy8SEM6h6XmOtUO3IqBIyfwIzIbPCgBoQQLIxq/g9mAnsam4m7Ev6si
         OyFw==
X-Gm-Message-State: AGi0PuasnAEaJNmkcsehYIBM+lKrwLcS+mqQ5u2QY1sjY2L5UNGUl0fe
        u+PJcrKVPhvt8hCO4hNG1iYLSj6otlQNddjo6W1DueXD
X-Google-Smtp-Source: APiQypJ0tOvAq/50pHoDwoV21V2Mrg8Ij7Mm0ejwS/L8ZfwzanfGxs+5RSeqRK/m+QrXGsgES5F7n8SL3G6ccbzOAtg=
X-Received: by 2002:a50:fc06:: with SMTP id i6mr10603747edr.110.1589150094277;
 Sun, 10 May 2020 15:34:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200429201644.1144546-1-martin.blumenstingl@googlemail.com>
 <20200429201644.1144546-3-martin.blumenstingl@googlemail.com>
 <20200501210942.GA27082@bogus> <CAFBinCDmps-Nd-HokSa5P7=bR+o3nuwxsS_eiH9A6CCYywpabQ@mail.gmail.com>
In-Reply-To: <CAFBinCDmps-Nd-HokSa5P7=bR+o3nuwxsS_eiH9A6CCYywpabQ@mail.gmail.com>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Mon, 11 May 2020 00:34:43 +0200
Message-ID: <CAFBinCDiQ3_ti60tQd3PMVM89oaMQcSKODMQ1Wr66P1SHWEZ5A@mail.gmail.com>
Subject: Re: [PATCH RFC v2 02/11] dt-bindings: net: dwmac-meson: Document the
 "timing-adjustment" clock
To:     Rob Herring <robh@kernel.org>, robh+dt@kernel.org,
        devicetree@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com,
        linux-amlogic@lists.infradead.org, jianxin.pan@amlogic.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Rob,

On Fri, May 1, 2020 at 11:53 PM Martin Blumenstingl
<martin.blumenstingl@googlemail.com> wrote:
>
> Hi Rob,
>
> On Fri, May 1, 2020 at 11:09 PM Rob Herring <robh@kernel.org> wrote:
> >
> > On Wed, 29 Apr 2020 22:16:35 +0200, Martin Blumenstingl wrote:
> > > The PRG_ETHERNET registers can add an RX delay in RGMII mode. This
> > > requires an internal re-timing circuit whose input clock is called
> > > "timing adjustment clock". Document this clock input so the clock can be
> > > enabled as needed.
> > >
> > > Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> > > ---
> > >  .../devicetree/bindings/net/amlogic,meson-dwmac.yaml   | 10 +++++++---
> > >  1 file changed, 7 insertions(+), 3 deletions(-)
> > >
> >
> > My bot found errors running 'make dt_binding_check' on your patch:
> >
> > /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/amlogic,meson-dwmac.example.dt.yaml: ethernet@c9410000: clocks: Additional items are not allowed ([4294967295] was unexpected)
> > /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/amlogic,meson-dwmac.example.dt.yaml: ethernet@c9410000: clocks: [[4294967295], [4294967295], [4294967295], [4294967295]] is too long
> > /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/amlogic,meson-dwmac.example.dt.yaml: ethernet@c9410000: clocks: Additional items are not allowed ([4294967295] was unexpected)
> > /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/amlogic,meson-dwmac.example.dt.yaml: ethernet@c9410000: clocks: [[4294967295], [4294967295], [4294967295], [4294967295]] is too long
> I am seeing this on my own build machine as well, but only for the .yaml example
> The .dts example does not emit this warning
I found out what's going on here:
- I built these patches against the net-next tree (including dt_binding_check)
- and against linux-next (also including dt_binding_check)

Your tree contains commit f22531438ff42c ("dt-bindings: net: dwmac:
increase 'maxItems' for 'clocks', 'clock-names' properties") [0].
The net-next tree doesn't have that commit but linux-next does.
So when I run dt_binding_check with this series applied on top of
linux-next all warnings/errors are gone.
However when I run dt_binding_check with this series applied on top of
net-next I get the same errors as you.
The reason is that the additional patch in your tree increases the
maximum number of clocks from three to five. With this patch the
Amlogic DWMAC glue needs (up to) four clock inputs.

I have to re-send this series anyways due to a bug in another patch.
Please let me know how to make your bot happy when when I re-send the patches.


Thank you!
Martin


[0] https://git.kernel.org/pub/scm/linux/kernel/git/robh/linux.git/commit/?h=dt/next&id=f22531438ff42ce568f81e346428461c71dea9e2
