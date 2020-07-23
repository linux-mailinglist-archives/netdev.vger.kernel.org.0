Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 172FF22B7E2
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 22:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbgGWUgU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 16:36:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725979AbgGWUgU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 16:36:20 -0400
Received: from ms.lwn.net (ms.lwn.net [IPv6:2600:3c01:e000:3a1::42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 156F2C0619D3;
        Thu, 23 Jul 2020 13:36:20 -0700 (PDT)
Received: from lwn.net (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id 2715D2BA;
        Thu, 23 Jul 2020 20:36:19 +0000 (UTC)
Date:   Thu, 23 Jul 2020 14:36:18 -0600
From:   Jonathan Corbet <corbet@lwn.net>
To:     "Daniel W. S. Almeida" <dwlsalmeida@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH] docs: bpf/ringbuf.rst: fix reference to nonexistent
 document
Message-ID: <20200723143618.6be62996@lwn.net>
In-Reply-To: <20200718165107.625847-7-dwlsalmeida@gmail.com>
References: <20200718165107.625847-1-dwlsalmeida@gmail.com>
        <20200718165107.625847-7-dwlsalmeida@gmail.com>
Organization: LWN.net
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 18 Jul 2020 13:51:01 -0300
"Daniel W. S. Almeida" <dwlsalmeida@gmail.com> wrote:

> Fix the following warnings:
> 
> ringbuf.rst:197: WARNING: Unknown target name: "bench_ringbuf.c"
> 
> There was no target defined for 'bench_ringbuf.c'. Also, the
> syntax used was wrong, in the sense that it would not highlight
> the entire path in the browser.
> 
> Signed-off-by: Daniel W. S. Almeida <dwlsalmeida@gmail.com>
> ---
>  Documentation/bpf/ringbuf.rst | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/bpf/ringbuf.rst b/Documentation/bpf/ringbuf.rst
> index 75f943f0009df..8e7c15a927740 100644
> --- a/Documentation/bpf/ringbuf.rst
> +++ b/Documentation/bpf/ringbuf.rst
> @@ -200,10 +200,13 @@ a self-pacing notifications of new data being availability.
>  being available after commit only if consumer has already caught up right up to
>  the record being committed. If not, consumer still has to catch up and thus
>  will see new data anyways without needing an extra poll notification.
> -Benchmarks (see tools/testing/selftests/bpf/benchs/bench_ringbuf.c_) show that
> +Benchmarks (see `tools/testing/selftests/bpf/benchs/bench_ringbufs.c`_) show that
>  this allows to achieve a very high throughput without having to resort to

But this still doesn't lead to anything useful, right?  That file is not
part of the documentation...  It seems better just to take out the "_"...

Thanks,

jon
