Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B4F84EB5DD
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 00:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236922AbiC2W2K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 18:28:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236622AbiC2W2I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 18:28:08 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA891B0D24
        for <netdev@vger.kernel.org>; Tue, 29 Mar 2022 15:26:23 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id h7so32744626lfl.2
        for <netdev@vger.kernel.org>; Tue, 29 Mar 2022 15:26:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Eq/hDx8wKMs4js8aHxkHKYQ3P3T4FpD2LhDpEFtVod8=;
        b=nBYJRcr2epLmw7W5jj1DyWNoaJ5PytYBRiMKYL/5744Lo+5+ej7neYHnCHJ4YJqphU
         C5h9ci26W7DViGTe0ndNPnBM4oKxbdfYDOt6SjGf2bUcoaI0RPuAeN7Mbc2ciaNOn3LS
         +iot8PcYUJ5ZZrLmgcpvnZVXJLHooDPQZeC6omwt6phleOd+J+ALSDxuEWCI0UfCFX3N
         78NyjyceETkVbQnm5ptEVrkETKMr6mHVGL7GNHO8spoaU75R2kkGGdghwh3+ktCHpvgp
         1H4tIuOOJ/TQtyn5mnb/Awl39xf2FLcKSvHfstXXb4fS2MThWo3QzUquaKD8DgkxUpmU
         AK1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Eq/hDx8wKMs4js8aHxkHKYQ3P3T4FpD2LhDpEFtVod8=;
        b=0JeAL7gnG7TweN0WSD9394tdmPyvqxqpI+64tc32qxXQSYcmIB0MHqbQjXZGPShbOI
         MuT6P5dK/7wKAQDJZPdrkZrHzsdpPXkWpVZRsLf8zaALm/1Ro1peAPu757WRjNTq18Mf
         Ms0oNKeK6JGTGIklVns8/SEfVis6PXdr8lr1hvYPsEcQcxOBzCnpZkDDA7IujKtOMJsD
         cR37RfSV6ZNylMG6iIgpQvnG1Zdpjotlmy/HItYP61F82NR22kmEUx851cwrCGE8jx8i
         pxVTVJcL8G6W7BMm7Cj3VGPpj3ZVEJV0sqNgrSQhkZOd8FGh/qpAwbPjzfecoTHcp0X5
         I7KA==
X-Gm-Message-State: AOAM532fbzHTow7hAYzCFbI2myxOC8bS6KFRZOhtK6Ed8Cj9/9RiJwHs
        lHS1hWcEG+XKCSAYIVWbxYVW35PxiabpubvcqFDqng==
X-Google-Smtp-Source: ABdhPJz3fitcJ9qiEhta3zosFy6t5FScI80eSjKMeWv3ImRq4Hse8lAvC4NsmaCiNOkGV9qvbZvQvPgFok3UlpIpuZg=
X-Received: by 2002:a05:6512:108b:b0:44a:6dc2:ffeb with SMTP id
 j11-20020a056512108b00b0044a6dc2ffebmr4701180lfg.184.1648592781335; Tue, 29
 Mar 2022 15:26:21 -0700 (PDT)
MIME-Version: 1.0
References: <20220329212946.2861648-1-ndesaulniers@google.com>
 <CAKwvOdmsnVsW46pTZYCNu-bx5c-aJ8ARMCOsYeMmQHpAw3PtPg@mail.gmail.com> <CAKwvOdnJB5u96fm1w-R-VUayvhq58EQeqZst32NDRscK17Z8pQ@mail.gmail.com>
