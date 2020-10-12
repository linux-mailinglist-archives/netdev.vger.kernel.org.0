Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 832BE28AB4E
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 03:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727255AbgJLBBE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 21:01:04 -0400
Received: from conssluserg-05.nifty.com ([210.131.2.90]:34510 "EHLO
        conssluserg-05.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727132AbgJLBBE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 21:01:04 -0400
X-Greylist: delayed 42977 seconds by postgrey-1.27 at vger.kernel.org; Sun, 11 Oct 2020 21:01:03 EDT
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179]) (authenticated)
        by conssluserg-05.nifty.com with ESMTP id 09C10eZ7007021;
        Mon, 12 Oct 2020 10:00:40 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-05.nifty.com 09C10eZ7007021
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1602464440;
        bh=o9Qs2wdvNnlhb5S1PCEmTwni8pcS98p2JBGMsac1Ols=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=209KxBvOeyWGBAgIaf8EJSaA7Yc6qPdkUWqxBZfme+MoVIUE0vOKcNlyPgdX5DlIr
         vbLFyCIz9n7AKNWcQ6RlA2ySvMN0NrRU9Ve+S2wESH+0UJ6YIOg3a5trDNx2vZ/1pI
         z84ss89OHA8kHCXaZ9ISK+H6aSQgA/mv4fH6okq2lE3qcmwvlbwrDLcbraMHtegnIE
         nED3WJT1jO+YHrQALMOTIJ5aRCUXTD6OErHtD/0x6Tcjhd98MZlJBJREBJlblPgU5g
         3wyjrQVooB715wrwb6TFhZQL1qFRkhHZr0j6nRiVHK1Dy1bl09a1C49dCv4P/T7JyQ
         uJ6B7PolLL0Eg==
X-Nifty-SrcIP: [209.85.215.179]
Received: by mail-pg1-f179.google.com with SMTP id n9so12672476pgf.9;
        Sun, 11 Oct 2020 18:00:40 -0700 (PDT)
X-Gm-Message-State: AOAM531lndw6tBZMW2yewP62hiyb0CQvT8uUqEucVLzoY4H5VGd6pdrt
        +vgaj/0hLlL57esSXXNfuEMIQmGwCQrYoZiYmTM=
X-Google-Smtp-Source: ABdhPJyZ58mFtSdXnHUPO1e6eNn6ErK26DE/1lnT5+qAHLnpRPX0RJdVCGR/jjW710NGg+xdjyvNDR4Vt/oO3MWwNTU=
X-Received: by 2002:a63:d242:: with SMTP id t2mr11790829pgi.47.1602464439492;
 Sun, 11 Oct 2020 18:00:39 -0700 (PDT)
MIME-Version: 1.0
References: <20201001011232.4050282-1-andrew@lunn.ch> <20201001011232.4050282-2-andrew@lunn.ch>
 <CAKwvOdnVC8F1=QT03W5Zh9pJdTxxNfRcqXeob5_b4CXycvG1+g@mail.gmail.com>
 <20201002014411.GG4067422@lunn.ch> <CAK8P3a0tA9VMMjgkFeCaM3dWLu8H0CFBTkE8zeUpwSR1o31z1w@mail.gmail.com>
In-Reply-To: <CAK8P3a0tA9VMMjgkFeCaM3dWLu8H0CFBTkE8zeUpwSR1o31z1w@mail.gmail.com>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Mon, 12 Oct 2020 10:00:02 +0900
X-Gmail-Original-Message-ID: <CAK7LNARRchbhDNUT3paTVpOJYKR-D_+HLzjG-wsOOM+LO5p3sA@mail.gmail.com>
Message-ID: <CAK7LNARRchbhDNUT3paTVpOJYKR-D_+HLzjG-wsOOM+LO5p3sA@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/2] Makefile.extrawarn: Add symbol for W=1
 warnings for today
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Nick Desaulniers <ndesaulniers@google.com>,
        netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 2, 2020 at 9:21 PM Arnd Bergmann <arnd@arndb.de> wrote:
>
> I do care about the tree as a whole, and I'm particularly interested in
> having -Wmissing-declarations/-Wmissing-prototypes enabled globally
> at some point in the future.
>
>         Arnd


BTW, if possible, please educate me about the difference
between -Wmissing-declarations and -Wmissing-prototypes.


The GCC manual says as follows:


-Wmissing-prototypes (C and Objective-C only)

Warn if a global function is defined without a previous prototype
declaration. This warning is issued even if the definition itself
provides a prototype. Use this option to detect global functions that
do not have a matching prototype declaration in a header file. This
option is not valid for C++ because all function declarations provide
prototypes and a non-matching declaration declares an overload rather
than conflict with an earlier declaration. Use -Wmissing-declarations
to detect missing declarations in C++.

-Wmissing-declarations

Warn if a global function is defined without a previous declaration.
Do so even if the definition itself provides a prototype. Use this
option to detect global functions that are not declared in header
files. In C, no warnings are issued for functions with previous
non-prototype declarations; use -Wmissing-prototypes to detect missing
prototypes. In C++, no warnings are issued for function templates, or
for inline functions, or for functions in anonymous namespaces.



The difference is still unclear to me...



For example, if I add -Wmissing-declarations, I get the following:


kernel/sched/core.c:2380:6: warning: no previous declaration for
=E2=80=98sched_set_stop_task=E2=80=99 [-Wmissing-declarations]
 2380 | void sched_set_stop_task(int cpu, struct task_struct *stop)
      |      ^~~~~~~~~~~~~~~~~~~



But, if I add both -Wmissing-declarations and -Wmissing-prototypes,
-Wmissing-declarations is superseded by -Wmissing-prototypes.



kernel/sched/core.c:2380:6: warning: no previous prototype for
=E2=80=98sched_set_stop_task=E2=80=99 [-Wmissing-prototypes]
 2380 | void sched_set_stop_task(int cpu, struct task_struct *stop)
      |      ^~~~~~~~~~~~~~~~~~~




Do we need to specify both in W=3D1 ?
If yes, what is the difference between them?


--
Best Regards
Masahiro Yamada
