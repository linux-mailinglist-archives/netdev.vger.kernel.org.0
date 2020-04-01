Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3055219AC12
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 14:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732572AbgDAMxL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 08:53:11 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:46271 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732435AbgDAMxL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Apr 2020 08:53:11 -0400
Received: by ozlabs.org (Postfix, from userid 1034)
        id 48smMS2jDxz9sT6; Wed,  1 Apr 2020 23:53:07 +1100 (AEDT)
X-powerpc-patch-notification: thanks
X-powerpc-patch-commit: a7032637b54186e5649917679727d7feaec932b1
In-Reply-To: <20190812215052.71840-10-ndesaulniers@google.com>
To:     Nick Desaulniers <ndesaulniers@google.com>,
        akpm@linux-foundation.org
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
Cc:     Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Rob Herring <robh@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        clang-built-linux@googlegroups.com, yhs@fb.com,
        jpoimboe@redhat.com, sedat.dilek@gmail.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Allison Randal <allison@lohutok.net>,
        Geoff Levand <geoff@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-kernel@vger.kernel.org, miguel.ojeda.sandonis@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, Martin KaFai Lau <kafai@fb.com>
Subject: Re: [PATCH 10/16] powerpc: prefer __section and __printf from compiler_attributes.h
Message-Id: <48smMS2jDxz9sT6@ozlabs.org>
Date:   Wed,  1 Apr 2020 23:53:07 +1100 (AEDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2019-08-12 at 21:50:43 UTC, Nick Desaulniers wrote:
> Reported-by: Sedat Dilek <sedat.dilek@gmail.com>
> Suggested-by: Josh Poimboeuf <jpoimboe@redhat.com>
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>

Applied to powerpc next, thanks.

https://git.kernel.org/powerpc/c/a7032637b54186e5649917679727d7feaec932b1

cheers
