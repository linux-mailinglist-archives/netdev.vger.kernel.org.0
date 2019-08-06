Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BBA3834E1
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 17:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732279AbfHFPP6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 11:15:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:58554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726713AbfHFPP6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Aug 2019 11:15:58 -0400
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A620D2173C;
        Tue,  6 Aug 2019 15:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565104557;
        bh=la0HnOemoXK5fpvWjp+yCiuvCkWWSLx12p8REZ1hLrc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=cScU+ROGIiEoPjPJtTRdXG1cbQsMMpzEBSty6kfgERiB6umRY2L+C2ht5GwKKeCdJ
         nf0igOibxERc7xRV173c1Dp8A004bt+yeTKLrOFqRSGcUO70GxzHw5vhMW517vqGh3
         exHqFJOsZ4QKxPe/HxRcIXgWmdcw20oZH+8I7bEQ=
Received: by mail-qk1-f170.google.com with SMTP id g18so63145536qkl.3;
        Tue, 06 Aug 2019 08:15:57 -0700 (PDT)
X-Gm-Message-State: APjAAAVppu63WgttGv36475I5TjltgHt8Lu1MVjC/pPlv0rwbE2KmE0N
        X7DGuaZJwiNMorb5l6naVpbdLkMt7lPorqZrkQ==
X-Google-Smtp-Source: APXvYqwLPJFWVImQ45weKYeyNJR2eA5NTRfK2u/H55qjIL0tD0cxfdGp8MnhGn/VAZvOKrsEobtM9NSgRSK3rhzUNug=
X-Received: by 2002:a37:a010:: with SMTP id j16mr3781144qke.152.1565104556857;
 Tue, 06 Aug 2019 08:15:56 -0700 (PDT)
MIME-Version: 1.0
References: <20190806125041.16105-1-narmstrong@baylibre.com> <20190806125041.16105-3-narmstrong@baylibre.com>
In-Reply-To: <20190806125041.16105-3-narmstrong@baylibre.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Tue, 6 Aug 2019 09:15:45 -0600
X-Gmail-Original-Message-ID: <CAL_JsqKnzNMittFbvmz+ELu9UVMkmPmFoVT8ydWOYtCST+MwVA@mail.gmail.com>
Message-ID: <CAL_JsqKnzNMittFbvmz+ELu9UVMkmPmFoVT8ydWOYtCST+MwVA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] dt-bindings: net: meson-dwmac: convert to yaml
To:     Neil Armstrong <narmstrong@baylibre.com>
Cc:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        devicetree@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        linux-amlogic@lists.infradead.org,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 6, 2019 at 6:50 AM Neil Armstrong <narmstrong@baylibre.com> wrote:
>
> Now that we have the DT validation in place, let's convert the device tree
> bindings for the Synopsys DWMAC Glue for Amlogic SoCs over to a YAML schemas.
>
> Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
> ---
>  .../bindings/net/amlogic,meson-dwmac.yaml     | 113 ++++++++++++++++++
>  .../devicetree/bindings/net/meson-dwmac.txt   |  71 -----------
>  .../devicetree/bindings/net/snps,dwmac.yaml   |   5 +
>  3 files changed, 118 insertions(+), 71 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/amlogic,meson-dwmac.yaml
>  delete mode 100644 Documentation/devicetree/bindings/net/meson-dwmac.txt

I don't love the compatible schema with 'additionalItems: true' and
contains, but I guess it is what it is. I'm hopeful schemas help limit
how many variations we end up with.

Reviewed-by: Rob Herring <robh@kernel.org>

Rob
