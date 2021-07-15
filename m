Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3328D3C9D36
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 12:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238274AbhGOKux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 06:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234463AbhGOKux (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 06:50:53 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60186C06175F;
        Thu, 15 Jul 2021 03:47:59 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id u11so6083410oiv.1;
        Thu, 15 Jul 2021 03:47:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3NyXpXRKjtF+eoBi9AYOFh14nRSx/CxFB77Rn5t87IM=;
        b=Jeo4Lj3HUoqZnyLNGyYN7IHXohg0b/Znf7iz5+lc/yxKRpDDiw0NJRgr134dnydbNu
         RU2tPfr159eBw9c0Rv1wuG2gWHQM2691N/a6buiaK4OyK0nA+TO1aH4jwNwZUtYClMwS
         UYTxvVc1tmHO909M99WmP0FVsuuzBTDjSSpZla+vzrho3jol/Wx6/FV/WxH8w7aAZXYf
         ucW23/8nphTrnTIG7Mgtsuagj3k3MoKCY2vndueaeKBtiTqxUunk0cREDGw43+SQhBjc
         eZxcoTfUW+xxhBN3vXXU/U+AiK4oNLosr598cRx6/WD8HjauLvmhLqmAG/CG34PHbZD9
         KbPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3NyXpXRKjtF+eoBi9AYOFh14nRSx/CxFB77Rn5t87IM=;
        b=qs46dxKcbAEg1bxj6110ce+aMinJKZ/WzNKTUvj8RAbAwUaZ+GDBihvhmmpi6g54Rq
         xBXnAjqFlKwGTQNbd5VxBaVCrGGF8LPwca968shVsosQxlhCbUj3nbgD7a5eno9VuI6Z
         4HPrjD0JdyCAprnj7WBSNAsY65f2iMORZ3SLoLaiHmChSZIEqMsqT/uFnQjABfdY0CiC
         2tf544GjtOhh4S+8CsrYyd4CaRJdZZQnXbuiC5HQMg3eB2oa/fbQgQ9GxsJJaW508lxu
         a4w3q8fedB9TkSmZAFfYESF0GAwrLaWRwgsbxow5JfGftcTfBpR/gIGmuC2azVfgVCtG
         Ocgg==
X-Gm-Message-State: AOAM532f00kjJOsZXybcRuYgF+M6ogH3+qlMHlPlWAkMuSAZZEQ1PbhX
        RIrUxuyzThtmfxQ9kCww/1VyoVm0Ba/g10nKhds=
X-Google-Smtp-Source: ABdhPJy0zOlJy5vogI53OX57ulbJPDYAGuNkdoSKKgNsC8tQwxV2MHPAJ5XvGbCy2tigjJW0KBqTP4pOQbXTD0SIww8=
X-Received: by 2002:aca:f54e:: with SMTP id t75mr3129803oih.142.1626346078817;
 Thu, 15 Jul 2021 03:47:58 -0700 (PDT)
MIME-Version: 1.0
References: <20210715082536.1882077-1-aisheng.dong@nxp.com>
 <20210715082536.1882077-2-aisheng.dong@nxp.com> <20210715091207.gkd73vh3w67ccm4q@pengutronix.de>
In-Reply-To: <20210715091207.gkd73vh3w67ccm4q@pengutronix.de>
From:   Dong Aisheng <dongas86@gmail.com>
Date:   Thu, 15 Jul 2021 18:45:58 +0800
Message-ID: <CAA+hA=QDJhf_LnBZCiKE-FbUNciX4bmgmrvft8Y-vkB9Lguj=w@mail.gmail.com>
Subject: Re: [PATCH 1/7] dt-bindings: can: flexcan: fix imx8mp compatbile
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Dong Aisheng <aisheng.dong@nxp.com>,
        devicetree <devicetree@vger.kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

On Thu, Jul 15, 2021 at 5:12 PM Marc Kleine-Budde <mkl@pengutronix.de> wrote:
>
> On 15.07.2021 16:25:30, Dong Aisheng wrote:
> > This patch fixes the following errors during make dtbs_check:
> > arch/arm64/boot/dts/freescale/imx8mp-evk.dt.yaml: can@308c0000: compatible: 'oneOf' conditional failed, one must be fixed:
> >       ['fsl,imx8mp-flexcan', 'fsl,imx6q-flexcan'] is too long
>
> IIRC the fsl,imx6q-flexcan binding doesn't work on the imx8mp. Maybe
> better change the dtsi?

I checked with Joakim that the flexcan on MX8MP is derived from MX6Q with extra
ECC added. Maybe we should still keep it from HW point of view?

Regards
Aisheng

>
> regards,
> Marc
>
> --
> Pengutronix e.K.                 | Marc Kleine-Budde           |
> Embedded Linux                   | https://www.pengutronix.de  |
> Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
> Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |
