Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4354EBA96
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 08:09:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243164AbiC3GKe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 02:10:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbiC3GKc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 02:10:32 -0400
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4765D15A1E;
        Tue, 29 Mar 2022 23:08:44 -0700 (PDT)
Received: from mail-wr1-f52.google.com ([209.85.221.52]) by
 mrelayeu.kundenserver.de (mreue010 [213.165.67.97]) with ESMTPSA (Nemesis) id
 1MbAtM-1oAi8I1smO-00bcyB; Wed, 30 Mar 2022 08:08:42 +0200
Received: by mail-wr1-f52.google.com with SMTP id c7so1122052wrd.0;
        Tue, 29 Mar 2022 23:08:42 -0700 (PDT)
X-Gm-Message-State: AOAM5310fkRJtrS6jihAZVBqCBnFjzVrhTxXKfGgxC908b4YF5i7OqYL
        KR+D0++poGqPhrhYK9MbJYIt3fpsSsU9Kd0MTxQ=
X-Google-Smtp-Source: ABdhPJxb3ayTdwP7GbKNqgnIvGjF8ohxETPSVjrIT/ae8J5nVyT7Tv5Q0wb9WsBju9Q+yhSNMby/JlkVM5NhGe611Ew=
X-Received: by 2002:a5d:66ca:0:b0:203:fb72:a223 with SMTP id
 k10-20020a5d66ca000000b00203fb72a223mr33812160wrw.12.1648620522122; Tue, 29
 Mar 2022 23:08:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220329212946.2861648-1-ndesaulniers@google.com>
 <CAKwvOdmsnVsW46pTZYCNu-bx5c-aJ8ARMCOsYeMmQHpAw3PtPg@mail.gmail.com>
 <CAKwvOdnJB5u96fm1w-R-VUayvhq58EQeqZst32NDRscK17Z8pQ@mail.gmail.com> <CAKwvOdmYzH91bzNus+RcZGSgCQGY8UKt0-2JvtqQAh=w+CeiuQ@mail.gmail.com>
In-Reply-To: <CAKwvOdmYzH91bzNus+RcZGSgCQGY8UKt0-2JvtqQAh=w+CeiuQ@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 30 Mar 2022 08:08:25 +0200
X-Gmail-Original-Message-ID: <CAK8P3a37gvycJ4zbeVvD_=6Npuep52VEP7CrgS-_8y6OXK_U3Q@mail.gmail.com>
Message-ID: <CAK8P3a37gvycJ4zbeVvD_=6Npuep52VEP7CrgS-_8y6OXK_U3Q@mail.gmail.com>
Subject: Re: [PATCH] net, uapi: remove inclusion of arpa/inet.h
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Jon Maloy <jmaloy@redhat.com>, Ying Xue <ying.xue@windriver.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        tipc-discussion@lists.sourceforge.net,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        llvm@lists.linux.dev, David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:Y+sOCBA1aykYnTt/I8gB+NYawWvP+FFAV4GoMRVJt4lgJub9nrG
 gIXDCJcfU2IafBz7hhkB2UrGbP2JLZqITBXgj0cGDft8O6Nfn4USZqi9Lgt0dDCB+JM3Wrh
 CeKoV3DLq6Dz8RJhPnd5j+MDBhNnsyeMomGq3A0kdcBpvNg2KcGoPlbdKgEMzUBV9dLxpQw
 KU8s6gJPOlQ/GzgFxJJrw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:gACwt6VXWF4=:v+GG1NbOp+ArW34sQ9lXmm
 1NU0SactVUOddo/Yw+637coktYUQ6v35PX/mI8CqwIJXuF6VPbAUN2awrEfDWEbYycvHdF4kc
 eByepo7ecgmx5o6GpAESWXTQwJ2L/i/MrK08uI0+Aqvqawvdf/887MQm/RyfGPWpp1ce3wfAg
 RLbjbCXjhWvqah6knB+rP5MiRoxuFc3em1dVtLM04EHo0+7Uuy51a4Si63Ls+aaiq0I8+Mrdf
 uG4HIBtSIx+jzSa97FUKl7JDzRT3dgA/0KxSyaqJSFHshRc4PD0DY10a+mWuNM/TiNcAn3aGZ
 sqZxdST5Qs1KNJy/5Rzr2VqsNW/NLTyvvf1kyd2l4vlFZheAcKn2uIjBAfZnzLSaOT1grqJkY
 mYtI5nISLabJNu61xJkT3OAmb+tGvEWF/XCbqHCs3Fwt07gPTVveIElIEdNl2LnYZR9KGKtIg
 khRQCa0ARkF6Pvg98NK2k2vRvIs6QeJI6JFl6bjzElil1/AxojUT/l653jMHNcpXrf4JwaKoZ
 seyWA2Ot8DSS4LIqldAMmaHoTSfvDzwOUuPmp+At1va19eyXsCdRGRQIPrpOfErgCNzOxV7sz
 btzCub3Z83sa1VTlhPkUmqUjL80U4Cgcxx/bOziai+rfWDIi0NB2H4jzXD3Nx5ZLp4VUKgeOn
 Fs6plBoyZDG/BekQMDXJGpbCA8Hvh/L5xFL2W4bCMqwmtbF1qKBmve2vvTDfK67vUcTM=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 30, 2022 at 12:26 AM Nick Desaulniers
<ndesaulniers@google.com> wrote:
> On Tue, Mar 29, 2022 at 3:09 PM Nick Desaulniers <ndesaulniers@google.com> wrote:
> ```
> diff --git a/include/uapi/linux/byteorder/little_endian.h
> b/include/uapi/linux/byteorder/little_endian.h
> index cd98982e7523..c14f2c3728e2 100644
> --- a/include/uapi/linux/byteorder/little_endian.h
> +++ b/include/uapi/linux/byteorder/little_endian.h
> @@ -103,5 +103,8 @@ static __always_inline __u16 __be16_to_cpup(const __be16 *p)
>  #define __cpu_to_be16s(x) __swab16s((x))
>  #define __be16_to_cpus(x) __swab16s((x))
>
> +#define htonl(x) __cpu_to_be32(x)
> +#define htons(x) __cpu_to_be16(x)
> +#define ntohs(x) __be16_to_cpu(x)
>

This is unfortunately a namespace violation, you can't define things in uapi
headers that conflict with standard library interfaces.

         Arnd
