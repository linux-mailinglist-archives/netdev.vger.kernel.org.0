Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 373B54EB573
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 23:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235289AbiC2VwC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 17:52:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235237AbiC2VwB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 17:52:01 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F088349FB4
        for <netdev@vger.kernel.org>; Tue, 29 Mar 2022 14:50:17 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id k21so32614462lfe.4
        for <netdev@vger.kernel.org>; Tue, 29 Mar 2022 14:50:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=elHZ1U/qS9oyBczDEnD06JHYMXv++A28wW+dRPj5/FM=;
        b=ryRiYFpZ6FEavElDmV9F83jE3e7+WBpmTPOwMsmM+2pEW2CXbS0c2URzQRsIPvfnFr
         st43gfbtB4fFbdbek/AuyB/ld1I6f/Uht+A2fqI0f/FMuXp8JyCtjGs3NQu/FY+zGWl9
         dtYp3QnGwOyiP/2sGCWavH0J2QUYoIQq/CC5Tqoeu4YR4o8Fes833oPdCH3ItbKTJvjS
         t5W5aWzUeES07e7omeMN+C6Ec0AuYtX5UH2qMuqh0RP2Z1cT04Q7/cN0UtrfTgeX2Zep
         c6dvv6DratwUyKfl7NH1TFOfu96dqwarzbrWCyfWMKpM86EdnhekKMUzXBb3m71cKJUF
         8lhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=elHZ1U/qS9oyBczDEnD06JHYMXv++A28wW+dRPj5/FM=;
        b=ughGmYTCN6rylTde6IHp5hRA/T4WcrDbW3n5fm94gcjGRIdua7+MBDRb+h6uGLEMF3
         fOVUAOEJNauuqKMXO56+RcJTtJv1sG7CvCG//SRgENWzVEGTVrym0ndXbERRGjLE2UQV
         UtmTJCZRUTym2zvGfjsp/zyxIZ8r+FwZImX9FdVtoCUXerYbzIRJdnHAiO2fYZFUTCFz
         qIVjj73ZCZPll7fLyhVwDddPhcsOJgpLEGvhrWNSJG2TXA1uGij7fIrpNNOPYHrmKlTr
         jVVUewgBzE6r9Z/z4BA99a+oV+/5d5v9T7UwnrwIlJwRBAt5Dv6lStV3Cp0FJta8t+fK
         mHNg==
X-Gm-Message-State: AOAM533JKZuinN3uiyNQBaBEJH+RsFBRXEaEVvyFrXVEYnwAA6gsYlWL
        0o/I9GzZtr8MqyttrFrqB7wpa2Tx+cMVOGUt1xVfFQ==
X-Google-Smtp-Source: ABdhPJxTdyoaC2t6velSBqAvFoUcLvu+5+4F2Ly0GJIzOM07bL7lKXFQh14MMsleCXEMKa4HrqDwdZn04b3VJCrgpF4=
X-Received: by 2002:a19:651d:0:b0:44a:b88a:b0b1 with SMTP id
 z29-20020a19651d000000b0044ab88ab0b1mr1360217lfb.380.1648590615853; Tue, 29
 Mar 2022 14:50:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220329212946.2861648-1-ndesaulniers@google.com>
In-Reply-To: <20220329212946.2861648-1-ndesaulniers@google.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Tue, 29 Mar 2022 14:50:04 -0700
Message-ID: <CAKwvOdmsnVsW46pTZYCNu-bx5c-aJ8ARMCOsYeMmQHpAw3PtPg@mail.gmail.com>
Subject: Re: [PATCH] net, uapi: remove inclusion of arpa/inet.h
To:     Jon Maloy <jmaloy@redhat.com>, Ying Xue <ying.xue@windriver.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Masahiro Yamada <masahiroy@kernel.org>
Cc:     Nathan Chancellor <nathan@kernel.org>, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 29, 2022 at 2:29 PM Nick Desaulniers
<ndesaulniers@google.com> wrote:
>
> Testing out CONFIG_UAPI_HEADER_TEST=y with a prebuilt Bionic sysroot
> from Android's SDK, I encountered an error:
>
>   HDRTEST usr/include/linux/fsi.h
> In file included from <built-in>:1:
> In file included from ./usr/include/linux/tipc_config.h:46:
> prebuilts/ndk/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/include/arpa/inet.h:39:1:
> error: unknown type name 'in_addr_t'
> in_addr_t inet_addr(const char* __s);
> ^

Oh, this might not quite be the correct fix for this particular issue.

Cherry picking this diff back into my Android kernel tree, I now observe:
  HDRTEST usr/include/linux/tipc_config.h
In file included from <built-in>:1:
./usr/include/linux/tipc_config.h:268:4: error: implicit declaration
of function 'ntohs' [-Werror,-Wimplicit-function-declaration]
                (ntohs(((struct tlv_desc *)tlv)->tlv_len) <= space);
                 ^

Is there more than one byteorder.h? Oh, I see what I did; ntohs is defined in
linux/byteorder/generic.h
not
usr/include/asm/byteorder.h
Sorry, I saw `byteorder` and mixed up the path with the filename.

So rather than just remove the latter, I should additionally be adding
the former. Though that then produces

common/include/linux/byteorder/generic.h:146:9: error: implicit
declaration of function '__cpu_to_le16'
[-Werror,-Wimplicit-function-declaration]
        *var = cpu_to_le16(le16_to_cpu(*var) + val);
               ^

Oh?

>
> This is because Bionic has a bug in its inclusion chain. I sent a patch
> to fix that, but looking closer at include/uapi/linux/tipc_config.h,
> there's a comment that it includes arpa/inet.h for ntohs; but ntohs is
> already defined in include/linux/byteorder/generic.h which is already
> included in include/uapi/linux/tipc_config.h. There are no __KERNEL__
> guards on include/linux/byteorder/generic.h's definition of ntohs. So
> besides fixing Bionic, it looks like we can additionally remove this
> unnecessary header inclusion.
>
> Link: https://android-review.googlesource.com/c/platform/bionic/+/2048127
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> ---
>  include/uapi/linux/tipc_config.h | 4 ----
>  1 file changed, 4 deletions(-)
>
> diff --git a/include/uapi/linux/tipc_config.h b/include/uapi/linux/tipc_config.h
> index 4dfc05651c98..b38374d5f192 100644
> --- a/include/uapi/linux/tipc_config.h
> +++ b/include/uapi/linux/tipc_config.h
> @@ -43,10 +43,6 @@
>  #include <linux/tipc.h>
>  #include <asm/byteorder.h>
>
> -#ifndef __KERNEL__
> -#include <arpa/inet.h> /* for ntohs etc. */
> -#endif
> -
>  /*
>   * Configuration
>   *
>
> base-commit: 5efabdadcf4a5b9a37847ecc85ba71cf2eff0fcf
> prerequisite-patch-id: 0c2abf2af8051f4b37a70ef11b7d2fc2a3ec7181
> --
> 2.35.1.1021.g381101b075-goog
>


-- 
Thanks,
~Nick Desaulniers
