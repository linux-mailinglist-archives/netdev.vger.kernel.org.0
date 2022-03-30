Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1DC4EC4C2
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 14:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345118AbiC3Mpj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 08:45:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345617AbiC3Mp3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 08:45:29 -0400
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9CDDDE09E;
        Wed, 30 Mar 2022 05:39:31 -0700 (PDT)
Received: from mail-wr1-f52.google.com ([209.85.221.52]) by
 mrelayeu.kundenserver.de (mreue012 [213.165.67.97]) with ESMTPSA (Nemesis) id
 1N7QM9-1o5ovQ2itB-017lGA; Wed, 30 Mar 2022 14:39:17 +0200
Received: by mail-wr1-f52.google.com with SMTP id u3so29132293wrg.3;
        Wed, 30 Mar 2022 05:39:17 -0700 (PDT)
X-Gm-Message-State: AOAM531sPV1KzqPCMshJxghwfovqDHM0NHU7gxPLY+1i2/ebjvrZpNni
        npNOE7s4ARcxXfstJQYY8ZL6j/s0BuO9+u4ltbs=
X-Google-Smtp-Source: ABdhPJxd37z3iG058b579CB0d3NUHesbaO46TxDB9z29hKBcw+jTvNoOe7ONXZ919cmcCM5Yjl3fkFPpxL4e20NcvX8=
X-Received: by 2002:a5d:6505:0:b0:205:9a98:e184 with SMTP id
 x5-20020a5d6505000000b002059a98e184mr31849599wru.317.1648643957284; Wed, 30
 Mar 2022 05:39:17 -0700 (PDT)
MIME-Version: 1.0
References: <20220330074016.12896-1-krzysztof.kozlowski@linaro.org> <20220330074016.12896-3-krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220330074016.12896-3-krzysztof.kozlowski@linaro.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 30 Mar 2022 14:39:01 +0200
X-Gmail-Original-Message-ID: <CAK8P3a3a4CqYgKzvusHW4ZXF7dmTjOdzq1-RoXqpnvicH1hxmw@mail.gmail.com>
Message-ID: <CAK8P3a3a4CqYgKzvusHW4ZXF7dmTjOdzq1-RoXqpnvicH1hxmw@mail.gmail.com>
Subject: Re: [PATCH 2/2] MAINTAINERS: update Krzysztof Kozlowski's email to Linaro
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
X-Provags-ID: V03:K1:g7bW1TlYfy/Va9UPxcKRLWPMu9Pu4pj+gdgaactc3MYU8lzYpwX
 DTJEJVlNwiCr+CXbE6zLapXE191Zg8nfhY93tyiQfAY6gN0SgbDtwKc5r1b04LBXW6C8Djg
 2TcifUip3IATzFlLdUdCdxPxnHNAWWI9FXjGYrzBRB8zPRNW5jYEOfy+qgBr3pfmMIFLo+b
 vFdJbqDEQw8P+pGa25IsQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:LGBTjLORL3c=:wSs/A9iws+khjz1N14El4I
 ZzDdQz5th9S/3m7grUPqDsbFONCNMBjy+9agHUE62PDNVLLemLUWgiwJD8mDwN4m+OmcGvYtt
 AxbZoq2FifLZXr/MUNBcw7WsyB+XJcta4IL2AC9EYRzuEYl3u9exsBk914VoFKy5q76BtgbRF
 JQq9oyo4SJFlMZJisQzl4ZcvkqyS4rVK4kXTpPads6rU2Ru2j2icO5thmWo7PP6phTuLtBOvC
 uQyd0YKi/E3lz5rYyQbORlDCVc6S2UrMzD+r/ylJJ6rNM/36eMV7EENon3efBBhWc4bxZ/wrT
 8ZZUfxxi2CsyPz4Y/gNKO0yCrS5BVUxrZeZjmibcvHjLfYRGk+n+8fOzhe8ti7QMV/oV0Vzq0
 pp3YvOmf5GdRj2osglCfdp5zbaz0UiexJwwq2mjkAzHBryepMego6eWUD/2ywYG52tKbr20gQ
 8Vq9oHHcipAJmK/NUc86ukBy8Hk4vyGzdLE+ws5LRx4bRcKKlrXrzkfqNXA/lvVkVRCAcy9+c
 Di92Xpj7mgYwIy2mXthtGTM0sFmY9BSvWAtwZPrZibf0D6Z1eZ2GXPgaA9bKdT82E0W/jaH1C
 1EnIweybyd07nSHQuLtK6urxyvDx94Pa/qWgU0lNw+Vudyh6btEPw/WcDEiPqyL2iJFAJC++J
 +C8F0rivv3p4P/H8Qv6rwP30BnmBfpk03eY8LI8pCWxG0coTIo9T6EcGZdeCAstOL5xlvdVPh
 EcRXu4b2e0az0nkFTAhNHJgoEWQOqK9vDSBO6UguYGjhNu2R25ZgBXIJRUUHFhIevzJ/MuNSU
 ed+3SJk7/o/ubqri9plJobPUi0Ehh+C8WiiTr0HvFsdb4Akjp8=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
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
> Use Krzysztof Kozlowski's @linaro.org account in maintainer entries.
>
> Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>

Acked-by: Arnd Bergmann <arnd@arndb.de>

I usually merge maintainer file changes as bugfixes to avoid losing emails.
In this case, I suppose it's not urgent though because both emails keep
working, so I'd suggest putting this one in your normal 'soc' branch for 5.19.

      Arnd
