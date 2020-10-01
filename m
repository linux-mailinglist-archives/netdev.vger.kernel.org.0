Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F2FB280AEA
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 01:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733131AbgJAXJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 19:09:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726855AbgJAXJz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 19:09:55 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0625C0613D0
        for <netdev@vger.kernel.org>; Thu,  1 Oct 2020 16:09:55 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id h23so197677pjv.5
        for <netdev@vger.kernel.org>; Thu, 01 Oct 2020 16:09:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0c4sDngFZ83QHOY6hrIOQuCbDbd9L0RjnD0ZUNXCSMI=;
        b=g7SAlLwDXzsKB0Q/bEudflp3IYuyCct1d6qGzLO/5Am18xuQLQnnJEBMZW8a1L6N1K
         vLGGv4/qG3NK11TJiaQLjDwXuRyh4HptrQblG34DqD/IMb3EO2S2Yfu+UbFPiOz0YsXY
         eTDvKe1w2t54z50EFqV/lqp1fFL0ox5RFizkvFLG7xONN4m8KpfOfPImCEnU0+ZXVAr5
         MfBsbaNpZbpq00uBTas3LA1rlilMDHbcWEF9A61p201fmWhJiUqYKi6llgoeN+ygf5ov
         vZYVrHYgd7dEKygvfI1wuusd18u6ru0qXE1700bLutqmPiijJbeubK8L7rK3whDcmnHb
         xKMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0c4sDngFZ83QHOY6hrIOQuCbDbd9L0RjnD0ZUNXCSMI=;
        b=ioP7WiBDY7QFqikR3ikWTtbWUgfHQtKu57Cr57oa8n3fKgFHPtUh990ueVuVbcsShZ
         rPQxTnOMfC/4qM5XC4/9oTxgaGQBc93cHxX7OEPBz64PurfTnjN6++iU33MFk1Adw22J
         kygNRPj5p0U0+vknuBj4ZjKsFcdwqkrBvn7lkMtp5wRqoCfky95+x0a/V5L4+s/vFdMt
         ZGQfZcOAwyevQloxNbkJo13/8uSAuOLWp8ztmXp8UTbNnN0270nu53vtW8qoyFrkYOWi
         FUFwXf1AZetQ2ili02CvyI3f3KIUC0EqOIwoc2hmXb4LZ6o3F66MEhElWTct2Akn+7UV
         FwrQ==
X-Gm-Message-State: AOAM532kC0KygoZ8ZXVcY/SIhqFQjA08rStyQByJmxgJHbIgnes8lcAj
        1lBmR/MMmvWtKpstzr1tWwQbvMgs5AgQDT6eYqBwKYH4JhA=
X-Google-Smtp-Source: ABdhPJyn+Aih1Ex9qnhutouDBAnQIZB1G1mt45Qt2e+ubM0Iy59vX20BRF36UW3mCxVumzhMmdnbOAwhDzu4m3k21z8=
X-Received: by 2002:a17:90a:6b04:: with SMTP id v4mr2220022pjj.101.1601593795113;
 Thu, 01 Oct 2020 16:09:55 -0700 (PDT)
MIME-Version: 1.0
References: <20201001011232.4050282-1-andrew@lunn.ch> <20201001011232.4050282-2-andrew@lunn.ch>
In-Reply-To: <20201001011232.4050282-2-andrew@lunn.ch>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Thu, 1 Oct 2020 16:09:43 -0700
Message-ID: <CAKwvOdnVC8F1=QT03W5Zh9pJdTxxNfRcqXeob5_b4CXycvG1+g@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/2] Makefile.extrawarn: Add symbol for W=1
 warnings for today
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 30, 2020 at 6:12 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> There is a movement to try to make more and more of /drivers W=1
> clean. But it will only stay clean if new warnings are quickly
> detected and fixed, ideally by the developer adding the new code.
>
> To allow subdirectories to sign up to being W=1 clean for a given
> definition of W=1, export the current set of additional compile flags
> using the symbol KBUILD_CFLAGS_W1_20200930. Subdirectory Makefiles can
> then use:
>
> subdir-ccflags-y := $(KBUILD_CFLAGS_W1_20200930)
>
> To indicate they want to W=1 warnings as defined on 20200930.
>
> Additional warnings can be added to the W=1 definition. This will not
> affect KBUILD_CFLAGS_W1_20200930 and hence no additional warnings will
> start appearing unless W=1 is actually added to the command
> line. Developers can then take their time to fix any new W=1 warnings,
> and then update to the latest KBUILD_CFLAGS_W1_<DATESTAMP> symbol.

