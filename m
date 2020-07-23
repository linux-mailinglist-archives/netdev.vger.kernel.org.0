Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A77822B7B7
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 22:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbgGWU1p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 16:27:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725979AbgGWU1p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 16:27:45 -0400
Received: from ms.lwn.net (ms.lwn.net [IPv6:2600:3c01:e000:3a1::42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92527C0619DC;
        Thu, 23 Jul 2020 13:27:45 -0700 (PDT)
Received: from lwn.net (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id D9FFE2BA;
        Thu, 23 Jul 2020 20:27:44 +0000 (UTC)
Date:   Thu, 23 Jul 2020 14:27:43 -0600
From:   Jonathan Corbet <corbet@lwn.net>
To:     "Daniel W. S. Almeida" <dwlsalmeida@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH] docs: bpf/bpf_devel_QA.rst: fix reference to
 nonexistent document
Message-ID: <20200723142743.0df6263d@lwn.net>
In-Reply-To: <20200718165107.625847-6-dwlsalmeida@gmail.com>
References: <20200718165107.625847-1-dwlsalmeida@gmail.com>
        <20200718165107.625847-6-dwlsalmeida@gmail.com>
Organization: LWN.net
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 18 Jul 2020 13:51:00 -0300
"Daniel W. S. Almeida" <dwlsalmeida@gmail.com> wrote:

> Fix the following sphinx warning:
> 
> bpf_devel_QA.rst:444: WARNING: Unknown target name:
> "documentation/bpf/btf.rst"
> 
> No target was defined for 'btf.rst' in the document. Fix it.
> 
> Signed-off-by: Daniel W. S. Almeida <dwlsalmeida@gmail.com>
> ---
>  Documentation/bpf/bpf_devel_QA.rst | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/bpf/bpf_devel_QA.rst b/Documentation/bpf/bpf_devel_QA.rst
> index 0b3db91dc1002..a26aa1b9b2595 100644
> --- a/Documentation/bpf/bpf_devel_QA.rst
> +++ b/Documentation/bpf/bpf_devel_QA.rst
> @@ -643,5 +643,6 @@ when:
>  .. _selftests: ../../tools/testing/selftests/bpf/
>  .. _Documentation/dev-tools/kselftest.rst:
>     https://www.kernel.org/doc/html/latest/dev-tools/kselftest.html
> +.. _Documentation/bpf/btf.rst: btf.rst

Applied, thanks.

jon
