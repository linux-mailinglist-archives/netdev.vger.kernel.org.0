Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 459EF348299
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 21:09:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238163AbhCXUJO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 16:09:14 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:49945 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238158AbhCXUI5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 16:08:57 -0400
Received: from mail-oo1-f49.google.com ([209.85.161.49]) by
 mrelayeu.kundenserver.de (mreue106 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1MrPVJ-1m2uPY1NxP-00oX6h; Wed, 24 Mar 2021 21:08:55 +0100
Received: by mail-oo1-f49.google.com with SMTP id i20-20020a4a8d940000b02901bc71746525so6130827ook.2;
        Wed, 24 Mar 2021 13:08:55 -0700 (PDT)
X-Gm-Message-State: AOAM531oqSU9AkTn+Wkrjyizeb+UsjzJj7DyMRNM93BHbYDMu+QBKBUV
        KDvvji6MSCA7cMyNl4AYxBakOrLX+07Mz68qA/A=
X-Google-Smtp-Source: ABdhPJybTxidmqfUgZw7W8iZwqTPZdKNPoMY0wKBfMJ7hCptmQ98ROSV9GMgRQY6K8Yt9kjE9ik3niJWJDsWSHTT3bQ=
X-Received: by 2002:a4a:304a:: with SMTP id z10mr4221190ooz.26.1616616533996;
 Wed, 24 Mar 2021 13:08:53 -0700 (PDT)
MIME-Version: 1.0
References: <20210322104343.948660-1-arnd@kernel.org> <20210322104343.948660-5-arnd@kernel.org>
In-Reply-To: <20210322104343.948660-5-arnd@kernel.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 24 Mar 2021 21:08:38 +0100
X-Gmail-Original-Message-ID: <CAK8P3a2K-r9ERQxo-UiKpn-MLTu6ORM8FSooh1vXOtrQoU9kzQ@mail.gmail.com>
Message-ID: <CAK8P3a2K-r9ERQxo-UiKpn-MLTu6ORM8FSooh1vXOtrQoU9kzQ@mail.gmail.com>
Subject: Re: [PATCH net-next 5/5] vxge: avoid -Wemtpy-body warnings
To:     Networking <netdev@vger.kernel.org>, Jon Mason <jdmason@kudzu.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:fijI6r4YMqbAe5M2kVyLTB6NqcK5h28eQt8SXSkYoJnuGFZqnDH
 4bdZ1UUUptABeCEOHZGh5py8JpkpPM2RP5NBHp6DQww0crfyMEZe3nx6QEk8RUfV3AYcEAA
 2LQlwmRGIWnXEFaUq6ky+Dv7jnsVp0xsgy5bt1omidvTJrQAm2odgMe+bsXdbMxECELqyoS
 qCYexD8ji5YR3YIAdFxiA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:vvtep7z6KLw=:ewumsrakVQjAmz3xOBLYH0
 Y77ofFhvY04rszMboXnmGntYA4pv0DM+XCHKH0M+ET2hwb3lB0zdJT1NfMpJsj2JIErzGYyLt
 DlmNvCa5C2jvpFbswg+R2rc2YDSIEj2PqaEybLNMRZjGBhjRALyJV6xBsNsI8+3NkRfmuwweI
 q/pBWfutZfamnjsCmvKHMhjYe/1gUNibaRsShDA7s+ryJO+18jplyEGZbQ1wzto2bcfQhcURs
 lEzqhJFu1BlqhfEeMJS1Bef9Vq3XAkgv13TZBTejcL+oeuWLJJ881XR9/Mi9ysNEWz42Hll8p
 +am6K9R18edg0/k2qcNbMITQ7BmcVI4dflqomIiNRGiXlguCLt52B5TiWi2/+yu8nf75LwaRC
 aH9yioTKvMqlfTv4Hyysc2CoCiLfS3vg+2wlBKxtdnypsDxkyCGkzNasvjjBFx1Ll0uWw1c4g
 az6z4aziMW1TMBMXvB5HuJvZmpQ2AYY=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 22, 2021 at 11:43 AM Arnd Bergmann <arnd@kernel.org> wrote:
>
> From: Arnd Bergmann <arnd@arndb.de>
>
> There are a few warnings about empty debug macros in this driver:
>
> drivers/net/ethernet/neterion/vxge/vxge-main.c: In function 'vxge_probe':
> drivers/net/ethernet/neterion/vxge/vxge-main.c:4480:76: error: suggest braces around empty body in an 'if' statement [-Werror=empty-body]
>  4480 |                                 "Failed in enabling SRIOV mode: %d\n", ret);
>
> Change them to proper 'do { } while (0)' expressions to make the
> code a little more robust and avoid the warnings.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Please disregard this patch, I was accidentally building without -Wformat and
failed to notice that this introduces a regression. I'll send a new
version after
more testing.

       Arnd