I'm not a fan of this approach.  Are DATESTAMP configs just going to
keep being added? Is it going to complicate isolating the issue from a
randconfig build?  If we want more things to build warning-free at
W=1, then why don't we start moving warnings from W=1 into the
default, until this is no W=1 left?  That way we're cutting down on
the kernel's configuration combinatorial explosion, rather than adding
to it?

>
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  scripts/Makefile.extrawarn | 34 ++++++++++++++++++----------------
>  1 file changed, 18 insertions(+), 16 deletions(-)
>
> diff --git a/scripts/Makefile.extrawarn b/scripts/Makefile.extrawarn
> index 95e4cdb94fe9..957dca35ae3e 100644
> --- a/scripts/Makefile.extrawarn
> +++ b/scripts/Makefile.extrawarn
> @@ -20,24 +20,26 @@ export KBUILD_EXTRA_WARN
>  #
>  # W=1 - warnings which may be relevant and do not occur too often
>  #
> -ifneq ($(findstring 1, $(KBUILD_EXTRA_WARN)),)
> -
> -KBUILD_CFLAGS += -Wextra -Wunused -Wno-unused-parameter
> -KBUILD_CFLAGS += -Wmissing-declarations
> -KBUILD_CFLAGS += -Wmissing-format-attribute
> -KBUILD_CFLAGS += -Wmissing-prototypes
> -KBUILD_CFLAGS += -Wold-style-definition
> -KBUILD_CFLAGS += -Wmissing-include-dirs
> -KBUILD_CFLAGS += $(call cc-option, -Wunused-but-set-variable)
> -KBUILD_CFLAGS += $(call cc-option, -Wunused-const-variable)
> -KBUILD_CFLAGS += $(call cc-option, -Wpacked-not-aligned)
> -KBUILD_CFLAGS += $(call cc-option, -Wstringop-truncation)
> +KBUILD_CFLAGS_W1_20200930 += -Wextra -Wunused -Wno-unused-parameter
> +KBUILD_CFLAGS_W1_20200930 += -Wmissing-declarations
> +KBUILD_CFLAGS_W1_20200930 += -Wmissing-format-attribute
> +KBUILD_CFLAGS_W1_20200930 += -Wmissing-prototypes
> +KBUILD_CFLAGS_W1_20200930 += -Wold-style-definition
> +KBUILD_CFLAGS_W1_20200930 += -Wmissing-include-dirs
> +KBUILD_CFLAGS_W1_20200930 += $(call cc-option, -Wunused-but-set-variable)
> +KBUILD_CFLAGS_W1_20200930 += $(call cc-option, -Wunused-const-variable)
> +KBUILD_CFLAGS_W1_20200930 += $(call cc-option, -Wpacked-not-aligned)
> +KBUILD_CFLAGS_W1_20200930 += $(call cc-option, -Wstringop-truncation)
>  # The following turn off the warnings enabled by -Wextra
> -KBUILD_CFLAGS += -Wno-missing-field-initializers
> -KBUILD_CFLAGS += -Wno-sign-compare
> -KBUILD_CFLAGS += -Wno-type-limits
> +KBUILD_CFLAGS_W1_20200930 += -Wno-missing-field-initializers
> +KBUILD_CFLAGS_W1_20200930 += -Wno-sign-compare
> +KBUILD_CFLAGS_W1_20200930 += -Wno-type-limits
> +
> +export KBUILD_CFLAGS_W1_20200930
> +
> +ifneq ($(findstring 1, $(KBUILD_EXTRA_WARN)),)
>
> -KBUILD_CPPFLAGS += -DKBUILD_EXTRA_WARN1
> +KBUILD_CPPFLAGS += $(KBUILD_CFLAGS_W1_20200930) -DKBUILD_EXTRA_WARN1
>
>  else
>
> --
> 2.28.0
>
> --
> You received this message because you are subscribed to the Google Groups "Clang Built Linux" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to clang-built-linux+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/clang-built-linux/20201001011232.4050282-2-andrew%40lunn.ch.



-- 
Thanks,
~Nick Desaulniers
