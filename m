Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACD1BFD09C
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 22:53:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbfKNVxT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 16:53:19 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39740 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726812AbfKNVxT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 16:53:19 -0500
Received: by mail-wm1-f67.google.com with SMTP id t26so8002327wmi.4;
        Thu, 14 Nov 2019 13:53:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AYtxXvV7rq10di0nCWaqkGfMn0fSIV9NDKI+yoF5mf8=;
        b=vEQgq1op9ByoduD0PSXhrq+mTjXh/a9Gtfy2C1k2DUjnz8JbxAvA8+U5GF1tv9Lk6R
         IsJPImJwyCgxRAdHe4sWwbis38qHhz5db7v3BSmaY6CAKtFDRa62ra2hSaAGIgGiYUW4
         H9347pZryUbpiAIYVc3M0czQxk6u/MiKfhH/blYvu99pGd4Tpi1S6SxbK0asz5cyHTOf
         I20Hm3bi6T+H5nEVXNn62VNv6qx63Gvp1PrgZkzxT6DyINgQWfcsT2fDehCfkt2vU/XT
         eIDeZkVHQzXqPmwGvHJoCObgeUQiIXVf8f7JhGT9IMeRA7cvW1WAXaRJF3PiZ3/wqSpd
         C6bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AYtxXvV7rq10di0nCWaqkGfMn0fSIV9NDKI+yoF5mf8=;
        b=V06Z+Knkd3J+KItgXykO3EDPz+UOZ8+dhBuQ+O+hcoyNX/Coyvj8anliIdDlx8V+7V
         PIT2pVEvkjtBcFyhTpFkzdCkEFpiDVN9kmfxQ68YdrgobIujvwW3dmghZeioVMGKDLB1
         b033guN3pdLpInFsvIeGvLNfTmJUMuN9NgL+6HWb7gI4A+1mcRnpE2lo2zfbZxnTi9qq
         S0uQmRKOIhgflWezo/PlEoj9mAYjh/fPyOnDDi9vklc5+FIFGdTwwtBjtW9WcW5mMXgX
         Gjt1Noz0vWZupyfP7TyvVQjRxkdGFXTSCpZWnwMo/J9RcGFOBzxIHA0p7xxWYAHyJba1
         EnTg==
X-Gm-Message-State: APjAAAUdCjOp424vLhQav/AVbz6qMsGPDlc0GEM80xTqpAHWL7ffXM58
        KmV5BMi37rBwnNSsplHvrX6q6B8YhcvbrBg5UXA=
X-Google-Smtp-Source: APXvYqyer25pIwMp04AbL8hennAHCOuUosGk+t1VEFMYAff37A/7WH3EIPa1ZSLfmfuxc9MZc4jsGSnMrgSUVRXVktQ=
X-Received: by 2002:a1c:ed16:: with SMTP id l22mr10462653wmh.151.1573768395760;
 Thu, 14 Nov 2019 13:53:15 -0800 (PST)
MIME-Version: 1.0
References: <20191114110254.32171-1-linux@rasmusvillemoes.dk> <20191114.133959.2299796714037910835.davem@davemloft.net>
In-Reply-To: <20191114.133959.2299796714037910835.davem@davemloft.net>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 14 Nov 2019 23:53:04 +0200
Message-ID: <CA+h21hqXnUE4d777T05y6tcS61B5SvdqSpCti=_0QAgUeEkqLw@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] ARM: dts: ls1021a: define and use external
 interrupt lines
To:     David Miller <davem@davemloft.net>
Cc:     Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Shawn Guo <shawnguo@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Marc Zyngier <maz@kernel.org>, netdev <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Nov 2019 at 23:40, David Miller <davem@davemloft.net> wrote:
>
> From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> Date: Thu, 14 Nov 2019 12:02:51 +0100
>
> > A device tree binding documentation as well as a driver implementing
> > support for the external interrupt lines on the ls1021a has been
> > merged into irqchip-next, so will very likely appear in v5.5. See
> >
> > 87cd38dfd9e6 dt/bindings: Add bindings for Layerscape external irqs
> > 0dcd9f872769 irqchip: Add support for Layerscape external interrupt lines
> >
> > present in next-20191114.
> >
> > These patches simply add the extirq node to the ls1021a.dtsi and make
> > use of it on the LS1021A-TSN board. I hope these can be picked up so
> > they also land in v5.5, so we don't have to wait a full extra release
> > cycle.
> >
> > v2: fix interrupt type in 2/2 (s/IRQ_TYPE_EDGE_FALLING/IRQ_TYPE_LEVEL_LOW/).
>
> I am assuming this will go via an ARM tree.

Yes, of course, they are for Shawn. Netdev and Andrew was copied for
patch 2/2 (an SGMII PHY interrupt).

Regards,
-Vladimir
