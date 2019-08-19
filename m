Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 890E894C43
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 20:01:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728022AbfHSSBT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 14:01:19 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44651 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727835AbfHSSBT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 14:01:19 -0400
Received: by mail-wr1-f68.google.com with SMTP id p17so9631224wrf.11;
        Mon, 19 Aug 2019 11:01:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=HUbQ6TJbRJd3FylO8z/DeJHcTNlZONXDa2YpJWPmkCM=;
        b=eezivLK+4kRRaqVw7lq7hc7oQgeqDlvCK/cVRJoQq+3gxfQ0N4vWfrzNzOEWLHpiLp
         2caN4KMSowF99Rr2SUF3rOnGEbtV33/uvzSc25uXr+xJG2aPdW9Up3haH8zLvevLVwLR
         updz9ULcnWSVLPfpVPKbUma9wRXQAjkxlTYgQWZ46a/xx9RoPkRoqVvUY1eX8GbemYhy
         i7dvSdro9dHOa3f7v4H52XGJzXPArDG0eZmvRmt3cYmkJioZ1PaPvxP0GPcOU4cvD1Ff
         ADgOO1cfax3i6W107OEPZWw0XQMMeybwtRrltAnuRThsbaNHOsw/9+zXY1Z+BVFh7X/o
         fWuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=HUbQ6TJbRJd3FylO8z/DeJHcTNlZONXDa2YpJWPmkCM=;
        b=fBzNEE1eNQvJzwxcZENl+YQSy3VPqLH3AIZhnemcIEp8FVuFsL22TU3PfQ3i93aGN9
         bTMHgaV1EdcpFCGfiF5fK4F6325MtddBl3HuhQ8UucGovXB7+QYXVMv7jyhFbQwROLnT
         A9eLJINqgrvLcXrYjJGhDNC1+zIuBd+9k11CSku9zjI4L6EiaMk/Npte5VUnUA+0KcNy
         qQIW4kdJc2O2mepl6sDrjQ4DnKSJI9PUk8vvO0YZ1appAopFYoHgBnauEkbwF45ezYE3
         rCWTHf/CQvkUHUvEsgbVqXGp8Df4rWBd0AdadbrlzAkyL/eas47vZBBDP3Tokwbm+q6G
         /SFg==
X-Gm-Message-State: APjAAAXzVl5Wi1hBtfwKYJGD7Kt0H7QSIj/3xNldch7+3Ehe4U9VM/Up
        sCfEi4dl/f0mlla4Q275jdS3F43lp67Og4Jz7R0=
X-Google-Smtp-Source: APXvYqz3IE1yjTMcxRuvs4JDpDNL2REi2MGWDghf54WTU6fNLp0uoIOG/XQXeDjZwKxuuK4iLsuIMbZrWnbkgGCiMzk=
X-Received: by 2002:a5d:69c8:: with SMTP id s8mr27553471wrw.353.1566237677269;
 Mon, 19 Aug 2019 11:01:17 -0700 (PDT)
MIME-Version: 1.0
References: <20190812215052.71840-1-ndesaulniers@google.com> <20190812215052.71840-16-ndesaulniers@google.com>
In-Reply-To: <20190812215052.71840-16-ndesaulniers@google.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Mon, 19 Aug 2019 20:01:03 +0200
Message-ID: <CA+icZUVvkz2AK6KMdQrOrCvuzUc=6jrQYRzzLk+=CSDY=ezKMA@mail.gmail.com>
Subject: Re: [PATCH 16/16] compiler_attributes.h: add note about __section
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     akpm@linux-foundation.org, jpoimboe@redhat.com, yhs@fb.com,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Clang-Built-Linux ML <clang-built-linux@googlegroups.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 12, 2019 at 11:53 PM Nick Desaulniers
<ndesaulniers@google.com> wrote:
>
> The antipattern described can be found with:
> $ grep -e __section\(\" -r -e __section__\(\"
>
> Link: https://bugs.llvm.org/show_bug.cgi?id=42950
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>

Tested-by: Sedat Dilek <sedat.dilek@gmail.com> [ Linux v5.3-rc5 ]

Patchset "for-5.3/x86-section-name-escaping":

include/linux/compiler.h: remove unused KENTRY macro
include/linux: prefer __section from compiler_attributes.h
include/asm-generic: prefer __section from compiler_attributes.h
x86: prefer __section from compiler_attributes.h

Thanks.

- Sedat -

> ---
>  include/linux/compiler_attributes.h | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/include/linux/compiler_attributes.h b/include/linux/compiler_attributes.h
> index 6b318efd8a74..f8c008d7f616 100644
> --- a/include/linux/compiler_attributes.h
> +++ b/include/linux/compiler_attributes.h
> @@ -225,6 +225,16 @@
>  #define __pure                          __attribute__((__pure__))
>
>  /*
> + *  Note: Since this macro makes use of the "stringification operator" `#`, a
> + *        quoted string literal should not be passed to it. eg.
> + *        prefer:
> + *        __section(.foo)
> + *        to:
> + *        __section(".foo")
> + *        unless the section name is dynamically built up, in which case the
> + *        verbose __attribute__((__section__(".foo" x))) should be preferred.
> + *        See also: https://bugs.llvm.org/show_bug.cgi?id=42950
> + *
>   *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-section-function-attribute
>   *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Variable-Attributes.html#index-section-variable-attribute
>   * clang: https://clang.llvm.org/docs/AttributeReference.html#section-declspec-allocate
> --
> 2.23.0.rc1.153.gdeed80330f-goog
>
