Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 026A9B43B8
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 00:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732554AbfIPWCG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 18:02:06 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:34225 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730459AbfIPWCF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 18:02:05 -0400
Received: by mail-qk1-f196.google.com with SMTP id q203so1696648qke.1;
        Mon, 16 Sep 2019 15:02:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bBLyhw31asDlP3KaGnYqHfV7kPwJZ+ePQIhLUhYQq/A=;
        b=DLKtESLHU3yBGqlehMqSQrTPtHUvgFrzUz0kljjkJWZZtuitfwKiQFXCyHIFOIXi77
         f27waV1lV4S/j+0v32Py8CziL5dMIBrqFKRrI1AmJhNEnC/NrlMGLKpBVrdxOX1z1cJf
         mZimqaZ1mQf5RIIzVRm2hPh9KdQMTQcKi5wBzm6NYUdrh3zkrW2GZzdR49IM74Z4U9jx
         i83K9Y9wu1Sr0Zs45duucHo04Ux+TMntBd1km9iikE+251BTw8RSfGfNtymAabFa2XuR
         FXEOSAoM9JNcxba+Y+pfU8nGZ3Ic3s9wyPQ8NZsywOy5VwzuOvGXrIvaXzEJCmLRa/Pm
         Km0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bBLyhw31asDlP3KaGnYqHfV7kPwJZ+ePQIhLUhYQq/A=;
        b=PsWqk0YaTpAW4qV/5WInmRjqGV7OcYBfFNTUsX6RVF+88ixjZARm5Vi13c9JNrtGoE
         d59QilymzjNAbtM5nOuNhUGEWl4aTuNt3FtJfqBP6sb3Exvr3W3WleqzXxX6v9jQ2ri5
         2JtG0vrZUuJr1cS1zydIxgwmfwvN6XArV7TOjS3gaQ4X3a0u8lUJLft7eMkFJavgvJ6C
         1oh2Br19JjMl+DNWp1MtbdyMfJ3xswegZugHwkXJRi9FlBkyw/tLNEAZzlMF+s/Mg4cW
         SSVZWLNiquMkIRocYcm6vIMdED6wc4UwQRUXXGdmCcOpLu0XOt/WItFwpYxKFih+NnXi
         7xJA==
X-Gm-Message-State: APjAAAW3HV8r7JshRi0OFMTz4LUyuuN0LU1OiYJFQhLL1WRP1Q83l3D+
        gh3DoivqC8EswZMZBzkU4UzFHGzl2mfX3e0OZUE=
X-Google-Smtp-Source: APXvYqwrjLnzLhIeWCJgeHld79aMAAa21d7PB4k96iCLLkOJd04ymTYy8cBDfY/3O4zvG2IROfmBAzcYZgthBSsmc1w=
X-Received: by 2002:a37:98f:: with SMTP id 137mr531581qkj.449.1568671323725;
 Mon, 16 Sep 2019 15:02:03 -0700 (PDT)
MIME-Version: 1.0
References: <20190916105433.11404-1-ivan.khoronzhuk@linaro.org>
 <20190916105433.11404-2-ivan.khoronzhuk@linaro.org> <CAEf4BzZVTjCybmDgM0VBzv_L-LHtF8LcDyyKSWJm0ZA4jtJKcw@mail.gmail.com>
 <8736gvexfz.fsf@igel.home>
In-Reply-To: <8736gvexfz.fsf@igel.home>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 16 Sep 2019 15:01:52 -0700
Message-ID: <CAEf4BzZnv0Cy8KTYaso-G-TYj_UM6MbEYEi_d14DmW2W=VuLhg@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 01/14] samples: bpf: makefile: fix HDR_PROBE "echo"
To:     Andreas Schwab <schwab@linux-m68k.org>
Cc:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        clang-built-linux@googlegroups.com,
        sergei.shtylyov@cogentembedded.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 16, 2019 at 2:35 PM Andreas Schwab <schwab@linux-m68k.org> wrote:
>
> On Sep 16 2019, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
>
> > On Mon, Sep 16, 2019 at 3:59 AM Ivan Khoronzhuk
> > <ivan.khoronzhuk@linaro.org> wrote:
> >>
> >> echo should be replaced with echo -e to handle '\n' correctly, but
> >> instead, replace it with printf as some systems can't handle echo -e.
> >>
> >> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
> >> ---
> >>  samples/bpf/Makefile | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
> >> index 1d9be26b4edd..f50ca852c2a8 100644
> >> --- a/samples/bpf/Makefile
> >> +++ b/samples/bpf/Makefile
> >> @@ -201,7 +201,7 @@ endif
> >>
> >>  # Don't evaluate probes and warnings if we need to run make recursively
> >>  ifneq ($(src),)
> >> -HDR_PROBE := $(shell echo "\#include <linux/types.h>\n struct list_head { int a; }; int main() { return 0; }" | \
> >> +HDR_PROBE := $(shell printf "\#include <linux/types.h>\n struct list_head { int a; }; int main() { return 0; }" | \
> >
> > printf change is fine, but I'm confused about \# at the beginning of
> > the string.
>
> From the NEWS of make 4.3:
>
> * WARNING: Backward-incompatibility!
>   Number signs (#) appearing inside a macro reference or function invocation
>   no longer introduce comments and should not be escaped with backslashes:
>   thus a call such as:
>     foo := $(shell echo '#')
>   is legal.  Previously the number sign needed to be escaped, for example:
>     foo := $(shell echo '\#')
>   Now this latter will resolve to "\#".  If you want to write makefiles
>   portable to both versions, assign the number sign to a variable:
>     H := \#
>     foo := $(shell echo '$H')
>   This was claimed to be fixed in 3.81, but wasn't, for some reason.
>   To detect this change search for 'nocomment' in the .FEATURES variable.
>
> Andreas.

Oh, subtle... Thanks for explaining!

>
> --
> Andreas Schwab, schwab@linux-m68k.org
> GPG Key fingerprint = 7578 EB47 D4E5 4D69 2510  2552 DF73 E780 A9DA AEC1
> "And now for something completely different."
