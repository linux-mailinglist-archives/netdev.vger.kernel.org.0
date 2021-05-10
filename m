Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5B1D378FB0
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 15:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240576AbhEJNwu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 09:52:50 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:39573 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241661AbhEJNpU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 09:45:20 -0400
Received: from mail-ot1-f46.google.com ([209.85.210.46]) by
 mrelayeu.kundenserver.de (mreue010 [213.165.67.97]) with ESMTPSA (Nemesis) id
 1N0nzR-1lL7To0U9l-00wlLR; Mon, 10 May 2021 15:44:09 +0200
Received: by mail-ot1-f46.google.com with SMTP id t4-20020a05683014c4b02902ed26dd7a60so4284961otq.7;
        Mon, 10 May 2021 06:44:08 -0700 (PDT)
X-Gm-Message-State: AOAM5328FdHEOHaAUuEIq1f7rSVESUcQlT58FuYhYbZHsUfaWvF9wtxY
        7ViGpo9ADRI5VV/9HOdJzNIScTORXPXWtZM/Iog=
X-Google-Smtp-Source: ABdhPJyf4ohtmioZ4kBKNKLfyswa7BdPHuxKlk9MsZP//sYaokfeX3BZsjL/Fq6RIqRnBVeec+JlEiMV654qEXfujKI=
X-Received: by 2002:a9d:222a:: with SMTP id o39mr20683875ota.246.1620654241959;
 Mon, 10 May 2021 06:44:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210510085339.1857696-4-schnelle@linux.ibm.com> <202105102111.SyGVczHt-lkp@intel.com>
In-Reply-To: <202105102111.SyGVczHt-lkp@intel.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 10 May 2021 15:43:08 +0200
X-Gmail-Original-Message-ID: <CAK8P3a0CiVFvgpJJMcutHv6gdfeKWN2=AWYDuAX-ohEg3+L3gQ@mail.gmail.com>
Message-ID: <CAK8P3a0CiVFvgpJJMcutHv6gdfeKWN2=AWYDuAX-ohEg3+L3gQ@mail.gmail.com>
Subject: Re: [PATCH v5 3/3] asm-generic/io.h: warn in inb() and friends with
 undefined PCI_IOBASE
To:     kernel test robot <lkp@intel.com>
Cc:     Niklas Schnelle <schnelle@linux.ibm.com>,
        Vineet Gupta <vgupta@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>, kbuild-all@lists.01.org,
        Networking <netdev@vger.kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        linux-arch <linux-arch@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:nVQFemXOPYeLeABTrJITdRG/VMGJSTepcBPBcH+ZAK5l8KOhUK5
 cjjIHddG4heP3Nv4sCg9gA+VDn9dEEoJnlK0zPVMmZeuBUIX3A0rmcbNZjeFu4reZIDmJ4O
 g+S/75EwrMaCZxUbKgpGjZXOxs+AEZnOzvRVx5LQEIDHxJtwsNAbb2JKWGLUFIHKj80rAMY
 T/it7stYcME7laYJ1NQvQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Prnpub61Edo=:IwPSuMdgZzzmzWl0boyLEI
 p0hy5Y8FrUj7Y7fBTgG+PSI2N5MLBF3YIN/8ozLLXRpgeekf5XnJNNiEp2Q9dh6R5iE6KaTwz
 Ogurhx8aqyPxHAmyY8QaOdL5CoOA6W8jOB8yXZXSiCSC3NY4/hVdK3F4/VE/oz+8QxYPcvVvb
 9iKWMXGhVHsFiQc/dSMtNVx+LmDzARz7VrVgkBCF7ur9R39JhwKS6BkkLCeeh1Zm6sJMEQ1Tp
 g50GtGpUqWFh31MasSFjJ5VipUBv9ubYFFJg0tE2bPa+9xKxmh0dYtVCdrfohpBz+5SxwzLiu
 EiaMkXQTW/m/0gWJIZ1vqCZD0y9GB0/yGGmTlhHsj80/ICrvlKrrG1/AEXVV2OKB5kvKPSS3N
 dhoCQakHsz7+1iTWH7L7zXkVTxYZMLNP7tO+btpMSwPhMsj+BkTeFkz4aVfjLuhBGAt1wg0sE
 CtDoDPWm6VvBgJTvYh0QWcedN7s07q159Mg6ToNZpMSUs8RAbonv6hHSrMRWpzgsEVC82p6Pa
 qLhfNbzTvZTRHJPoQcthc0=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 10, 2021 at 3:30 PM kernel test robot <lkp@intel.com> wrote:
> All warnings (new ones prefixed by >>):
>
>    In file included from include/linux/kernel.h:10,
>                     from include/linux/list.h:9,
>                     from include/linux/module.h:12,
>                     from drivers/net/arcnet/com20020.c:31:
>    drivers/net/arcnet/com20020.c: In function 'com20020_reset':
> >> include/linux/compiler.h:70:32: warning: 'inbyte' is used uninitialized in this function [-Wuninitialized]
>       70 |   (__if_trace.miss_hit[1]++,1) :  \
>          |                                ^
>    drivers/net/arcnet/com20020.c:286:9: note: 'inbyte' was declared here
>      286 |  u_char inbyte;
>          |         ^~~~~~

This looks like a real problem with the patch: the insb()/insw()/insl() helpers
should memset(buffer, 0xff, size) to avoid using random stack data.

        Arnd
