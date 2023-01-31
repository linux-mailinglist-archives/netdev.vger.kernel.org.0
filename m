Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7C0F6833A8
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 18:20:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232249AbjAaRTn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 12:19:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232038AbjAaRTV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 12:19:21 -0500
Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F00D5899A;
        Tue, 31 Jan 2023 09:18:37 -0800 (PST)
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-142b72a728fso20191944fac.9;
        Tue, 31 Jan 2023 09:18:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PHY1g9NcVmkrFDgyWaXSOXdRDZtffcuruHidQnxspPI=;
        b=UxLmbalpGqC+CoYv/9cmx6ZF8twsyvHi+SM21Zv0X3H6opUJEiXliC0+f7vrt7Iv1v
         R681VBrt/bptZwYhI31zx0jAY0n6lq9a7AIvjfnHcGtpErhELepVednzSfSDPMJKZSRz
         CISIcCV2RB6Uo4kMAPQmXt6DxhV1mUE09qzx4nax1etN2jo/tTECKHHKL/E8WdscrNrs
         HZCG36gvJ8JDGRH+64GE6Ml5lB84wsViXnKelqW0Oes020rS1G4k3uCGJjKhRxVN8yiI
         OiTySb2dBL8n4WiuDFeDvT0pkYUxn/t81fqJBObmaVe7FM5d5Z1BVTXOC9J2bSwy9hmf
         q18w==
X-Gm-Message-State: AO0yUKWXhf4ZwOSP3HR0v4J40T2UVpXNHg7Ety5bVkbLs14teU+DPchO
        9kln6PPymdgDviYh6YRJhw==
X-Google-Smtp-Source: AK7set9xG7wcz/LKEykzN3Ati9ZFLui3U5bLitdphySR+m21ouhWTU+akFctqtbJe1IQh0Gg9apl7Q==
X-Received: by 2002:a05:6870:3321:b0:15e:ff37:6fda with SMTP id x33-20020a056870332100b0015eff376fdamr7038257oae.14.1675185475058;
        Tue, 31 Jan 2023 09:17:55 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id u2-20020a056870304200b0015b64f8ff2bsm6714568oau.52.2023.01.31.09.17.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 09:17:54 -0800 (PST)
Received: (nullmailer pid 1549220 invoked by uid 1000);
        Tue, 31 Jan 2023 17:17:53 -0000
Date:   Tue, 31 Jan 2023 11:17:53 -0600
From:   Rob Herring <robh@kernel.org>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Ulrich Hecht <uli+renesas@fpond.eu>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 01/12] dt-bindings: can: renesas,rcar-canfd: R-Car V3U is
 R-Car Gen4
Message-ID: <20230131171753.GA1531174-robh@kernel.org>
References: <cover.1674499048.git.geert+renesas@glider.be>
 <4dea4b7dd76d4f859ada85f97094b7adeef5169f.1674499048.git.geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4dea4b7dd76d4f859ada85f97094b7adeef5169f.1674499048.git.geert+renesas@glider.be>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 23, 2023 at 07:56:03PM +0100, Geert Uytterhoeven wrote:
> Despite the name, R-Car V3U is the first member of the R-Car Gen4
> family.  Hence generalize this by introducing a family-specific
> compatible value for R-Car Gen4.
> 
> While at it, replace "both channels" by "all channels", as the numbers
> of channels may differ from two.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>  .../bindings/net/can/renesas,rcar-canfd.yaml          | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)

Properly threaded resend due to header corruption.

Acked-by: Rob Herring <robh@kernel.org>
