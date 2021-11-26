Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC02445E804
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 07:43:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352592AbhKZGqf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 01:46:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:43340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345984AbhKZGod (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Nov 2021 01:44:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C15C6115B;
        Fri, 26 Nov 2021 06:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637908881;
        bh=AUXyQOGOWNAzps8KIoh/n32oJ/jyu+SFPv0P+hCkpkA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=pXoxpA0Z6gGvKjcDt6+gT6TR2RTSMcmL1Na8bx34P91wwn7yKujTWwohzxw3ZwB3S
         QCj04fh/VlIwyT4eBJMYcVrpYJSk2yyG3CemuWtS3R7Yw1Ve5SkNxZr1/quM1UjWCq
         9aUpLUAQ2GS7MO/idSra+jyatM+9QpZrESiP+XJAHoFyLcR1NSy+MW76Kt2gn4sfrG
         6lJfBtC7AkOy6jBaqgnvvkvKGe113ANBOo4bRvbBOebz5gJVO3CPYlTzalIqz0+2xa
         IIrDHN1oqG9pjxKCvZR652Mi8n9nnxETZR+JRRsIQZ4cpsxeGKclzfF7KncmT8lkKd
         3dAK8wccmJofA==
Received: by mail-yb1-f174.google.com with SMTP id g17so17517378ybe.13;
        Thu, 25 Nov 2021 22:41:21 -0800 (PST)
X-Gm-Message-State: AOAM533vbYJ1IWnyvuY1mH74nCSeYQg78vHlflbuuvtm8Tq+/vHgNiAW
        5ouh4pQdxCG1bVeex3QkSRUyVq9A88sQHNyEsyA=
X-Google-Smtp-Source: ABdhPJxlpUsnFBSc8Rfq5LfioaeutmMDqCDcv5lcgpfQz9zptDwIgOmOdob7MBfDuX9yy+hd3Sxr2A/vm8ZqGCBn6v8=
X-Received: by 2002:a25:bfca:: with SMTP id q10mr13234674ybm.68.1637908880328;
 Thu, 25 Nov 2021 22:41:20 -0800 (PST)
MIME-Version: 1.0
References: <20211119163215.971383-1-hch@lst.de> <20211119163215.971383-6-hch@lst.de>
In-Reply-To: <20211119163215.971383-6-hch@lst.de>
From:   Song Liu <song@kernel.org>
Date:   Thu, 25 Nov 2021 22:41:09 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4fG7hUTFaC6Ht4Ae9m_1N-LXYHxSH4QZZhHcOMundjAA@mail.gmail.com>
Message-ID: <CAPhsuW4fG7hUTFaC6Ht4Ae9m_1N-LXYHxSH4QZZhHcOMundjAA@mail.gmail.com>
Subject: Re: [PATCH 5/5] bpf, docs: split general purpose eBPF documentation
 out of filter.rst
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 19, 2021 at 8:32 AM Christoph Hellwig <hch@lst.de> wrote:
>
> filter.rst starts out documenting the classic BPF and then spills into
> introducing and documentating eBPF.  Move the eBPF documentation into
> rwo new files under Documentation/bpf/ for the instruction set and
> the verifier and link to the BPF documentation from filter.rst.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Song Liu <songliubraving@fb.com>

[...]
