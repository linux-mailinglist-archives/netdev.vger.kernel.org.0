Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1D373DF690
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 22:45:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230509AbhHCUpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 16:45:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbhHCUph (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 16:45:37 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8416CC061757;
        Tue,  3 Aug 2021 13:45:25 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id cf5so772351edb.2;
        Tue, 03 Aug 2021 13:45:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8ZbatCuwF0ejzY/254BQh4plkI8mltXs2twaQnckgMI=;
        b=p6BnMCoQVqlyPBcxlHpgLvhxDtbmUN84h5PkOllCD755g4MCf/UKkPDMAXladxB+fB
         ItXeBPNZU1eu9qpp2s5qRNf19y0GWfCc4yrZUM81hGss6a03DsR62OdzljQaK7beX4u2
         6O0AeUatpKRyCVLH5f1CDB73J/mah8Eangexn4iulbgM3QdMIK10G8SMlbKBxBPMIQV/
         H2hRARFM/WDnnDj9FIHnoiBbr7QTnZbd/iubtmfctpxrvCom9vD8ZBXQ2iDcgfyIqucm
         Y7GGg4o3zIqe8U26oZdecITIO1v8XS/OujFchRVeQHCvAUQFxXRFEueD3DvJ3VSMbqOG
         vt5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8ZbatCuwF0ejzY/254BQh4plkI8mltXs2twaQnckgMI=;
        b=tP3qrxzCc1XNXAC28TUBTXAQMFo9VZlK/CUR4VhMz8qz0joYkKieOOrZ+uYlRVUkhW
         sN0Nk7u0PxEuroyJgVxDxcboR5mTFYan6VRytyiIl7FFRzDwwvW81mm/HbgM5HLRWxpJ
         zgUTZ+Iz+Ss6vYgl2tphBetdIdtE+u84XwW89kdB8VAp05uYh9fTp6RadTzm+MMkMfiB
         tlFki44tzaH7zDMF7qdvwoZfJ35UgTBQfZ8db28xXiIZ/QQXxIm+Id8Jd1EciqI0BwHt
         h6aYuAjEcG0sbaCWBWC2Y1mIyDgB2Mx7LNi+zjBg42HG4ZMJuxH64CV+a7EvZxP92Qu5
         tchw==
X-Gm-Message-State: AOAM532N28wb0sSltqaXFfxoqJb1qWmKCCcljGcJVCH052BTdn/D1PFK
        jhgcEOhEBjIExR/757CKQZC4OyDII4ZtnaT3Fww=
X-Google-Smtp-Source: ABdhPJxRXiJDPGTIfneS7YyQ40d3AXe1t8qEhKVPNz8CIijfGmO3fHXUd9wo1ewgVlv71M9TOcDpUS40b9+EssDoF4k=
X-Received: by 2002:a05:6402:54d:: with SMTP id i13mr27685680edx.179.1628023524096;
 Tue, 03 Aug 2021 13:45:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210729201100.3994-1-linux.amoon@gmail.com> <20210729201100.3994-4-linux.amoon@gmail.com>
In-Reply-To: <20210729201100.3994-4-linux.amoon@gmail.com>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Tue, 3 Aug 2021 22:45:13 +0200
Message-ID: <CAFBinCAVaaXd+jXBtA9RETP5AavOfeUVZLkU1ohGT2Lmx+H1cw@mail.gmail.com>
Subject: Re: [PATCHv1 3/3] net: stmmac: dwmac-meson8b: Add reset controller
 for ethernet phy
To:     Anand Moon <linux.amoon@gmail.com>
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        devicetree@vger.kernel.org, Jerome Brunet <jbrunet@baylibre.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Rob Herring <robh+dt@kernel.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Emiliano Ingrassia <ingrassia@epigenesys.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Anand,

On Thu, Jul 29, 2021 at 10:11 PM Anand Moon <linux.amoon@gmail.com> wrote:
>
> Add reset controller for Ethernet phy reset on every boot for
> Amlogic SoC.
I think this description does not match what's going on inside the SoC:
- for all SoCs earlier than GXL the PHY is external so the reset for
the PHY is a GPIO
- the reset line you are passing in the .dts belongs to the Ethernet
controller on SoCs earlier than GXL
- I *believe* that the rset line which you're passing in the .dts
belongs to the Ethernet controller AND the built-in MDIO mux on GXL
and newer, see also [0]
- from how the PRG_ETH registers work I doubt that these are connected
to a reset line (as they're managing mostly delays and protocol - so I
don't see what would be reset). This is speculation though.


Best regards,
Martin


[0] https://lore.kernel.org/linux-amlogic/553e127c-9839-d15b-d435-c01f18c7be48@gmail.com/
