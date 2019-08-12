Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F4668A91F
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 23:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727265AbfHLVQh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 17:16:37 -0400
Received: from ms.lwn.net ([45.79.88.28]:37120 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726805AbfHLVQg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Aug 2019 17:16:36 -0400
Received: from lwn.net (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id B1E6F737;
        Mon, 12 Aug 2019 21:16:35 +0000 (UTC)
Date:   Mon, 12 Aug 2019 15:16:34 -0600
From:   Jonathan Corbet <corbet@lwn.net>
To:     Sheriff Esseson <sheriffesseson@gmail.com>
Cc:     skhan@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:RISC-V ARCHITECTURE" <linux-riscv@lists.infradead.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <bpf@vger.kernel.org>
Subject: Re: [PATCH v2] Documentation: virt: Fix broken reference to virt
 tree's index
Message-ID: <20190812151634.49c126a0@lwn.net>
In-Reply-To: <20190809132349.GA15460@localhost>
References: <20190809132349.GA15460@localhost>
Organization: LWN.net
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 9 Aug 2019 14:23:49 +0100
Sheriff Esseson <sheriffesseson@gmail.com> wrote:

> Fix broken reference to virt/index.rst.
> 
> Fixes: 2f5947dfcaec ("Documentation: move Documentation/virtual to
> Documentation/virt")
> 
> Signed-off-by: Sheriff Esseson <sheriffesseson@gmail.com>

Note that you should keep the "Fixes:" tag on a single line, and not put a
blank line between it and the other tags.  I've fixed that up and applied
the patch, thanks.

jon
