Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA2B9534B89
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 10:19:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346787AbiEZISS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 04:18:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346742AbiEZISH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 04:18:07 -0400
Received: from mout.kundenserver.de (mout.kundenserver.de [217.72.192.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFE9B562D8;
        Thu, 26 May 2022 01:17:35 -0700 (PDT)
Received: from mail-yb1-f169.google.com ([209.85.219.169]) by
 mrelayeu.kundenserver.de (mreue109 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1MFsd7-1o3AAb04Tf-00HRBt; Thu, 26 May 2022 10:17:34 +0200
Received: by mail-yb1-f169.google.com with SMTP id l32so1663992ybe.12;
        Thu, 26 May 2022 01:17:33 -0700 (PDT)
X-Gm-Message-State: AOAM532Z5V4zQtqYHsuqP6Uw/frzKDffJuaNZs3QC7S85FrCTpXtmgnm
        sbUOkrWyyj9Y/Hm/P047eGkygjO+k7+wKDh2YWY=
X-Google-Smtp-Source: ABdhPJzzDGfRDZzZlBYmxCfbGw+1dzm4g7liyEpEudmbi7VqC5LKJWZl53KUZgIAAT3HgLquslAgQXrWoCBOPsPKOiI=
X-Received: by 2002:a25:31c2:0:b0:641:660f:230f with SMTP id
 x185-20020a2531c2000000b00641660f230fmr34286510ybx.472.1653553052355; Thu, 26
 May 2022 01:17:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220519031345.2134401-1-kuba@kernel.org> <f84c4cb17eebe385fe22c3fc4563645742269d46.camel@kernel.crashing.org>
 <alpine.DEB.2.22.394.2205260933520.394690@ramsan.of.borg>
In-Reply-To: <alpine.DEB.2.22.394.2205260933520.394690@ramsan.of.borg>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 26 May 2022 10:17:14 +0200
X-Gmail-Original-Message-ID: <CAK8P3a1z5_QBMq+X53wN=xP4_00ahrQDpz7Kd3GJCK-9Mn9AQQ@mail.gmail.com>
Message-ID: <CAK8P3a1z5_QBMq+X53wN=xP4_00ahrQDpz7Kd3GJCK-9Mn9AQQ@mail.gmail.com>
Subject: Re: [PATCH net-next] eth: de4x5: remove support for Generic DECchip &
 DIGITAL EtherWORKS PCI/EISA
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>, sburla@marvell.com,
        vburru@marvell.com, aayarekar@marvell.com,
        Arnd Bergmann <arnd@arndb.de>, zhangyue1@kylinos.cn,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        "open list:BROADCOM NVRAM DRIVER" <linux-mips@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Parisc List <linux-parisc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:3X2MjSsmTV7ka0ZvyOepTqBLU7mV2A7d56BGjf3KN7zNGh99L+E
 EI/eIii5HFrvfuzxiAP9EfgQoGmoXYBZ0qvgzob4/vdsia4U1r/A0cW4GMt90N0a92VgFEU
 AlQgD1dkIt88WjVCwWxpOi2f5oF1NyVOAL3p7swZa2VlHTVq5h19f/a8bv0SFevhHHAQW5J
 DHgd6yDAPXYIvS/XV3bNg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:6UpEfxT5MOM=:S2CG52gRh8yim9GeteJSBV
 QD68/lh6zvVgJQ27D10E9p88s2Rnh4/jlBXO49cWpC3DcQnLWJnOyb2TXLAlwpB//qT7Rqh/e
 7sHjHhQkxenXyWHYjmEEWrA1jFuxqefjbm7HFyqVdK0YVALNuCeW04Mf6NfsBS7+aPwCHIt1/
 pxKfqO5y4ZrT1LWKoohJ+pECrsUi658vrQ+pdtocSu7VXuy7NvUvZKd+mA0u0vpxohSc4fOXH
 QyuRITIB8f4RyNH46AywuGR2CURa7bLSO6ueP+lgpqHbRe7VDcxQ39TxocraeKSAYmkD2SI7g
 GX7UQnTHkHhKvBg8sFmkd41gmm/uddtjnCzA8A+bNu1al6H1cYTBqFRruXBPWK573Gt6/4Tql
 UFJJ31xRXi5Bt02qeePiPjn7CWY5QLx/ICFAUWUEpb8GCzvouhUmD4PexMWII28StK8IIcGEQ
 PR+aSIabd6+4ku/7HqkGhuiskJ42Uc5l9hlgwF7a7yoECNElUXHoUCuFtvUwqKSMBMuB+XP4G
 wNisB1mdR7vuIKwjxdlIDqC3pLrGubtKk/MvB68zMT04RKCp1ocaqgBqE2vhf1ZtseCP5KcLR
 RObE3725OZ1DvM8nciT2HorItgZhlkY6h4IEhs/TlYG16MMp+jgD5JAQqzZWUPBqvkboZBE2l
 2jjMmRshNYNHxR04xiek8nvE+8lkSNwEeOZUj1QSE2mllkwj8Q4kgEokPBseKZ2SuKj3ns+BQ
 rEJJ7NNacGBDLnVX1sKNhvHXbucK5JiJOQZjEeh3nxlX/eyAcwcZXWGwgmRs+7WaQ6QfwQowf
 8nXfwk9GzPRB6z8n8XxjI2btaQ0pyGRDby3KFmGUf4LIcmza2elrp/DReAdMrsZIE5l/RNjN6
 KHf4FUvGOlJrC05wQc6z4POT3q4VJwzzuCielJN0o=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 26, 2022 at 9:43 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> On Sat, 21 May 2022, Benjamin Herrenschmidt wrote:
> > On Wed, 2022-05-18 at 20:13 -0700, Jakub Kicinski wrote:
> >> Looks like almost all changes to this driver had been tree-wide
> >> refactoring since git era begun. There is one commit from Al
> >> 15 years ago which could potentially be fixing a real bug.
> >>
> >> The driver is using virt_to_bus() and is a real magnet for pointless
> >> cleanups. It seems unlikely to have real users. Let's try to shed
> >> this maintenance burden.
> >>
> >> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> >
> > Removing this driver will kill support for some rather old PowerMac
> > models (some PowerBooks I think, paulus would know). No objection on my
> > part, though. I doubt people still use these things with new kernels
> > but ... who knows ? :-)
>
> Aren't these PCI, and thus working fine with the PCI-only DE2104X
> (dc2104x) or TULIP (dc2114x) drivers?
>
> IIRC, I've initially used the de4x5 driver on Alpha (UDB/Multia) or PPC
> (CHRP), but switched to the TULIP driver later (that was before the
> dc2104x/dc2114x driver split, hence a loooong time ago).

The PCI device IDs say this is correct: there are four IDs in the
de4x5 driver, all of which are also listed in one of the two other
drivers.

      Arnd
