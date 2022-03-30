Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12A714EC4C7
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 14:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345468AbiC3Mqj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 08:46:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345442AbiC3Mqa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 08:46:30 -0400
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B05A12639;
        Wed, 30 Mar 2022 05:42:06 -0700 (PDT)
Received: from mail-wm1-f52.google.com ([209.85.128.52]) by
 mrelayeu.kundenserver.de (mreue010 [213.165.67.97]) with ESMTPSA (Nemesis) id
 1Mnq4Q-1oOrgK3Xoo-00pNsz; Wed, 30 Mar 2022 14:37:02 +0200
Received: by mail-wm1-f52.google.com with SMTP id 123-20020a1c1981000000b0038b3616a71aso3374610wmz.4;
        Wed, 30 Mar 2022 05:37:02 -0700 (PDT)
X-Gm-Message-State: AOAM5329VsudarNVsU/isj96R066MCE5oM/3x1bNfWfP0EEFUDlMLBvz
        wa45/BoAHiY/lTW1NEMfZjbVJ01WXugIsqBo09U=
X-Google-Smtp-Source: ABdhPJwfbm/9CoKlDpNtm76gvIcQEp3gSMKylwBeJKNMGSZTpVIguvrW0qmNj3vv9gaQXiq1j2JGikp0Afv3xKtctks=
X-Received: by 2002:a1c:f219:0:b0:38c:782c:3bb with SMTP id
 s25-20020a1cf219000000b0038c782c03bbmr4174789wmc.94.1648643822447; Wed, 30
 Mar 2022 05:37:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220330074016.12896-1-krzysztof.kozlowski@linaro.org> <20220330074016.12896-2-krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220330074016.12896-2-krzysztof.kozlowski@linaro.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 30 Mar 2022 14:36:46 +0200
X-Gmail-Original-Message-ID: <CAK8P3a2rjs-_5kcqAz6C3qE=SGUt0JYSyNfyZd2-B6dvaEZNuQ@mail.gmail.com>
Message-ID: <CAK8P3a2rjs-_5kcqAz6C3qE=SGUt0JYSyNfyZd2-B6dvaEZNuQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] dt-bindings: update Krzysztof Kozlowski's email
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     "moderated list:ARM/SAMSUNG EXYNOS ARM ARCHITECTURES" 
        <linux-samsung-soc@vger.kernel.org>,
        DTML <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-nfc@lists.01.org, Networking <netdev@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Krzysztof Kozlowski <krzk@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:NX9yY4uMHG0E9LFC5gh1ZFGm6GY/SJk+3/osNw8K/JV4GnUK4nY
 x1ANy0sl+GqOXKmcrk5eY9Vp6PPT7SDMZNCxm5zVZ4BgUFYYCUzGLvipXE7uvKlWSvzetJ+
 pWS4HIuHCavNs7b5q1qF9nb0puNlrRjigvsxs+LegvegO7UWUmMi1U8JSUB7oFjIOpQ2jpI
 HviknqcBRm7+hskX4xaSg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Auhe9cAV9A0=:Jmz/c2N6UlGWcjtthXjc6Y
 A4KRmjeq/7Dxse2SWXB/GO3SHnbjmWXhZgC7AeXmKCWOxS7Gi9ECms+p9KGZZSm361chfud0i
 MOLs6MFleCrUBErHMnxpmaiw9qUxH2W1f9//tgYlIlAh4kt5VOonVYlsqUDhVaYx8AEVMqqu5
 8AwlsP2ftyhYf29znfths8dQDyEWsxSMpsr5a2IQfH1/zdJXdUB4ULZ9ybnyT8gGsgLfr9g/1
 6JwrIfEegz1w5SgVQgrQqXAe5OOGpPyO54lOyj4XXRdzt47TDzt3jb8VgD2nejDXNWdsU8xrO
 lagk5OqpWCTbGRnoSYQH8uywlrJwyUAvJzU8g8QzEXzdraunxwMCbx6qYe+HgV1cPvdHNY9xN
 4XQ6KuEdB5h+piCRQ+dk3dYEENl53c4e4hPMoXV19GVBfeaRisXJtiBs/D0at6wATm1fRoSfh
 tx9BHrvxDjSmE217ASoMG2Ev+aVIGc2evCGBHMa2JUCWN1Jv4F58ZwuBnZdPtotmuqaCyWofg
 BTmtyai+8SDAFQG+8cxYoPrFAq3TRyxHNVSvNmr7zblBVDTxmlAVB23HSimgiy9Roy4uFqn9r
 aOICQnXDpsRQa3muaXmbJtkQ4Y979FifO1Cf6Qt7aCIvkdxfQ3tXMc3S+tz0pCTTsBdL5oyh6
 DH2VEqscKNj9rTpFg3geDzOfvfqJnGpE0H9+269VpMiacqKiLsCkBj78p0cptAUntxBc=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 30, 2022 at 9:40 AM Krzysztof Kozlowski
<krzysztof.kozlowski@linaro.org> wrote:
>
> From: Krzysztof Kozlowski <krzk@kernel.org>
>
> Krzysztof Kozlowski's @canonical.com email stopped working, so switch to
> generic @kernel.org account for all Devicetree bindings.
>
> Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>

Acked-by: Arnd Bergmann <arnd@arndb.de>
