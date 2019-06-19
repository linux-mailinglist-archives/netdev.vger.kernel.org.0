Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFC944BC02
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 16:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729978AbfFSOri (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 10:47:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:47746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726839AbfFSOri (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jun 2019 10:47:38 -0400
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 442982183F;
        Wed, 19 Jun 2019 14:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560955657;
        bh=MispwiBeGhFnc70/V895Ut0pfCpszgeSw5NVXb/tVqE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=UtqG5Q7O8kyz0HVnCptfeQpM5R6jfDGYeTfYLwvI6q/0SZ4o6PXqkVCPTICjtHVVa
         DBBz/iW04N6UCDfKNGSMzAY+V2sJ0ShYJkox90+pzW71p5Rt+h69+RHD8zQvMNGI8F
         x/2cl2r7QSkT06+DC3ICEfHDuPoOv/E8uUn88lqk=
Received: by mail-qt1-f175.google.com with SMTP id i34so14899114qta.6;
        Wed, 19 Jun 2019 07:47:37 -0700 (PDT)
X-Gm-Message-State: APjAAAVDtKEE3V5M2Zp+belniSwTezsLAxeieEjvq82j+8H/2/TsTnoW
        TYpwNTJZGRCC/J9B+2L6uYn44FV1Wqol7Ew8EA==
X-Google-Smtp-Source: APXvYqzxfiq+J/8q3EtSbIQaJxlL5XeiaNwyKA4fxgTdB/b6ypNd2gAyff/wVi4H6PtRE56OBERhjbnLodMppIC8+hc=
X-Received: by 2002:a0c:b627:: with SMTP id f39mr34545269qve.72.1560955656548;
 Wed, 19 Jun 2019 07:47:36 -0700 (PDT)
MIME-Version: 1.0
References: <27aeb33cf5b896900d5d11bd6957eda268014f0c.1560937626.git-series.maxime.ripard@bootlin.com>
 <07bc6b607cf1ad88214b7ce528fadf0b1ce30784.1560937626.git-series.maxime.ripard@bootlin.com>
In-Reply-To: <07bc6b607cf1ad88214b7ce528fadf0b1ce30784.1560937626.git-series.maxime.ripard@bootlin.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Wed, 19 Jun 2019 08:47:24 -0600
X-Gmail-Original-Message-ID: <CAL_Jsq+69nL40xUxYAEWaixEqs9=oNdbp-59Jogx8o2wyYFdnw@mail.gmail.com>
Message-ID: <CAL_Jsq+69nL40xUxYAEWaixEqs9=oNdbp-59Jogx8o2wyYFdnw@mail.gmail.com>
Subject: Re: [PATCH v3 11/16] dt-bindings: net: dwmac: Deprecate the PHY reset properties
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
        =?UTF-8?Q?Antoine_T=C3=A9nart?= <antoine.tenart@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 19, 2019 at 3:47 AM Maxime Ripard <maxime.ripard@bootlin.com> wrote:
>
> Even though the DWMAC driver uses some driver specific properties, the PHY
> core has a bunch of generic properties and can deal with them nicely.
>
> Let's deprecate our specific properties.
>
> Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
>
> ---
>
> Changes from v2:
>   - Use the deprecated keyword instead of duplicating them
>
> Changes from v1:
>   - New patch
> ---
>  Documentation/devicetree/bindings/net/snps,dwmac.yaml | 3 +++
>  1 file changed, 3 insertions(+)

Reviewed-by: Rob Herring <robh@kernel.org>
