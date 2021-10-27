Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE99943D03E
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 20:02:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239928AbhJ0SE2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 14:04:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238448AbhJ0SE1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 14:04:27 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92E71C061570;
        Wed, 27 Oct 2021 11:02:01 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id 67so8426718yba.6;
        Wed, 27 Oct 2021 11:02:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y4Ep56fOfPjwhoMraFFxW5wtkRrwAnAh+988/M+IXBc=;
        b=MPxf5hLKbtPKOnPYmQX3pQjMalBbUHIPoY+DVdJukH85kdrla+XRmMDmLvR+Fi6P95
         IlBIZO0GdSK9BtsTcbfex64fTiEdv4r5uHiYRJBd94iqSuHTBBJviq7Q8ISDbnBPDreI
         FnIZuHfvZOzFv4n69aT97nZNtMQTqU7IkYzo4p9DP/TGf+VoaAtCgDkNJ1sS9qb3OHg0
         CAxXmqIzdBtQHah0cpMGJ7MVRdS2msU8ozI3SbontNQgTc4djocIhQhDA46B6ChChAMF
         Lj5t1xO80nfAfEW8xZTZBkYFXUI9eNmeGMsdJpYslSlrqVSqXDKduJBllxybXxvrlUSB
         3lfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y4Ep56fOfPjwhoMraFFxW5wtkRrwAnAh+988/M+IXBc=;
        b=A+vRdKDk92uBYp2hFTGl37dQF6eWLL6fw4cVA6VR8rHlSPAg+kRPnxB/Ww7s+4isvC
         YqXNkyeRy8YwoAKTOTy17ZvluXBSTdBOPgyb5JACS91nFSdTRxWzLwaeGOT5vBg+1Gej
         yt1ycAKcYnVd8mI8BKEZ5x3kSG/kW2m50aetFYSTdE6WstMiXDzSPIZ11nsOjRO5OB34
         LcIW7xKB0c2d8Y3gkbt6BHH5EyGV4IMYL0wC8Bx3Cw9tDoJstGlfnidAoChZaCbBf2iB
         b8yiQpU1ffmfl4uCJqATjGd++Td6UiH6YUgcXKHq00e/VOMbUVMOrtykpT36wPfyrIvr
         oWHQ==
X-Gm-Message-State: AOAM533a7jSHZyX9hHj1NOxJbm/9tNC+1EhzjF/JCtSlKpoBSMEjwIsl
        HDzweLppE2y7bmUF6UOyxipUTCaxzKFz33V8fuA=
X-Google-Smtp-Source: ABdhPJyW+6P7367fMDFPMV3f5MHc+9YUvSUaztDH9a3u/TlmPD4C7QwMCt24dl6V9SU3pNsVL4xkQ9lLMqr23IavPuk=
X-Received: by 2002:a25:aa0f:: with SMTP id s15mr26612332ybi.51.1635357720816;
 Wed, 27 Oct 2021 11:02:00 -0700 (PDT)
MIME-Version: 1.0
References: <20211026223528.413950-1-jevburton.kernel@gmail.com>
In-Reply-To: <20211026223528.413950-1-jevburton.kernel@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 27 Oct 2021 11:01:49 -0700
Message-ID: <CAEf4BzYoNBZEqdNWYSTrviOs5_4d08ODxL6XSNNHOmqxDRu8Mw@mail.gmail.com>
Subject: Re: [PATCH v2] libbpf: Deprecate bpf_objects_list
To:     Joe Burton <jevburton.kernel@gmail.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Joe Burton <jevburton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 26, 2021 at 3:35 PM Joe Burton <jevburton.kernel@gmail.com> wrote:
>
> From: Joe Burton <jevburton@google.com>
>
> Add a flag to `enum libbpf_strict_mode' to disable the global
> `bpf_objects_list', preventing race conditions when concurrent threads
> call bpf_object__open() or bpf_object__close().
>
> bpf_object__next() will return NULL if this option is set.
>
> Callers may achieve the same workflow by tracking bpf_objects in
> application code.
>
>   [0] Closes: https://github.com/libbpf/libbpf/issues/293
>
> Signed-off-by: Joe Burton <jevburton@google.com>
> ---

Applied to bpf-next, thanks. Please specify kernel tree next time
(i.e., [PATCH bpf-next] subject prefix)


>  tools/lib/bpf/libbpf.c        | 8 +++++++-
>  tools/lib/bpf/libbpf.h        | 3 ++-
>  tools/lib/bpf/libbpf_legacy.h | 6 ++++++
>  3 files changed, 15 insertions(+), 2 deletions(-)
>

[...]
