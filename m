Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3354A1F5EE4
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 01:52:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726800AbgFJXwG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 19:52:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726722AbgFJXwG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 19:52:06 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50E4CC03E96B;
        Wed, 10 Jun 2020 16:52:04 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id dr13so4538771ejc.3;
        Wed, 10 Jun 2020 16:52:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MuccjIeuo0bZ1s7Bzwfs+y97Jy+M+Z4a5SPaB4smADY=;
        b=dBQYhmidzXfI0D76lbN2ZXF2oyqahsJwFNRbREWsnas8jvdlzfTliGJeHAhXclCZfh
         grHNgJHqDTf6Iah81c2mHHBi1VcQHDFAsL9zbXW8eDSKnuEyQYF+aZJ+c6V3a52rUC3P
         sQr1WFaEksvPcMm3FFgfIjJAznFrzGNJBFPBvpCI8vQDaNs84aMmovLYa2ZMmF/JINzv
         nnxborEoATwXcJI7Vun9wT31FVq34WZ7kElW8UC3rwNM6/LpeP1dOLYyb67OguxeP37g
         atWfYb1MEopwGZeav6+BVqSeMjHJDd+i8gpVFe9aNQVCR6+2gtAhnJVtSxCn/6U8uINr
         Vrfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MuccjIeuo0bZ1s7Bzwfs+y97Jy+M+Z4a5SPaB4smADY=;
        b=PU5duVwWonDj66dHC3z090HgPQ+t0zK7Grw0NsUf5spa4CFzKXEOFCeAFH0+mZyCuj
         nwJuhen/Ng27FEj2EiLZT4rh3qiQ0ygSYs6ft0EKe9nDeeFJctmJxPKjYTkQ1YObjZd6
         ak1Pf2QXjmA8z9tZPKmL0UIVQ6BtordsITVSEU+raqUFxMeDZsHaAEK6Efn3xPKPXDbP
         8C/MAkcPYtbloBI6e5ZBrvRYlM2dA7SwZe4XZwB0Xkm6bjl+qhbHnbUnXaj+KG53mFfQ
         ARdvKWTV5fzHcBn8Aouzhtrr4Y6TXjjucGlOaApfds0uIqYl1TwrWGTPXYsWOPHvloki
         Oxng==
X-Gm-Message-State: AOAM531RwCyaYabvBfy5TVrkbmGXuwD1sAtFWAOkhBEVhVJ1VIfqE7TT
        teahfR2a6vcriumd2NW6xnNLZy1R9uDJZ2xlXdppdm9o
X-Google-Smtp-Source: ABdhPJxU8K6efgdp+NqPSkaIGb50jMgaarfPaDBz3ll0yEjTg9AFBVHULVcQjpLbyK4wXHbeRMJ0dxSowZlJ9SM0y4Q=
X-Received: by 2002:a17:906:2e50:: with SMTP id r16mr5634981eji.305.1591833122486;
 Wed, 10 Jun 2020 16:52:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200610233803.424723-1-kuba@kernel.org>
In-Reply-To: <20200610233803.424723-1-kuba@kernel.org>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 11 Jun 2020 02:51:51 +0300
Message-ID: <CA+h21hpSRF8agAyQ=42qh=KY0+zczCa0E44GMgvmakimfXwDpQ@mail.gmail.com>
Subject: Re: [PATCH net] docs: networkng: convert sja1105's devlink info to RTS
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 11 Jun 2020 at 02:40, Jakub Kicinski <kuba@kernel.org> wrote:
>
> A new file snuck into the tree after all existing documentation
> was converted to RST. Convert sja1105's devlink info and move
> it where the rest of the drivers are documented.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---

Acked-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Only if you need to resend, there are 2 typos in the commit title:
networkng and RTS -> RST.

