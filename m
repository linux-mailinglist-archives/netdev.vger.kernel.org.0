Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7B39281DD
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 17:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730918AbfEWPzR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 11:55:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:46362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730752AbfEWPzR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 May 2019 11:55:17 -0400
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D071217F9;
        Thu, 23 May 2019 15:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558626916;
        bh=JUOPRAHlxD37cj7X5mjXujgKukJ+EI5g3Of9neklXRc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Ocp40sto8Gq6/0uRuAdHyZHHkF2oG0CIBODLzqqtKumSJxpWuCby6vxTFj19gf+eG
         9FIWW+5EJzp220GZ5j8OH62sdyNyEuCD+eRtoGun/U2S9jWpB4JlUEt4bCAxHyel/w
         mZK/3l5p6LCRP+bLZqB9mlMk2s0vqj6Wz6G6CFcM=
Received: by mail-qt1-f178.google.com with SMTP id y42so7315177qtk.6;
        Thu, 23 May 2019 08:55:16 -0700 (PDT)
X-Gm-Message-State: APjAAAUJ1Ge1xsbBmY44FJDZ8D2eFqS4uXMmq5mgoTW+4u246I65MU22
        j6wFwbZkFkIGly6g68LIDx1AQxZWss69dj26zQ==
X-Google-Smtp-Source: APXvYqwEEihkSXSYkUOGNw6QZNJ7c5VF8WdzMUhYcRqzxhUuKrUfiTJdsCIvlXDQgQ80MHzHtm0PBbhB4PgJSALMZ1k=
X-Received: by 2002:ac8:6b14:: with SMTP id w20mr60341941qts.110.1558626915748;
 Thu, 23 May 2019 08:55:15 -0700 (PDT)
MIME-Version: 1.0
References: <74d98cc3c744d53710c841381efd41cf5f15e656.1558605170.git-series.maxime.ripard@bootlin.com>
 <6f16585ffdc75af4e023c4d3ebba68feb65cc26e.1558605170.git-series.maxime.ripard@bootlin.com>
In-Reply-To: <6f16585ffdc75af4e023c4d3ebba68feb65cc26e.1558605170.git-series.maxime.ripard@bootlin.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Thu, 23 May 2019 10:55:04 -0500
X-Gmail-Original-Message-ID: <CAL_Jsq+PMT99aw5bkp515XDpKELdpXB2BH_n6e-BwQS+KAHy0Q@mail.gmail.com>
Message-ID: <CAL_Jsq+PMT99aw5bkp515XDpKELdpXB2BH_n6e-BwQS+KAHy0Q@mail.gmail.com>
Subject: Re: [PATCH 7/8] dt-bindings: net: sun7i-gmac: Convert the binding to
 a schemas
To:     Maxime Ripard <maxime.ripard@bootlin.com>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Frank Rowand <frowand.list@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Chen-Yu Tsai <wens@csie.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        netdev <netdev@vger.kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>, devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        =?UTF-8?Q?Antoine_T=C3=A9nart?= <antoine.tenart@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 23, 2019 at 4:57 AM Maxime Ripard <maxime.ripard@bootlin.com> wrote:
>
> Switch our Allwinner A20 GMAC controller binding to a YAML schema to enable
> the DT validation. Since that controller is based on a Synopsys IP, let's
> add the validation to that schemas with a bunch of conditionals.
>
> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> ---
>  Documentation/devicetree/bindings/net/allwinner,sun7i-a20-gmac.txt | 27 ---------------------------
>  Documentation/devicetree/bindings/net/snps,dwmac.yaml              | 45 +++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 45 insertions(+), 27 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/net/allwinner,sun7i-a20-gmac.txt

I think it would be better to keep these as separate files and either
include snps,dwmac.yaml from it or only add the compatible to
snps,dwmac.yaml.

Rob
