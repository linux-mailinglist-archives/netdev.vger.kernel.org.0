Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62D9E3343A5
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 17:50:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233282AbhCJQta (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 11:49:30 -0500
Received: from mout.kundenserver.de ([217.72.192.75]:41249 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233403AbhCJQtS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 11:49:18 -0500
Received: from mail-ot1-f44.google.com ([209.85.210.44]) by
 mrelayeu.kundenserver.de (mreue109 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1MZkxd-1lHRcJ1fzL-00Wn2Y; Wed, 10 Mar 2021 17:49:16 +0100
Received: by mail-ot1-f44.google.com with SMTP id f8so11962703otp.8;
        Wed, 10 Mar 2021 08:49:15 -0800 (PST)
X-Gm-Message-State: AOAM533hQ+xG6dX7imtpVcnOSbp0W3hWw6zAzLLsZI8NK7GV1NugFXuy
        /3LH8CPE+Kj77hCIr01N9ARXTFDiXytnxeBrR3k=
X-Google-Smtp-Source: ABdhPJw1kIhr8ttdGXD5g+DpuAzvAToYG1aFxOSVPDl56eSY4x70c4eQdWZH4tiH2ZUpEN9KrRB/9/YZCrDgnKY8YZU=
X-Received: by 2002:a05:6830:14c1:: with SMTP id t1mr3227502otq.305.1615394954588;
 Wed, 10 Mar 2021 08:49:14 -0800 (PST)
MIME-Version: 1.0
References: <20210310083327.480837-1-krzysztof.kozlowski@canonical.com>
 <20210310083840.481615-1-krzysztof.kozlowski@canonical.com> <20210310083840.481615-3-krzysztof.kozlowski@canonical.com>
In-Reply-To: <20210310083840.481615-3-krzysztof.kozlowski@canonical.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 10 Mar 2021 17:48:58 +0100
X-Gmail-Original-Message-ID: <CAK8P3a27hAExCKtsO7k1HQwLKk-5Q8uxYYt_G2v-Osq8RZv2tg@mail.gmail.com>
Message-ID: <CAK8P3a27hAExCKtsO7k1HQwLKk-5Q8uxYYt_G2v-Osq8RZv2tg@mail.gmail.com>
Subject: Re: [RFC v2 5/5] clk: socfpga: allow compile testing of Stratix 10 /
 Agilex clocks
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Moritz Fischer <mdf@kernel.org>, Tom Rix <trix@redhat.com>,
        Lee Jones <lee.jones@linaro.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        DTML <devicetree@vger.kernel.org>,
        linux-clk <linux-clk@vger.kernel.org>,
        linux-edac@vger.kernel.org, linux-fpga@vger.kernel.org,
        Networking <netdev@vger.kernel.org>,
        linux-stm32@st-md-mailman.stormreply.com, arm-soc <arm@kernel.org>,
        SoC Team <soc@kernel.org>, Olof Johansson <olof@lixom.net>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:UpF+IKYWh1Pc1r65f61MWWUzwAfDePicEmQd6YhxfkvjnX8dOr+
 ICz2/kJDiaAWWb6Lsh6CxGoVmPSVZWfzh2g960mHqUaQRxQ/RBkQbakZt0W8y5R+LtLAYUV
 vDnT39U36yusfTCTbtRHUlR/GtjyIEC5opA8/1Pyy4mqX6sdhMkCJp/HswNg3LYUnpb4Clx
 6x8zW0wO2ujskcBfKsMAg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:BECPo1lR3ZY=:w74Ff2HwUIYjwaEBMZUU4F
 GlYvFmvUchmTeBU1459yu4h4+FmwtrHuouAHEHhyJYn1h2DOqx6yaeJh4/xx/IPdTRyFgjqJW
 Wpo1c02oOks0npEfpemuj+2+gM+six/cN2BzVrDOMOdP4zGa2wzMM1vVfGPztg7A9ZPcce6wO
 o30XlDj9oL4BxqDXVVhqPrYRUx8SS/mLUeSrZzatAP/oL9DRmqYB4WD1vCLbmYeXY6QzXQjlp
 79hdmOd06JxkTxCWu2G+p5sStoHnqQ64yHro31voae7jiLSumWgPBXq8ofGDiZXbzWUSvJg6n
 /4pXOEvFrITGjVrcIl/eea8d2EXvb3nntxATRuyn9dgbSDbnJM1NX2KEpKhAHGTiqbce3QO+r
 xwTtLiyw7fC8GQXOX2GgbsKqy1wQVMEI9GXFiakfYicvXQDAEdhIt+PERyekQWaaowRFgoSYq
 BnedSwNlIDjy4fbohX+u1Kolx+8UKQHBlb9ieD7egcfpuBz/sbHY5j8HVl+OC+qMyU9nyqWqZ
 v73/pY77FU1caY0ED4QY28X0PqJnAwVmUigamsLmCirCfpUpatEd1LY7TGUrfazrw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 10, 2021 at 9:38 AM Krzysztof Kozlowski
<krzysztof.kozlowski@canonical.com> wrote:
> --- a/drivers/clk/socfpga/Kconfig
> +++ b/drivers/clk/socfpga/Kconfig
> @@ -1,6 +1,17 @@
>  # SPDX-License-Identifier: GPL-2.0
> +config COMMON_CLK_SOCFPGA
> +       bool "Intel SoCFPGA family clock support" if COMPILE_TEST && !ARCH_SOCFPGA && !ARCH_SOCFPGA64
> +       depends on ARCH_SOCFPGA || ARCH_SOCFPGA64 || COMPILE_TEST
> +       default y if ARCH_SOCFPGA || ARCH_SOCFPGA64

I think the 'depends on' line here is redundant if you also have the
'if' line and the default.

        Arnd
