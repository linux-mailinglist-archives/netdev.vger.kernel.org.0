Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 738A16B376
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 03:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725912AbfGQBna (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 21:43:30 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:34760 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725850AbfGQBna (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 21:43:30 -0400
Received: by mail-lj1-f196.google.com with SMTP id p17so21929843ljg.1;
        Tue, 16 Jul 2019 18:43:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CBYf8JDvHIrto2ruQvIgRvAFcsxBu3VLgXTo2m9l288=;
        b=pWHMntmBUFFbR9oOTYhXOQIKrb9utEAL5LKLoV631LAk6sDw69BsIdDJg/CyHfgv/A
         puDBYitmhvwK/Xk5E/2pYJ1e5JBOY2i9mXZsoDxUZUtBFgR3ViVJMiFSYiPhq7aCeuDR
         4Irf+accjwCqmcghCX4d0G52c/t+6mH9wEN7mkADXRM9p+G8XJ661frwlqE2WQHZG3OI
         9kAnxILD7Shju5xC/MGcDkO/cmXLde9huq0D5+oNQV3AWF+mt6pFKlcKKi3AqffjtxYc
         IdX7z3L/i61rqC7OEKYjGLBJUAoQ+ruxfToYi4ScDvhXGjpc7a6cooOPSgfMGEVXOpjp
         W3jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CBYf8JDvHIrto2ruQvIgRvAFcsxBu3VLgXTo2m9l288=;
        b=WwTXWZbTKUDb4j9nVBUYfJdszYsl2WRUvB/uxXdyQVR8nr1inMB8bZnRbC0xEJMhf0
         zOH25c3jUkTA0+RaZLftTnK6HfE7Eg1+Cm77uxdv6MvOoAuUZ99k3mDMf8E6kDkqjoI/
         HN51r6ZJ8DYaBT38inILcP8ECUe1bPh81NTHEpYg5pQaZvAVdVZMXZpz71a25y17oFIb
         D+LDmNRruWwl7RBqclTvDnpZ+pBH403KKm6N8wJUnEaPAzhyjk5rEGCrA2RMebXGMTy4
         ZfRs/BHfn4jjWFXHq8twGn+cVJpENF3Qk9BvnQnseU7Md/Iyzs08uyR0slCDblQD6YAL
         VBXg==
X-Gm-Message-State: APjAAAXaaNQoJlwetZUg9dwlgBKytsJUjX6fHRclREJ+nJNVvKQkDIfl
        wToBhakxr8uxG7de6ucQLqWyxx8SijuhCQu2fLk=
X-Google-Smtp-Source: APXvYqyTZ7w25HCHw8hXV1ZpEi+UD3/Oxu9Thn0/cjED4IiVi70hWzZhmlgx6Wv9+JRrjdJGuZ4qrb4kOSOIQ3sClnU=
X-Received: by 2002:a2e:7818:: with SMTP id t24mr1008616ljc.210.1563327808247;
 Tue, 16 Jul 2019 18:43:28 -0700 (PDT)
MIME-Version: 1.0
References: <20190716125827.24413-1-iii@linux.ibm.com> <CAEf4BzbWVJcQ2pN9UwYagtBpgoL+8Q+DMwwiUt1iCMciH8YUKA@mail.gmail.com>
In-Reply-To: <CAEf4BzbWVJcQ2pN9UwYagtBpgoL+8Q+DMwwiUt1iCMciH8YUKA@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 16 Jul 2019 18:43:16 -0700
Message-ID: <CAADnVQJU+mvFoqU-tDK3dHM4UyNR9GX+jtB8j-mREHwZgw+pOg@mail.gmail.com>
Subject: Re: [PATCH bpf] selftests/bpf: fix perf_buffer on s390
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Ilya Leoshkevich <iii@linux.ibm.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, gor@linux.ibm.com,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 16, 2019 at 10:42 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Tue, Jul 16, 2019 at 5:59 AM Ilya Leoshkevich <iii@linux.ibm.com> wrote:
> >
> > perf_buffer test fails for exactly the same reason test_attach_probe
> > used to fail: different nanosleep syscall kprobe name.
> >
> > Reuse the test_attach_probe fix.
> >
> > Fixes: ee5cf82ce04a ("selftests/bpf: test perf buffer API")
> > Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
> > ---
>
> Thanks for the fix!
>
> Acked-by: Andrii Nakryiko <andriin@fb.com>

Applied. Thanks!