In-Reply-To: <CAKwvOdnJB5u96fm1w-R-VUayvhq58EQeqZst32NDRscK17Z8pQ@mail.gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Tue, 29 Mar 2022 15:26:09 -0700
Message-ID: <CAKwvOdmYzH91bzNus+RcZGSgCQGY8UKt0-2JvtqQAh=w+CeiuQ@mail.gmail.com>
Subject: Re: [PATCH] net, uapi: remove inclusion of arpa/inet.h
To:     Jon Maloy <jmaloy@redhat.com>, Ying Xue <ying.xue@windriver.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Masahiro Yamada <masahiroy@kernel.org>
Cc:     Nathan Chancellor <nathan@kernel.org>, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 29, 2022 at 3:09 PM Nick Desaulniers
<ndesaulniers@google.com> wrote:
>
> On Tue, Mar 29, 2022 at 2:50 PM Nick Desaulniers
> <ndesaulniers@google.com> wrote:
> >
> > On Tue, Mar 29, 2022 at 2:29 PM Nick Desaulniers
> > <ndesaulniers@google.com> wrote:
> > >
> > > Testing out CONFIG_UAPI_HEADER_TEST=y with a prebuilt Bionic sysroot
> > > from Android's SDK, I encountered an error:
> > >
> > >   HDRTEST usr/include/linux/fsi.h
> > > In file included from <built-in>:1:
> > > In file included from ./usr/include/linux/tipc_config.h:46:
> > > prebuilts/ndk/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/include/arpa/inet.h:39:1:
> > > error: unknown type name 'in_addr_t'
> > > in_addr_t inet_addr(const char* __s);
> > > ^
> >
> > Oh, this might not quite be the correct fix for this particular issue.
> >
> > Cherry picking this diff back into my Android kernel tree, I now observe:
> >   HDRTEST usr/include/linux/tipc_config.h
> > In file included from <built-in>:1:
> > ./usr/include/linux/tipc_config.h:268:4: error: implicit declaration
> > of function 'ntohs' [-Werror,-Wimplicit-function-declaration]
> >                 (ntohs(((struct tlv_desc *)tlv)->tlv_len) <= space);
> >                  ^
> >
> > Is there more than one byteorder.h? Oh, I see what I did; ntohs is defined in
> > linux/byteorder/generic.h
> > not
> > usr/include/asm/byteorder.h
> > Sorry, I saw `byteorder` and mixed up the path with the filename.
> >
> > So rather than just remove the latter, I should additionally be adding
> > the former. Though that then produces
> >
> > common/include/linux/byteorder/generic.h:146:9: error: implicit
> > declaration of function '__cpu_to_le16'
> > [-Werror,-Wimplicit-function-declaration]
> >         *var = cpu_to_le16(le16_to_cpu(*var) + val);
> >                ^
> >
> > Oh?
>
> Should there be a definition of ntohs (and friends) under
> include/uapi/linux/ somewhere, rather than have the kernel header
> include/uapi/linux/tipc_config.h depend on the libc header
> arpa/inet.h?
>
> It looks like we already have
> include/uapi/linux/byteorder/{big|little}_endian.h to define
> __be16_to_cpu and friends, just no definition of ntohs under
> include/uapi/linux/.
>
> Also, it looks like include/uapi/linux/ has definitions for
> __constant_ntohs in
> include/uapi/linux/byteorder/{big|little}_endian.h.  Should those 2
> headers also define ntohs (and friends) unprefixed, i.e. the versions
> that don't depend on constant expressions?

I think the answer is yes; in addition to the diff in this patch, the
following seems to be working:
```
diff --git a/include/uapi/linux/byteorder/little_endian.h
b/include/uapi/linux/byteorder/little_endian.h
index cd98982e7523..c14f2c3728e2 100644
--- a/include/uapi/linux/byteorder/little_endian.h
+++ b/include/uapi/linux/byteorder/little_endian.h
@@ -103,5 +103,8 @@ static __always_inline __u16 __be16_to_cpup(const __be16 *p)
 #define __cpu_to_be16s(x) __swab16s((x))
 #define __be16_to_cpus(x) __swab16s((x))

+#define htonl(x) __cpu_to_be32(x)
+#define htons(x) __cpu_to_be16(x)
+#define ntohs(x) __be16_to_cpu(x)

 #endif /* _UAPI_LINUX_BYTEORDER_LITTLE_ENDIAN_H */
```
I think if I flush out the rest for both endiannesses, then we should
be in good shape?

>
> (I wish there was an entry in MAINTAINERS for UAPI questions like this...)
>
> >
> > >
> > > This is because Bionic has a bug in its inclusion chain. I sent a patch
> > > to fix that, but looking closer at include/uapi/linux/tipc_config.h,
> > > there's a comment that it includes arpa/inet.h for ntohs; but ntohs is
> > > already defined in include/linux/byteorder/generic.h which is already
> > > included in include/uapi/linux/tipc_config.h. There are no __KERNEL__
> > > guards on include/linux/byteorder/generic.h's definition of ntohs. So
> > > besides fixing Bionic, it looks like we can additionally remove this
> > > unnecessary header inclusion.
> > >
> > > Link: https://android-review.googlesource.com/c/platform/bionic/+/2048127
> > > Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> > > ---
> > >  include/uapi/linux/tipc_config.h | 4 ----
> > >  1 file changed, 4 deletions(-)
> > >
> > > diff --git a/include/uapi/linux/tipc_config.h b/include/uapi/linux/tipc_config.h
> > > index 4dfc05651c98..b38374d5f192 100644
> > > --- a/include/uapi/linux/tipc_config.h
> > > +++ b/include/uapi/linux/tipc_config.h
> > > @@ -43,10 +43,6 @@
> > >  #include <linux/tipc.h>
> > >  #include <asm/byteorder.h>
> > >
> > > -#ifndef __KERNEL__
> > > -#include <arpa/inet.h> /* for ntohs etc. */
> > > -#endif
> > > -
> > >  /*
> > >   * Configuration
> > >   *
> > >
> > > base-commit: 5efabdadcf4a5b9a37847ecc85ba71cf2eff0fcf
> > > prerequisite-patch-id: 0c2abf2af8051f4b37a70ef11b7d2fc2a3ec7181
> > > --
> > > 2.35.1.1021.g381101b075-goog
> > >
> >
> >
> > --
> > Thanks,
> > ~Nick Desaulniers
>
>
>
> --
> Thanks,
> ~Nick Desaulniers



-- 
Thanks,
~Nick Desaulniers
