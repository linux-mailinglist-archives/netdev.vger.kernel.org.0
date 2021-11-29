Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13A58462420
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 23:13:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231979AbhK2WQl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 17:16:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231984AbhK2WQj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 17:16:39 -0500
Received: from ms.lwn.net (ms.lwn.net [IPv6:2600:3c01:e000:3a1::42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41F95C0E49B2;
        Mon, 29 Nov 2021 13:50:44 -0800 (PST)
Received: from localhost (unknown [IPv6:2601:281:8300:104d::5f6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id A83DC2CD;
        Mon, 29 Nov 2021 21:48:42 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net A83DC2CD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
        t=1638222522; bh=39Wf2jQacq55Jsij//SwK4jCDJVc1MaR/DIe2vg0nK4=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=BPyMy+zVcVhpN0/7pbgHM7TivyCjGoBSJEAyPq3G3hcxOzNjUqWACwwS1K1n7k/gO
         h6gETcTpEgugfhHPiq7FyFUYD6tQdYnXjUSvpBYWneyssfWLkdYBA9Ng2DDQ+hgiCu
         nVRQTHATJZJHW0S15fOOJAWhN/iSNsE2VtFSe1RLyrpRvJ7Ddck9yG8/+UWQ5Y81XX
         PDQU8HIGDO8xaxbgj5t9i38qwwfQQ4imm33SoM+nxRgaCjgrhNiopUZlXRS9IPJeT+
         36OekPjlZV7uU8yCuE5bqNEfzV6gNSyKLfj0BRX9HcIWrgVE+ehKTgEKRnHMmGqG5h
         2QbCWm3I5FbWg==
From:   Jonathan Corbet <corbet@lwn.net>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1 v2] Documentation: Add minimum pahole version
In-Reply-To: <YZfzQ0DvHD5o26Bt@kernel.org>
References: <YZfzQ0DvHD5o26Bt@kernel.org>
Date:   Mon, 29 Nov 2021 14:48:42 -0700
Message-ID: <87k0gqsked.fsf@meer.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Arnaldo Carvalho de Melo <acme@kernel.org> writes:

> A report was made in https://github.com/acmel/dwarves/issues/26 about
> pahole not being listed in the process/changes.rst file as being needed
> for building the kernel, address that.
>
> Link: https://github.com/acmel/dwarves/issues/26
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> Acked-by: Andrii Nakryiko <andrii@kernel.org>
> Acked-by: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: bpf@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Link: http://lore.kernel.org/lkml/YZPQ6+u2wTHRfR+W@kernel.org
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>  Documentation/process/changes.rst | 11 +++++++++++
>  1 file changed, 11 insertions(+)

Applied (with the duplicate SOB removed), thanks.

jon
