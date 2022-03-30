Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78C384EBAA1
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 08:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243186AbiC3GNE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 02:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbiC3GND (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 02:13:03 -0400
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E886631519;
        Tue, 29 Mar 2022 23:11:18 -0700 (PDT)
Received: from mail-wm1-f43.google.com ([209.85.128.43]) by
 mrelayeu.kundenserver.de (mreue010 [213.165.67.97]) with ESMTPSA (Nemesis) id
 1MWAf4-1nWaIZ15tS-00XZp7; Wed, 30 Mar 2022 08:11:17 +0200
Received: by mail-wm1-f43.google.com with SMTP id n63-20020a1c2742000000b0038d0c31db6eso2775177wmn.1;
        Tue, 29 Mar 2022 23:11:17 -0700 (PDT)
X-Gm-Message-State: AOAM530XG1CXmZHwqZkFf79yTGtCz2FiZI5tVknai6QsFKVq3x2EWgaS
        CBkda3CwqEWt6KKmn2UZanEk89/K9KYp8M6lCfg=
X-Google-Smtp-Source: ABdhPJyuPUGU8Qpas92kWjeTSOPAYwK+c1Chh44bmkvoaDODFG6UE6Eq5BKcFaIwfARg8nJqf/AuHCf0Bo45fTjs1mA=
X-Received: by 2002:a1c:f219:0:b0:38c:782c:3bb with SMTP id
 s25-20020a1cf219000000b0038c782c03bbmr2776770wmc.94.1648620676900; Tue, 29
 Mar 2022 23:11:16 -0700 (PDT)
MIME-Version: 1.0
References: <20220329212946.2861648-1-ndesaulniers@google.com>
 <CAKwvOdmsnVsW46pTZYCNu-bx5c-aJ8ARMCOsYeMmQHpAw3PtPg@mail.gmail.com>
 <CAKwvOdnJB5u96fm1w-R-VUayvhq58EQeqZst32NDRscK17Z8pQ@mail.gmail.com>
 <CAKwvOdmYzH91bzNus+RcZGSgCQGY8UKt0-2JvtqQAh=w+CeiuQ@mail.gmail.com> <CAK8P3a37gvycJ4zbeVvD_=6Npuep52VEP7CrgS-_8y6OXK_U3Q@mail.gmail.com>
In-Reply-To: <CAK8P3a37gvycJ4zbeVvD_=6Npuep52VEP7CrgS-_8y6OXK_U3Q@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 30 Mar 2022 08:11:00 +0200
X-Gmail-Original-Message-ID: <CAK8P3a2RO7-SHKfe7b_LcG82gkca10c4fCJmjD_ToSP1Xm-yDA@mail.gmail.com>
Message-ID: <CAK8P3a2RO7-SHKfe7b_LcG82gkca10c4fCJmjD_ToSP1Xm-yDA@mail.gmail.com>
Subject: Re: [PATCH] net, uapi: remove inclusion of arpa/inet.h
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        tipc-discussion@lists.sourceforge.net,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        llvm@lists.linux.dev, David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:YF6SjcJZfDOI/0vYXcVbo63IKe8nuuPko6gj1+kUmskp2dv65RH
 yZ8Lexk4hsiM3l4GU1eiy+qRAFWuvBuqH/2gVE+KeKu6YgRNLybgXcx3f3125eDibtetDcD
 nKkc/NizrJ4BYZSv5JundQi01DURuS/uuqpFu6OUN+TNlivQCcf1MuQ2xRdFdwfNLQnzjeW
 hddVItmaD25mwHtGlILUQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:XuZ0q69NuVI=:fFPeBZXWIvHwmGDCcWoE0F
 0pnVkZOLZkobfTLoyOUdg3dlOL2BpUCYwdG9fnMVBgKQdY7e2Npqh8sVMsI2Y3UlRDllONSqx
 X5ZEeILYy1chkpOGeW2xHZw2TSADAmR1MnILEMzWSFKm7puPzSyuUH/J8de5WbdGqHvMLuZdy
 4+LrRZNqI5dYSkm67tfKBhE7FcSBIKvd7RlZ6wo+KfNeRvjydGw+CEa6sov+JHEMUNHnd0gsB
 PyWF2WlpRxgndKcShdMKsycs48g9NjiqX4k0YA8hPdI08Iq7hi0e/NtNtwt8I8ebErU3CSeVD
 hC3JJXXbJQJI3NmHZg7E7ixa5MwoXNH8BY/bvIri+L1yjL4s1ooLZee5KJQEZRTGZUHL7NZOr
 0PuRNbkmKHBbTXOI59f2zQzH9C++t9Lksk1X0vmhJGgsqGt7Gfgm644HIfb9JH7uvPC5VtMv9
 4pT0e3M5FRyjcEspdvii2AWm09YoelG8Xw5l0qqpHvxl8ftQVAmOLR5xkPZRTHPDDhcuwLXbe
 y8uqn+LSBHNx+apQTIJm5bq+uDQ3VUOBuAv6z4VEyuF6ND1j6IEiFOMm57lZ1r4FZst39iYiN
 nfKdQugn4xF7ZX600IX9cCio3OaZ3txGZf3j04bA12Gw0ImHFyu74tIee2Gz/xYLkVzccLhDz
 yZuvAwuA+fWoL6x48PLQniVV8t3CuQC7oP+sZjrGSb1Ahski7FBmCDfn1hbmHGAas+X3gGTm6
 4ysH0RatHKdgaUVTKcT+7MRVzRnLqn4J+7kqSL6po6tnhaI0j/TLUIDkceHhO0jm7zQo8Nrg+
 xHrTiJp+V2Fwo4w33BfjBv9Ep4O6XVf0A5wEkA/iSnpVE+Se10=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 30, 2022 at 8:08 AM Arnd Bergmann <arnd@arndb.de> wrote:
> On Wed, Mar 30, 2022 at 12:26 AM Nick Desaulniers
> <ndesaulniers@google.com> wrote:
> > On Tue, Mar 29, 2022 at 3:09 PM Nick Desaulniers <ndesaulniers@google.com> wrote:
> > ```
> > diff --git a/include/uapi/linux/byteorder/little_endian.h
> > b/include/uapi/linux/byteorder/little_endian.h
> > index cd98982e7523..c14f2c3728e2 100644
> > --- a/include/uapi/linux/byteorder/little_endian.h
> > +++ b/include/uapi/linux/byteorder/little_endian.h
> > @@ -103,5 +103,8 @@ static __always_inline __u16 __be16_to_cpup(const __be16 *p)
> >  #define __cpu_to_be16s(x) __swab16s((x))
> >  #define __be16_to_cpus(x) __swab16s((x))
> >
> > +#define htonl(x) __cpu_to_be32(x)
> > +#define htons(x) __cpu_to_be16(x)
> > +#define ntohs(x) __be16_to_cpu(x)
> >
>
> This is unfortunately a namespace violation, you can't define things in uapi
> headers that conflict with standard library interfaces.

nevermind, I just saw the thread continues and you arrived at a good solution
withusing the __cpu_to_be16() etc directly.

       Arnd
