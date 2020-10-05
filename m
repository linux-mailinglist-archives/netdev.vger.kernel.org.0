Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB5C0283904
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 17:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbgJEPH4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 11:07:56 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:44947 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725994AbgJEPH4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 11:07:56 -0400
Received: by mail-oi1-f195.google.com with SMTP id x62so4573177oix.11;
        Mon, 05 Oct 2020 08:07:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6MuacTclwsJ1CyOAEhANPVLNoJQr6TmVIPvVGKsF4Uw=;
        b=cXOPxj8Vq2xruHY83ntGu/wyCJEN+Tc39qZYOBeAyqEe53WuY6FFwR5bnuHLzDCsKx
         VZIZOzH4xRPT3m70949+lsC3S4NfBwXT/BrOKEteXnTWAB0JzwNHWCyWkri1bn4EHZmO
         Qf96Co8rqKHcZtifPMKGDv0vkE/dIGn/iUVPsg4C6AZEyfZVtBw4m1ed2BgMJqFy71uG
         CCIMW0o24ZUWNBdLLChhRvZ6r5s40HajwXJD2ene0B9Y8lZExoH817Y4BNOgfJcOWg0a
         41AJ1dQYvHGuLELsY/sgzydgJCKgmvqfOaNnRgGaWe1uwgXYfk9SzyotDH6yFqQ9Eqii
         6VfA==
X-Gm-Message-State: AOAM5318CVjT4depm4ES2Fw8GFKQquOBj6ZY4r9TBggE1fTIL0TNN4b5
        iFTMG+Vc6fZoEcEAV/gW74fqEWsYByk=
X-Google-Smtp-Source: ABdhPJxVOx/ll5cCu8f+CjeOZtvncPluPQZG+qMwGuDra30zvr6A9xQ9iMIc8utqpMFNsj0gEqc7lg==
X-Received: by 2002:a54:440b:: with SMTP id k11mr42317oiw.76.1601910471848;
        Mon, 05 Oct 2020 08:07:51 -0700 (PDT)
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com. [209.85.210.50])
        by smtp.gmail.com with ESMTPSA id m6sm2928579otm.76.2020.10.05.08.07.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Oct 2020 08:07:51 -0700 (PDT)
Received: by mail-ot1-f50.google.com with SMTP id n61so8895443ota.10;
        Mon, 05 Oct 2020 08:07:50 -0700 (PDT)
X-Received: by 2002:a05:6830:196:: with SMTP id q22mr11485396ota.221.1601910470753;
 Mon, 05 Oct 2020 08:07:50 -0700 (PDT)
MIME-Version: 1.0
References: <1601901999-28280-1-git-send-email-madalin.bucur@oss.nxp.com>
In-Reply-To: <1601901999-28280-1-git-send-email-madalin.bucur@oss.nxp.com>
From:   Li Yang <leoyang.li@nxp.com>
Date:   Mon, 5 Oct 2020 10:07:40 -0500
X-Gmail-Original-Message-ID: <CADRPPNT_SJad2JLwR2t52kRU14d1kW+r52n1dxJ=Xs0UnQb9Zw@mail.gmail.com>
Message-ID: <CADRPPNT_SJad2JLwR2t52kRU14d1kW+r52n1dxJ=Xs0UnQb9Zw@mail.gmail.com>
Subject: Re: [PATCH] arm64: dts: fsl: DPAA FMan DMA operations are coherent
To:     madalin.bucur@oss.nxp.com
Cc:     Shawn Guo <shawnguo@kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        Netdev <netdev@vger.kernel.org>, camelia.groza@oss.nxp.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 5, 2020 at 7:47 AM Madalin Bucur <madalin.bucur@oss.nxp.com> wrote:
>
> Although the DPAA 1 FMan operations are coherent, the device tree
> node for the FMan does not indicate that, resulting in a needless
> loss of performance. Adding the missing dma-coherent property.
>
> Fixes: 1ffbecdd8321 ("arm64: dts: add DPAA FMan nodes")
>
> Signed-off-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
> Tested-by: Camelia Groza <camelia.groza@oss.nxp.com>

Acked-by: Li Yang <leoyang.li@nxp.com>

> ---
>  arch/arm64/boot/dts/freescale/qoriq-fman3-0.dtsi | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/arch/arm64/boot/dts/freescale/qoriq-fman3-0.dtsi b/arch/arm64/boot/dts/freescale/qoriq-fman3-0.dtsi
> index 8bc6caa9167d..4338db14c5da 100644
> --- a/arch/arm64/boot/dts/freescale/qoriq-fman3-0.dtsi
> +++ b/arch/arm64/boot/dts/freescale/qoriq-fman3-0.dtsi
> @@ -19,6 +19,7 @@ fman0: fman@1a00000 {
>         clock-names = "fmanclk";
>         fsl,qman-channel-range = <0x800 0x10>;
>         ptimer-handle = <&ptp_timer0>;
> +       dma-coherent;
>
>         muram@0 {
>                 compatible = "fsl,fman-muram";
> --
> 2.1.0
>
