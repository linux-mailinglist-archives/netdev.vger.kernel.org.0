Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 823DF264D5C
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 20:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbgIJSlA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 14:41:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726729AbgIJSTA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 14:19:00 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54E02C06179A;
        Thu, 10 Sep 2020 11:18:55 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id b19so9397082lji.11;
        Thu, 10 Sep 2020 11:18:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=u0QoUpdiWuk/TleG1WhXpC/jMx3rJkmmsyPPORRnaNA=;
        b=DkxDHZCeEq8gImW5b5s9dmFvlHa7JdgopAVHLW/ZIzpQoQYlG1BQYvWo9DEfzyX5VS
         XJJ/yAafniBhM+cS9/LPxScGdLhajuJwnRmQnqlj6tBczIFlJ0wSo7+cR7XA3BUT2x7E
         8RuxLMxEPJ18bJrs/9uRZbV/MP6Xcw7AMCfc/xz0U5Nmib3IxJEID2mjR0t6h/NIND+O
         qups0J0Kc09djdWDzYfxNS6Q5tbHVOVU9BoCmL7/dDUSmBbrNkrOzxnG3cNu5WfwnhSx
         VzJyjItHcEqp0osjRRLSk2JfDUnaQoaMnMfnEQ0BDcReJXzFrksAeWuFv/xjCcyUVtHZ
         RVhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u0QoUpdiWuk/TleG1WhXpC/jMx3rJkmmsyPPORRnaNA=;
        b=EHtUriED04c5mk6R9VGzcVxj2oZB/xQspkGuMqtX10gty3SVU9wEgKBqSnKflFk6Ia
         lCKfERwkxJ3hHuzGlkJ5WaxerYpV0zYPmVwW06MuYAE0/HZPdbGF6HUPzKAiK4s9XKk+
         PxCjtmfamIvjakI+el6VqN1lGtYMqBfcF2uvOdblqQ3TLJtqMjzr3Mi4GlJLyfZkbY7B
         KKNUmsyBtZ4kILeRjAVcovN/9P1PrlQzeJG+Sfv1ToX6mFwk4QctbDtsIydBEy2nGvif
         dBCtwdmzLlyC6nV6yK/71pVhzmYM0xfr2ncF2CiThzM2kJHZkgAyNi72DWMqE39aCLvI
         NA7A==
X-Gm-Message-State: AOAM530O2JBz377OacMgzlZ/+gJJYtT3XGYCHWgjz3KGAJRIynThg0i1
        oTAwbgqsyEoXtgtEzMOFSzWkhorVUpJIAIaIW+w=
X-Google-Smtp-Source: ABdhPJyRz5V7THDsiTRBjlBEFsRmiRLAIZm1vHZm6P/v2qrNprvpIZsrwl+bOqx70qaO+kvUOtzO44C61GDp+vedvJM=
X-Received: by 2002:a2e:808f:: with SMTP id i15mr4815444ljg.51.1599761933699;
 Thu, 10 Sep 2020 11:18:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200909162500.17010-1-quentin@isovalent.com> <20200909162500.17010-4-quentin@isovalent.com>
In-Reply-To: <20200909162500.17010-4-quentin@isovalent.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 10 Sep 2020 11:18:42 -0700
Message-ID: <CAADnVQ+b3y1LFRppZu5GYW6hZY6nSZc3wQKqpqHbevdNHNSCSA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 3/3] tools: bpftool: automate generation for
 "SEE ALSO" sections in man pages
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 9, 2020 at 9:25 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> The "SEE ALSO" sections of bpftool's manual pages refer to bpf(2),
> bpf-helpers(7), then all existing bpftool man pages (save the current
> one).
>
> This leads to nearly-identical lists being duplicated in all manual
> pages. Ideally, when a new page is created, all lists should be updated
> accordingly, but this has led to omissions and inconsistencies multiple
> times in the past.
>
> Let's take it out of the RST files and generate the "SEE ALSO" sections
> automatically in the Makefile when generating the man pages. The lists
> are not really useful in the RST anyway because all other pages are
> available in the same directory.
>
> v2:
> - Use "echo -n" instead of "printf" in Makefile, to avoid any risk of
>   passing a format string directly to the command.
>
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> Acked-by: Andrii Nakryiko <andriin@fb.com>

This patch failed to git am, but I've applied the first two patches.
Thanks
