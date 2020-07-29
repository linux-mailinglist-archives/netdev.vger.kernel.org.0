Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D9472326E0
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 23:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbgG2VhM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 17:37:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:41946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726365AbgG2VhL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 17:37:11 -0400
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30D4020809;
        Wed, 29 Jul 2020 21:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596058631;
        bh=UztyEnGiszZAILnw87KgVUDMvCNr0XqFqxP9dO/xGpw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=tqHm859q/zp4uJFb4WWGa/aIH8ODA7CjKvuMJHjw2hMovYJ0qYme/2LFyZCznuQC/
         NWz7Po6VFagFhI7Atk/9dm8GbbzXrMM4BeVcY7G41VsjJrSpjSfVho5bKpVSWkb7Be
         +EqKdh4u3krI4YmC+QuZk7dyRRMH3WoBQ0Dl+yJM=
Received: by mail-lj1-f170.google.com with SMTP id q4so26684116lji.2;
        Wed, 29 Jul 2020 14:37:11 -0700 (PDT)
X-Gm-Message-State: AOAM5311SEI5+KfE0tmivWYBHWjaGobSxb5r+olrgj5+UTV/kM0p52TH
        ADuAlBy/PWjB2WemAkB3p7Yyfs+BmtZ24WHd4jE=
X-Google-Smtp-Source: ABdhPJxPjWwYTRXjxDZVLzGUttpmVCsB7mzIRrLM32Vd2M6yaMZWNqRvZOSjaBUuVhE8M8amiHr+40g3x+ZDNedxTqU=
X-Received: by 2002:a2e:8707:: with SMTP id m7mr194379lji.350.1596058629542;
 Wed, 29 Jul 2020 14:37:09 -0700 (PDT)
MIME-Version: 1.0
References: <159603940602.4454.2991262810036844039.stgit@john-Precision-5820-Tower>
 <159603984765.4454.3932218162163081929.stgit@john-Precision-5820-Tower>
In-Reply-To: <159603984765.4454.3932218162163081929.stgit@john-Precision-5820-Tower>
From:   Song Liu <song@kernel.org>
Date:   Wed, 29 Jul 2020 14:36:57 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4itNw2YYQ9ncgZL-m08bhwnhOE6FACNxoZVydjukc66w@mail.gmail.com>
Message-ID: <CAPhsuW4itNw2YYQ9ncgZL-m08bhwnhOE6FACNxoZVydjukc66w@mail.gmail.com>
Subject: Re: [bpf PATCH v2 5/5] bpf, selftests: Add tests to sock_ops for
 loading sk
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 29, 2020 at 9:26 AM John Fastabend <john.fastabend@gmail.com> wrote:
>
[...]
>
> Notice it takes us an extra four instructions when src reg is the
> same as dst reg. One to save the reg, two to restore depending on
> the branch taken and a goto to jump over the second restore.
>
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>

Acked-by: Song Liu <songliubraving@fb.com>

[...]
