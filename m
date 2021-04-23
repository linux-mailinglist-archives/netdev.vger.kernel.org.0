Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D26C36908A
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 12:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242108AbhDWKr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 06:47:29 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:43462 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229885AbhDWKr0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 06:47:26 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 4FRWF12hTFz9vBLr;
        Fri, 23 Apr 2021 12:46:45 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id OMUajc0KWjbX; Fri, 23 Apr 2021 12:46:45 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 4FRWF117fBz9vBKj;
        Fri, 23 Apr 2021 12:46:45 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id CE9A68B849;
        Fri, 23 Apr 2021 12:46:46 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id bnOKyCWI-iRB; Fri, 23 Apr 2021 12:46:46 +0200 (CEST)
Received: from [192.168.4.90] (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id B69ED8B765;
        Fri, 23 Apr 2021 12:46:43 +0200 (CEST)
Subject: Re: [PATCH bpf-next 1/2] bpf: Remove bpf_jit_enable=2 debugging mode
To:     Quentin Monnet <quentin@isovalent.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Ian Rogers <irogers@google.com>, Song Liu <songliubraving@fb.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Sandipan Das <sandipan@linux.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>, sparclinux@vger.kernel.org,
        Shubham Bansal <illusionist.neo@gmail.com>,
        Mahesh Bandewar <maheshb@google.com>,
        Will Deacon <will@kernel.org>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Ilya Leoshkevich <iii@linux.ibm.com>, paulburton@kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        X86 ML <x86@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Tobias Klauser <tklauser@distanz.ch>,
        linux-mips@vger.kernel.org, grantseltzer@gmail.com,
        Xi Wang <xi.wang@gmail.com>, Albert Ou <aou@eecs.berkeley.edu>,
        Kees Cook <keescook@chromium.org>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Luke Nelson <luke.r.nels@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        KP Singh <kpsingh@kernel.org>, iecedge@gmail.com,
        Simon Horman <horms@verge.net.au>,
        Borislav Petkov <bp@alien8.de>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Yonghong Song <yhs@fb.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dmitry Vyukov <dvyukov@google.com>, tsbogend@alpha.franken.de,
        Daniel Borkmann <daniel@iogearbox.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Network Development <netdev@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Wang YanQing <udknight@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>, bpf <bpf@vger.kernel.org>,
        Jianlin Lv <Jianlin.Lv@arm.com>,
        "David S. Miller" <davem@davemloft.net>
References: <20210415093250.3391257-1-Jianlin.Lv@arm.com>
 <9c4a78d2-f73c-832a-e6e2-4b4daa729e07@iogearbox.net>
 <d3949501-8f7d-57c4-b3fe-bcc3b24c09d8@isovalent.com>
 <CAADnVQJ2oHbYfgY9jqM_JMxUsoZxaNrxKSVFYfgCXuHVpDehpQ@mail.gmail.com>
 <0dea05ba-9467-0d84-4515-b8766f60318e@csgroup.eu>
 <CAADnVQ+oQT6C7Qv7P5TV-x7im54omKoCYYKtYhcnhb1Uv3LPMQ@mail.gmail.com>
 <be132117-f267-5817-136d-e1aeb8409c2a@csgroup.eu>
 <58296f87-ad00-a0f5-954b-2150aa84efc4@isovalent.com>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Message-ID: <6a809d3f-c9e3-0eb7-9c1d-a202ad848424@csgroup.eu>
Date:   Fri, 23 Apr 2021 12:46:39 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <58296f87-ad00-a0f5-954b-2150aa84efc4@isovalent.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Le 23/04/2021 à 12:26, Quentin Monnet a écrit :
> 2021-04-23 09:19 UTC+0200 ~ Christophe Leroy <christophe.leroy@csgroup.eu>
> 
> [...]
> 
>> I finally managed to cross compile bpftool with libbpf, libopcodes,
>> readline, ncurses, libcap, libz and all needed stuff. Was not easy but I
>> made it.
> 
> Libcap is optional and bpftool does not use readline or ncurses. May I
> ask how you tried to build it?

cd tools/bpf/

make ARCH=powerpc CROSS_COMPILE=ppc-linux-


Christophe
