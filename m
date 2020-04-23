Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 804411B5C11
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 15:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728527AbgDWNCg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 09:02:36 -0400
Received: from ms.lwn.net ([45.79.88.28]:44248 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726685AbgDWNCd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Apr 2020 09:02:33 -0400
Received: from lwn.net (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id 649DA5A0;
        Thu, 23 Apr 2020 13:02:31 +0000 (UTC)
Date:   Thu, 23 Apr 2020 07:02:30 -0600
From:   Jonathan Corbet <corbet@lwn.net>
To:     Bolarinwa Olayemi Saheed <refactormyself@gmail.com>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        skhan@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Stephen Kitt <steve@sk2.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        "Guilherme G. Piccoli" <gpiccoli@canonical.com>,
        Kees Cook <keescook@chromium.org>,
        Masanari Iida <standby24x7@gmail.com>,
        Eric Biggers <ebiggers@google.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH] docs: Fix WARNING - Title underline too short
Message-ID: <20200423070230.3fd863ba@lwn.net>
In-Reply-To: <20200423114517.18074-1-refactormyself@users.noreply.github.com>
References: <20200423114517.18074-1-refactormyself@users.noreply.github.com>
Organization: LWN.net
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Apr 2020 13:45:17 +0200
Bolarinwa Olayemi Saheed <refactormyself@gmail.com> wrote:

> From: Bolarinwa Olayemi Saheed <refactormyself@gmail.com>
> 
> There were two instances of "Title underline too short" and they were
> increased to match the title text.
> 
> Signed-off-by: Bolarinwa Olayemi Saheed <refactormyself@gmail.com>
> ---
>  Documentation/admin-guide/sysctl/kernel.rst | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

These warnings are caused by a patch entering linux-next via the -mm tree;
Randy has already sent a patch to fix them.

[Next time you might want to examine the recipient list a bit; this patch
was broadcast a bit more widely than was really necessary.]

Thanks,

jon
