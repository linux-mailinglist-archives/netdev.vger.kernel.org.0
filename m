Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C2575653D0
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 13:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233291AbiGDLg5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 07:36:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234416AbiGDLgY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 07:36:24 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9EAA11A10;
        Mon,  4 Jul 2022 04:36:16 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Lc3fP5lSQz4xdP;
        Mon,  4 Jul 2022 21:36:13 +1000 (AEST)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     bpf@vger.kernel.org, Hari Bathini <hbathini@linux.ibm.com>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Cc:     Jordan Niethe <jniethe5@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        netdev@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        KP Singh <kpsingh@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Russell Currey <ruscur@russell.cc>,
        Andrii Nakryiko <andrii@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
In-Reply-To: <20220610155552.25892-1-hbathini@linux.ibm.com>
References: <20220610155552.25892-1-hbathini@linux.ibm.com>
Subject: Re: [PATCH v2 0/5] Atomics support for eBPF on powerpc
Message-Id: <165693443908.9954.12279962376383575979.b4-ty@ellerman.id.au>
Date:   Mon, 04 Jul 2022 21:33:59 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Jun 2022 21:25:47 +0530, Hari Bathini wrote:
> This patchset adds atomic operations to the eBPF instruction set on
> powerpc. The instructions that are added here can be summarised with
> this list of kernel operations for ppc64:
> 
> * atomic[64]_[fetch_]add
> * atomic[64]_[fetch_]and
> * atomic[64]_[fetch_]or
> * atomic[64]_[fetch_]xor
> * atomic[64]_xchg
> * atomic[64]_cmpxchg
> 
> [...]

Applied to powerpc/next.

[1/5] bpf ppc64: add support for BPF_ATOMIC bitwise operations
      https://git.kernel.org/powerpc/c/65112709115f48f16d7082bcabf173d08622e69f
[2/5] bpf ppc64: add support for atomic fetch operations
      https://git.kernel.org/powerpc/c/dbe6e2456fb0263a5a961a92836d2cebdbca979c
[3/5] bpf ppc64: Add instructions for atomic_[cmp]xchg
      https://git.kernel.org/powerpc/c/1e82dfaa7819f03f0b0022be7ca15bbc83090da1
[4/5] bpf ppc32: add support for BPF_ATOMIC bitwise operations
      https://git.kernel.org/powerpc/c/aea7ef8a82c0ea13ff20b65ff2edf8a38a17eda8
[5/5] bpf ppc32: Add instructions for atomic_[cmp]xchg
      https://git.kernel.org/powerpc/c/2d9206b227434912582049c49af1085660fa1e50

cheers
