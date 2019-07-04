Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85D8F5F355
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 09:16:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727328AbfGDHQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 03:16:24 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:40509 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbfGDHQY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 03:16:24 -0400
Received: by mail-lj1-f196.google.com with SMTP id a21so5099330ljh.7
        for <netdev@vger.kernel.org>; Thu, 04 Jul 2019 00:16:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CM3CA+ac86LStxn0A7zCf+sHc6gVIK+nURjGT/ZVURM=;
        b=noWI4Xsww4AJnpE58QFOvduhB9wBWDFkpSe+Vwy2fZ0AOCB5779/gGsN9l9X3L3+Vz
         2U5Mk11jDXkh5zK+rXiY70rSTYMLGD7BnXPYnyoCcVx8i4GKaFI7DmR0K3KNh6+ITsLa
         +ZIwOEF1CtSL/fsKuACAzNIn1sAWmf3FOy9180YbvETQeZ8FwqoZUTSzZJ38suahAHQ6
         2/pTGWkhA96+/1UdRfkOfONEpVlxYmnxyH5DD4tqyT6zU50JG5MO65uD+2RKBnlx17GQ
         u3caugrGFRIDPf3gx/miR319qEwsnJDN2icdIMupqu+FmXg/MqUQprrULNQponZsL/jF
         B9Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CM3CA+ac86LStxn0A7zCf+sHc6gVIK+nURjGT/ZVURM=;
        b=YdHxE3CU0erTKuuQGmkX4uJzMOV5mHoulPk3zngYNplF+ITCPBvSMWlEA2cBzk3gKq
         6WpF79vsuQRTeHHgYZZphjuU7wMQTFqoXfs1//5va09Gq//WtsVETczqjJlNyJtc+eqY
         lC7oLD4OIwIszP04BRvyMjGIbWKg7TlyWe1cc5QNpCjOIRsTi3SvRiHAoC3tc5fUzO0O
         PT+Umkd169xKWnagcPpnHwEXfeIofsnOBA/2L2SoN6MShNWynXKlKw/a9dk5+GoOpQoO
         0Kdfn6qpnfd6rf6sRu6CduhhIeWfdegs9K3VuuylRALH2OG29SR3JHQbbK0Y/7NTj0l6
         Jaeg==
X-Gm-Message-State: APjAAAXddxb6Ui8aSETnx7cIoNd0AJQlT4S9d1pWapMT1yxDMUZsE7PI
        pRd4uqUPO+shGSK6xrqaJahZMdRu5ogxdnKgMr9diQ==
X-Google-Smtp-Source: APXvYqzE9S7+MBd9cz3CLYgD2cxe0CiQIYN/YmMnO+BXFTBBIuqXEJP5eErh26Lm2r6+xg1JL2/RPnz20gM0wD6QESg=
X-Received: by 2002:a2e:8195:: with SMTP id e21mr5076509ljg.62.1562224582501;
 Thu, 04 Jul 2019 00:16:22 -0700 (PDT)
MIME-Version: 1.0
References: <20190703171924.31801-1-paweldembicki@gmail.com> <20190703171924.31801-4-paweldembicki@gmail.com>
In-Reply-To: <20190703171924.31801-4-paweldembicki@gmail.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Thu, 4 Jul 2019 09:16:10 +0200
Message-ID: <CACRpkdaLZ8XeyLhH_mzwb5phRNvuwuUgecWKBVa1Z7L0QqH_bw@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] net: dsa: vsc73xx: add support for parallel mode
To:     Pawel Dembicki <paweldembicki@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pawel,

this looks overall good and the following is just
documentation nit-pick so feel free to add my
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

On Wed, Jul 3, 2019 at 7:21 PM Pawel Dembicki <paweldembicki@gmail.com> wrote:

> This patch add platform part of vsc73xx driver.
> It allows to use chip connected by parallel interface.
>
> Signed-off-by: Pawel Dembicki <paweldembicki@gmail.com>

I would elaborate on the fact that we're dealing with memory-mapped
I/O but perhaps even more important to do that in the source code file and
Kconfig so it is close to the users rather than in the changelog.

Write something about the address bus wireing making all
accesses big endian.

> +config NET_DSA_VITESSE_VSC73XX_PLATFORM
> +       tristate "Vitesse VSC7385/7388/7395/7398 Platform mode support"
> +       depends on HAS_IOMEM
> +       select NET_DSA_VITESSE_VSC73XX
> +       ---help---
> +         This enables support for the Vitesse VSC7385, VSC7388, VSC7395
> +         and VSC7398 SparX integrated ethernet switches in Platform managed mode.

I would insert something about memory-mapped I/O mode
over a CPU-attached address bus.

Yours,
Linus Walleij
