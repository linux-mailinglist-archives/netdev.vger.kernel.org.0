Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1992E55098A
	for <lists+netdev@lfdr.de>; Sun, 19 Jun 2022 11:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232464AbiFSJtz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jun 2022 05:49:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbiFSJty (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jun 2022 05:49:54 -0400
Received: from mout.kundenserver.de (mout.kundenserver.de [217.72.192.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01B2BAE7C;
        Sun, 19 Jun 2022 02:49:52 -0700 (PDT)
Received: from mail-yw1-f169.google.com ([209.85.128.169]) by
 mrelayeu.kundenserver.de (mreue107 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1MvaSG-1njPnk1Lxm-00sbKj; Sun, 19 Jun 2022 11:49:50 +0200
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-3178ea840easo37691157b3.13;
        Sun, 19 Jun 2022 02:49:50 -0700 (PDT)
X-Gm-Message-State: AJIora+yPInBDqprwK6WMNmb0SjJD964UiOdApSHuiPJ+7TCsWoX/RUC
        atyXIVrgjQbLJtShWQKRB13s2kKcKKI/MUkHQC4=
X-Google-Smtp-Source: AGRyM1t9ul1TMDLrnODbrtmpbMg/VmZyXRzI7rCNUKvT9jPCzauqo8TpsRO1mbG6wZCDJNE0X4tcOtmgDYFJdLII69Y=
X-Received: by 2002:a0d:ca0f:0:b0:317:a2cc:aa2 with SMTP id
 m15-20020a0dca0f000000b00317a2cc0aa2mr5711993ywd.347.1655632189019; Sun, 19
 Jun 2022 02:49:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220616221554.22040-1-ansuelsmth@gmail.com>
In-Reply-To: <20220616221554.22040-1-ansuelsmth@gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Sun, 19 Jun 2022 11:49:31 +0200
X-Gmail-Original-Message-ID: <CAK8P3a103rO9GV+L8cctYJcQBwGDUTVBcn3ii266R-Wa1mGDuw@mail.gmail.com>
Message-ID: <CAK8P3a103rO9GV+L8cctYJcQBwGDUTVBcn3ii266R-Wa1mGDuw@mail.gmail.com>
Subject: Re: [net-next PATCH] net: ethernet: stmmac: remove select
 QCOM_SOCINFO and make it optional
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Networking <netdev@vger.kernel.org>,
        linux-stm32@st-md-mailman.stormreply.com,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:TYqcAKglN1J7k5XSogp0KgIay1+Andt3ZdIz3jS0f57xGHLBodJ
 H7KQecuUyj/CCD+BIniIVv2Id0Wbk4FiLsq1SN296A0mxTzxWf3P+u5lfrBxvTcbLh5zV8B
 Kx7rEpG7cb/doCfPrLFny1Jo6FjMaBFkqpLjMroyet4Ry0CawzLQvJc5wZ9yDxymILYwo0Z
 jSo8lYX3QJbtcNWdduV6A==
X-UI-Out-Filterresults: notjunk:1;V03:K0:YsJC5F1d6EQ=:CmFdCdFrOMuSTAkfmNekxV
 u2h6w8Vt+mJMv/n5g5VZEHfsctv69NeD8UgQGE5OztKQWlpLgdOn654rRTBFJrxKaQq/QJYXB
 fXsFb//K0mvuT+ntKAXVueXs8AKBTrQTzCWzwVrGOE19op+RVn8F+T6ZpLYXb/hYQ7cRWC7Ws
 vaui+j59s7cpbkCC683knDuaeKrCQph2fV1Wj6ETH47d6CdZhhOoDCoG/1RFL7gzKWENCN0jF
 mN2z/l8rkoZAdX7B5Qtwdg0F7kw8sbuytRKvjRa+CsyRD1eQn2QaSi2HCT3NnEbNTVnCp9q0I
 A2kyIx4LUff9rJZc2eQWDh7Hgmac1IM7tWZ7FZYG5yxTtfVDd0ZgtOnQxSBmwIQVwp+nvDP7s
 8j8FL6ufl3W9u0zIP9WBq6595kN5ZzR7mRbAMaQ5KA0UC0GN1g8KyHquvwx38Ops2Y9iISDN7
 prrbc9pjqV3cgW5uruTJXXheZN3P0h1fVPcyH99iZDFo84qhilSkIXoJV50Ld22m/0axoyy8g
 qMfHRe+k2p1ocKgSpImQTqna8QN4k5LRiVxnQTk9AolYN1epEO9/IKM5RPLfDXEhNiAor/fw7
 MKckrvI2JqEAYDdRzkKXoZJb9MbwDDpf/7m1cO7WviUbHwgEe5CwrLllCr/9oMRUh+ApeJUUy
 EDg3CGMoia0wVCxCm7kMEpHgmJLZvpfHsdm2fbmKJQcTJoFRBKZNtI+xWtu5JsWcHN74fQgwL
 IYfwnneKzkDZiSXGISvX4gQbmCqSOMOPNFhDrQ==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 17, 2022 at 12:15 AM Christian Marangi <ansuelsmth@gmail.com> wrote:
>
> QCOM_SOCINFO depends on QCOM_SMEM but is not selected, this cause some
> problems with QCOM_SOCINFO getting selected with the dependency of
> QCOM_SMEM not met.
> To fix this remove the select in Kconfig and add additional info in the
> DWMAC_IPQ806X config description.
>
> Reported-by: kernel test robot <lkp@intel.com>
> Fixes: 9ec092d2feb6 ("net: ethernet: stmmac: add missing sgmii configure for ipq806x")
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/Kconfig | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/stmicro/stmmac/Kconfig b/drivers/net/ethernet/stmicro/stmmac/Kconfig
> index c4bca16dae57..31ff35174034 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/Kconfig
> +++ b/drivers/net/ethernet/stmicro/stmmac/Kconfig
> @@ -83,7 +83,6 @@ config DWMAC_IPQ806X
>         default ARCH_QCOM
>         depends on OF && (ARCH_QCOM || COMPILE_TEST)
>         select MFD_SYSCON
> -       select QCOM_SOCINFO
>         help
>           Support for QCA IPQ806X DWMAC Ethernet.
>
> @@ -92,6 +91,9 @@ config DWMAC_IPQ806X
>           acceleration features available on this SoC. Network devices
>           will behave like standard non-accelerated ethernet interfaces.
>
> +         Select the QCOM_SOCINFO config flag to enable specific dwmac
> +         fixup based on the ipq806x SoC revision.

I think the correct way would have been to use

     depends on QCOM_SOCINFO || COMPILE_TEST

here.

        Arnd
