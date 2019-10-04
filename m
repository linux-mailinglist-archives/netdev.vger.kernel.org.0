Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A06BCBBA7
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 15:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388333AbfJDN2n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 09:28:43 -0400
Received: from mail-yw1-f68.google.com ([209.85.161.68]:45065 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387917AbfJDN2n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 09:28:43 -0400
Received: by mail-yw1-f68.google.com with SMTP id x65so2296530ywf.12
        for <netdev@vger.kernel.org>; Fri, 04 Oct 2019 06:28:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SJ7CCnD1jTxfZuxTs/1AVjjbv5IpNVPSc0ZEPRh0OKI=;
        b=FadOvkOXdWEiDuMssODR6PdMLpTYUWUWQq5QEJlTWwy/qqEYDdjlFzUXSDcloL5VGP
         /r9RGWkYOZT2/Ro9bqPTDZrYvQdqpsWMzdgrpRW6uzT4AMOZz5sb+vfaBGxEimJ7MZBf
         euZv5kj752ZSTD4Av+r5wek6xoXDQeteJ8b9ZjR68Lvcc4k+aLv3Vp6xSWPNyokgYMas
         QHbv0bP9TslsQ/Eo3oGty1b8UPmjmeRJQ+ThZxfDIk2hvMQZGxMW6L+zJ7a8+lRKSzxJ
         69DjSuMmItu2t5pY1KkxRV4a8u39Ekqb8TXcVpQ45tVx3TiyfdW2DNNz/X7DpCZwCGDL
         P1xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SJ7CCnD1jTxfZuxTs/1AVjjbv5IpNVPSc0ZEPRh0OKI=;
        b=lDTxJgvtOk2hCSgVUYE0ndX+9UWAKDhGaauAvSvNMtvCHKmEPIbFZOt9x16iz7HPTQ
         Rd5edTKu9FF/EoudfTZfa77554c0DnQwKBa/fdv0SS20wvUFmazUUq3hzkq3z1/muTPf
         mM9x6Gr5fw1sKf72vXcbCJEfhGbTJI/pWQ1GwRAeh6s2yTLb380NeIAU8Yx47iBN0xDZ
         hqzI1dwPNTFOgi1xHJ5JVhlnHJQKev775umFAf2YW0Gjqd6wq4Vu9AfvL0Lbo+qOh8Ns
         tk5CNs+sVWrsyiL/ABphtSnnFUuoLWiEckqB/xoirvBfXpTUr2BqiVAVpRJmrzBwY5VK
         951Q==
X-Gm-Message-State: APjAAAVhTKUlzhUtPpWY6wHJKxZhA7XxrW9vuZB1+UuQQ/M+uP/lZiXH
        4sLxFeEH/Hiv737258ar7+F77pTaNg5yledgRXn2y20H1g==
X-Google-Smtp-Source: APXvYqw4YRPNuFii01nJ/wiZ26SR8mVbF3dB8B/jWLnz4YG09rgvvPmQYw0mai2jDEMjmrDS0m4Nt2ZtpgYQZBLdb6I=
X-Received: by 2002:a81:7dc5:: with SMTP id y188mr10304818ywc.69.1570195722335;
 Fri, 04 Oct 2019 06:28:42 -0700 (PDT)
MIME-Version: 1.0
References: <20191004013301.8686-1-danieltimlee@gmail.com> <20191004145153.6192fb09@carbon>
In-Reply-To: <20191004145153.6192fb09@carbon>
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
Date:   Fri, 4 Oct 2019 22:28:26 +0900
Message-ID: <CAEKGpzj9WGepw4LPJeFhbtONYJyvLcO_ChnMRrEB5-BVTfKqMQ@mail.gmail.com>
Subject: Re: [v4 1/4] samples: pktgen: make variable consistent with option
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 4, 2019 at 9:52 PM Jesper Dangaard Brouer <brouer@redhat.com> wrote:
>
>
> On Fri,  4 Oct 2019 10:32:58 +0900 "Daniel T. Lee" <danieltimlee@gmail.com> wrote:
>
> > [...]
>

Thanks for the review!

> A general comment, you forgot a cover letter for your patchset.
>

At first, I thought the size of the patchset (the feature to enhance)
was small so
I didn't include it with intent, but now it gets bigger and it seems
necessary for cover letter.

When the next version is needed, I'll include it.

> And also forgot the "PATCH" part of subj. but patchwork still found it:
> https://patchwork.ozlabs.org/project/netdev/list/?series=134102&state=2a
>

I'm not sure I'm following.
Are you saying that the word "PATCH" should be included in prefix?
    $ git format-patch --subject-prefix="PATCH,v5"
like this?

And again, I really appreciate your time and effort for the review.

Thanks,
Daniel
>
> --
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
