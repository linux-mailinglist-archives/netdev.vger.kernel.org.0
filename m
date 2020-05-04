Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E8021C4336
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 19:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730025AbgEDRrw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 13:47:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728158AbgEDRrw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 13:47:52 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3D85C061A0E;
        Mon,  4 May 2020 10:47:51 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id s9so14691553eju.1;
        Mon, 04 May 2020 10:47:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hQpvk8vgp1YbyFllbBW8xqqGLWMt1EgunqBmk7p9TlQ=;
        b=kjhU7qwuLUl0tgR1+ZMtPX0gXNz5aUz/F88ZhiEUnMhCOiWuh8hJ4xwCoE3QiM1C4n
         M3DzFk5zkOAz+jwzdAFblAhyYtMvNzM94V+VxmXFm9XyRdE58Aa5LQt/wDR804AsrwW6
         Gl0AFFTX0mrDpCguqaReT2ETbj+lzXW/0WsupNJCzFs99F8kQVWs+c9cXg8kvkryihl8
         lFhk009uQr70yHCuCRiE3Fiw06qQSWfKls9EoZeZtSmS89io1+oDDCu5YxgDY7dsYh8e
         0xEZkItYS7PyyjOCIrjmriI81HVc4ntiwcrBXe568He/68RB9mE1jIGumTBrIR276y4S
         Vz1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hQpvk8vgp1YbyFllbBW8xqqGLWMt1EgunqBmk7p9TlQ=;
        b=ZYCoH0S4eZ1b+Z/fmlsgZLbvJuWiwTxTNk32WH9oujQ72ficZcNivLRToRCYOGsp4G
         MebSEc6GuyE1K8F6bSbTozrbWn6g2510BY08WeOFzDDQp8SV1vXLlEqbATFbN762gb4y
         MQBjxThcPtTsjTHOuR0sCivTxldqvczCrxH+CDf/xaaphBft9qcRf9HiXxosIdSiAN00
         LALjClp9P0KGMfYL3Wmgqx6tNYNINYaH/lNNiifnOx3HslcPPLrBVqPbV3DNgD2Q5RYR
         Z8Ymx/vgApA4q5k/p/CWj6/mBGQs2KNt+YyZqNU23QuINqoFaDaEgFGhk6qzNNuND7Ft
         UhuQ==
X-Gm-Message-State: AGi0PuayrTR8+VgrR0rZ575ZwL7uWGzHHaJdPBKuuAuwGIYl3DFsxkEu
        JAg1pImWtiMfdB2BJPX9H5nf6JyY8ZfuY9WnGig=
X-Google-Smtp-Source: APiQypIB+DjJDEbl3B8ocaghRBc++ZzEvZ0KpOa2gaX14qS/UjOBQn89425mtvYHu8jWZhwETphKyX3pbNyfgGl3Sms=
X-Received: by 2002:a17:906:78c:: with SMTP id l12mr14971947ejc.189.1588614470560;
 Mon, 04 May 2020 10:47:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200504165228.12787-1-michael@walle.cc>
In-Reply-To: <20200504165228.12787-1-michael@walle.cc>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 4 May 2020 20:47:39 +0300
Message-ID: <CA+h21hpGT8qzeOVUZKU2CJDRmjSyRO-Z2oy_PvPeN88jTPsYuw@mail.gmail.com>
Subject: Re: [PATCH RESEND net-next] net: dsa: felix: allow the device to be disabled
To:     Michael Walle <michael@walle.cc>
Cc:     "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 4 May 2020 at 19:55, Michael Walle <michael@walle.cc> wrote:
>
> If there is no specific configuration of the felix switch in the device
> tree, but only the default configuration (ie. given by the SoCs dtsi
> file), the probe fails because no CPU port has been set. On the other
> hand you cannot set a default CPU port because that depends on the
> actual board using the switch.
>
> [    2.701300] DSA: tree 0 has no CPU port
> [    2.705167] mscc_felix 0000:00:00.5: Failed to register DSA switch: -22
> [    2.711844] mscc_felix: probe of 0000:00:00.5 failed with error -22
>
> Thus let the device tree disable this device entirely, like it is also
> done with the enetc driver of the same SoC.
>
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>

> This was part of a two patch series. The second patch is already merged.
> This patch was never picked up, although it was Acked-by: David Miller,
> see:
> https://lore.kernel.org/netdev/20200314.205335.907987569817755804.davem@davemloft.net/
>
> Since there is no more dependency, this patch could go through the
> net-next queue.
>
>  drivers/net/dsa/ocelot/felix.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
> index 69546383a382..531c7710063f 100644
> --- a/drivers/net/dsa/ocelot/felix.c
> +++ b/drivers/net/dsa/ocelot/felix.c
> @@ -699,6 +699,11 @@ static int felix_pci_probe(struct pci_dev *pdev,
>         struct felix *felix;
>         int err;
>
> +       if (pdev->dev.of_node && !of_device_is_available(pdev->dev.of_node)) {
> +               dev_info(&pdev->dev, "device is disabled, skipping\n");
> +               return -ENODEV;
> +       }
> +
>         err = pci_enable_device(pdev);
>         if (err) {
>                 dev_err(&pdev->dev, "device enable failed\n");
> --
> 2.20.1
>

Thanks, Michael!
-Vladimir
