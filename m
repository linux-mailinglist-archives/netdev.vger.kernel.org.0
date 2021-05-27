Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71DFE392B00
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 11:44:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235864AbhE0JqN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 05:46:13 -0400
Received: from mail-ua1-f45.google.com ([209.85.222.45]:41570 "EHLO
        mail-ua1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235675AbhE0JqL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 05:46:11 -0400
Received: by mail-ua1-f45.google.com with SMTP id g34so832210uah.8;
        Thu, 27 May 2021 02:44:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xyO91WwRYqo2wMXqgZeeHTqV+3eSTnV/ZWWMMo01lKE=;
        b=ZrNnBYATMgUyUZPJ/kijSLyvp8j4jJE4H2GpG1+0QHySWSAg+Qiy6orVjRExt+DRtF
         2xLxsd0oyT8bf8fFHHORm0kMnisJawQRKfZSjCpWO0s2uA0tpWWxZDuIh/Z0SqX3bP1b
         XvmE/woTMa+uQSgSd0cIRFqNrKfCiUiuQZ1tLZrFccLP6dv6BEpQvGXLdLo3PjaTuSQu
         XlHWVAWmBsJNNLktE1oTjOgggxnanzHyUnS7+VTXfcngImgxfaljYP/yOGM5QXIhsM2Q
         +nbodyM6uiDce+ZomhVDNm/X1dltCzqRl/KriRGQ3prtlhxKxyaWApdekP9gdzuw2ESF
         lLTA==
X-Gm-Message-State: AOAM530j42ej/cFHHZj2iJ5HAd50Pz5qdCJSLfZZMwC+jsKB7JK71oUs
        QTi5AGQ6nAjOSSFoP6diodcVeWZGuVSqVq9FnmGqQ+0M
X-Google-Smtp-Source: ABdhPJxm04ulbfNwcj1J1dC242uqkUkgB3I1fmf2xJPxaK+VsPn+SlpCJ5YiUalQQXQPXVe94B31n4eYZnyyCgmzn+Q=
X-Received: by 2002:a1f:a388:: with SMTP id m130mr1257979vke.1.1622108678468;
 Thu, 27 May 2021 02:44:38 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1621518686.git.geert+renesas@glider.be> <b708fdb009912cf247ef257dce519c52889688d8.1621518686.git.geert+renesas@glider.be>
 <20210520150742.GB22843@alpha.franken.de>
In-Reply-To: <20210520150742.GB22843@alpha.franken.de>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 27 May 2021 11:44:27 +0200
Message-ID: <CAMuHMdXtn9e9mvRP63GYXuGG7Gfwxoc8bmGrBwfV2UOPizD6Qw@mail.gmail.com>
Subject: Re: [PATCH 4/5] MIPS: SEAD3: Correct Ethernet node name
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     Rob Herring <robh+dt@kernel.org>, Shawn Guo <shawnguo@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "open list:BROADCOM NVRAM DRIVER" <linux-mips@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Thomas,

On Thu, May 20, 2021 at 5:08 PM Thomas Bogendoerfer
<tsbogend@alpha.franken.de> wrote:
> On Thu, May 20, 2021 at 03:58:38PM +0200, Geert Uytterhoeven wrote:
> > make dtbs_check:
> >
> >     eth@1f010000: $nodename:0: 'eth@1f010000' does not match '^ethernet(@.*)?$'
> >
> > Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> > ---
> >  arch/mips/boot/dts/mti/sead3.dts | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
>
> Acked-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

Can you please take this through the MIPS tree?
Thanks!

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