>  .../networking/devlink-params-sja1105.txt     | 27 ----------
>  Documentation/networking/devlink/index.rst    |  1 +
>  Documentation/networking/devlink/sja1105.rst  | 49 +++++++++++++++++++
>  3 files changed, 50 insertions(+), 27 deletions(-)
>  delete mode 100644 Documentation/networking/devlink-params-sja1105.txt
>  create mode 100644 Documentation/networking/devlink/sja1105.rst
>
> diff --git a/Documentation/networking/devlink-params-sja1105.txt b/Documentation/networking/devlink-params-sja1105.txt
> deleted file mode 100644
> index 1d71742e270a..000000000000
> --- a/Documentation/networking/devlink-params-sja1105.txt
> +++ /dev/null
> @@ -1,27 +0,0 @@
> -best_effort_vlan_filtering
> -                       [DEVICE, DRIVER-SPECIFIC]
> -                       Allow plain ETH_P_8021Q headers to be used as DSA tags.
> -                       Benefits:
> -                       - Can terminate untagged traffic over switch net
> -                         devices even when enslaved to a bridge with
> -                         vlan_filtering=1.
> -                       - Can terminate VLAN-tagged traffic over switch net
> -                         devices even when enslaved to a bridge with
> -                         vlan_filtering=1, with some constraints (no more than
> -                         7 non-pvid VLANs per user port).
> -                       - Can do QoS based on VLAN PCP and VLAN membership
> -                         admission control for autonomously forwarded frames
> -                         (regardless of whether they can be terminated on the
> -                         CPU or not).
> -                       Drawbacks:
> -                       - User cannot use VLANs in range 1024-3071. If the
> -                         switch receives frames with such VIDs, it will
> -                         misinterpret them as DSA tags.
> -                       - Switch uses Shared VLAN Learning (FDB lookup uses
> -                         only DMAC as key).
> -                       - When VLANs span cross-chip topologies, the total
> -                         number of permitted VLANs may be less than 7 per
> -                         port, due to a maximum number of 32 VLAN retagging
> -                         rules per switch.
> -                       Configuration mode: runtime
> -                       Type: bool.
> diff --git a/Documentation/networking/devlink/index.rst b/Documentation/networking/devlink/index.rst
> index c536db2cc0f9..7684ae5c4a4a 100644
> --- a/Documentation/networking/devlink/index.rst
> +++ b/Documentation/networking/devlink/index.rst
> @@ -40,5 +40,6 @@ parameters, info versions, and other features it supports.
>     mv88e6xxx
>     netdevsim
>     nfp
> +   sja1105
>     qed
>     ti-cpsw-switch
> diff --git a/Documentation/networking/devlink/sja1105.rst b/Documentation/networking/devlink/sja1105.rst
> new file mode 100644
> index 000000000000..e2679c274085
> --- /dev/null
> +++ b/Documentation/networking/devlink/sja1105.rst
> @@ -0,0 +1,49 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +=======================
> +sja1105 devlink support
> +=======================
> +
> +This document describes the devlink features implemented
> +by the ``sja1105`` device driver.
> +
> +Parameters
> +==========
> +
> +.. list-table:: Driver-specific parameters implemented
> +  :widths: 5 5 5 85
> +
> +  * - Name
> +    - Type
> +    - Mode
> +    - Description
> +  * - ``best_effort_vlan_filtering``
> +    - Boolean
> +    - runtime
> +    - Allow plain ETH_P_8021Q headers to be used as DSA tags.
> +
> +      Benefits:
> +
> +      - Can terminate untagged traffic over switch net
> +        devices even when enslaved to a bridge with
> +        vlan_filtering=1.
> +      - Can terminate VLAN-tagged traffic over switch net
> +        devices even when enslaved to a bridge with
> +        vlan_filtering=1, with some constraints (no more than
> +        7 non-pvid VLANs per user port).
> +      - Can do QoS based on VLAN PCP and VLAN membership
> +        admission control for autonomously forwarded frames
> +        (regardless of whether they can be terminated on the
> +        CPU or not).
> +
> +      Drawbacks:
> +
> +      - User cannot use VLANs in range 1024-3071. If the
> +       switch receives frames with such VIDs, it will
> +       misinterpret them as DSA tags.
> +      - Switch uses Shared VLAN Learning (FDB lookup uses
> +       only DMAC as key).
> +      - When VLANs span cross-chip topologies, the total
> +       number of permitted VLANs may be less than 7 per
> +       port, due to a maximum number of 32 VLAN retagging
> +       rules per switch.
> --
> 2.26.2
>

Thanks,
-Vladimir
