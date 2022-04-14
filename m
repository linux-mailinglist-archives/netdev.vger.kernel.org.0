Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2FAF501E93
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 00:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347190AbiDNWsQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 18:48:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241321AbiDNWsO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 18:48:14 -0400
Received: from mail-0201.mail-europe.com (mail-0201.mail-europe.com [51.77.79.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 683F4C6B76;
        Thu, 14 Apr 2022 15:45:47 -0700 (PDT)
Date:   Thu, 14 Apr 2022 22:45:36 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
        s=protonmail2; t=1649976343;
        bh=N1CwAcVop9zqLRsxrEXTkTy/S/preizWU4aYyhoZHhM=;
        h=Date:To:From:Cc:Reply-To:Subject:Message-ID:In-Reply-To:
         References:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
         Message-ID;
        b=A22Iq2lQ4+bvKuiiH5ymI5leLRm2NdvbTRbCKTbTSPbG9FrsxL4lhq+6lvrKqyYVX
         f+jqjmtNimSu19D0n3qDygcmD1jdvQp+kYlfG4OE2s1GwAZu6kcwmnJpwpHSULv6+v
         YkJ5usrs7vsKBaD8n69R3nMgGX9KrJaF6R7iOUOKjdFww7hAJvnC1d9tJpqlb9w7w0
         RTW+fAuYbwCvz+VXBdIHc/UwvFj62SsB67Zxs+5vY9lCY5WUkeQCMLmyZhuRgubjMN
         /7zWr9JFt/FO+dtUcBPTOTDQ8qvU4HV/xO4vF3lssWb3vjzIWPUYjhNE8V6O1LHI/T
         SDUZPwx38pcAw==
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?utf-8?Q?Bj=C3=B6rn_T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Dmitrii Dolgov <9erthalion6@gmail.com>,
        Quentin Monnet <quentin@isovalent.com>,
        Tiezhu Yang <yangtiezhu@loongson.cn>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Chenbo Feng <fengc@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Daniel Wagner <daniel.wagner@bmw-carit.de>,
        Thomas Graf <tgraf@suug.ch>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, llvm@lists.linux.dev
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH bpf-next 04/11] samples: bpf: add 'asm/mach-generic' include path for every MIPS
Message-ID: <20220414223704.341028-5-alobakin@pm.me>
In-Reply-To: <20220414223704.341028-1-alobakin@pm.me>
References: <20220414223704.341028-1-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following:

In file included from samples/bpf/tracex2_kern.c:7:
In file included from ./include/linux/skbuff.h:13:
In file included from ./include/linux/kernel.h:22:
In file included from ./include/linux/bitops.h:33:
In file included from ./arch/mips/include/asm/bitops.h:20:
In file included from ./arch/mips/include/asm/barrier.h:11:
./arch/mips/include/asm/addrspace.h:13:10: fatal error: 'spaces.h' file not=
 found
 #include <spaces.h>
          ^~~~~~~~~~

'arch/mips/include/asm/mach-generic' should always be included as
many other MIPS include files rely on this.
Move it from under CONFIG_MACH_LOONGSON64 to let it be included
for every MIPS.

Fixes: 058107abafc7 ("samples/bpf: Add include dir for MIPS Loongson64 to f=
ix build errors")
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 samples/bpf/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 8fff5ad3444b..97203c0de252 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -193,8 +193,8 @@ ifeq ($(ARCH), mips)
 TPROGS_CFLAGS +=3D -D__SANE_USERSPACE_TYPES__
 ifdef CONFIG_MACH_LOONGSON64
 BPF_EXTRA_CFLAGS +=3D -I$(srctree)/arch/mips/include/asm/mach-loongson64
-BPF_EXTRA_CFLAGS +=3D -I$(srctree)/arch/mips/include/asm/mach-generic
 endif
+BPF_EXTRA_CFLAGS +=3D -I$(srctree)/arch/mips/include/asm/mach-generic
 endif

 TPROGS_CFLAGS +=3D -Wall -O2
--
2.35.2


