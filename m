Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 771AC1D8BD4
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 01:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbgERXtI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 19:49:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbgERXtH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 19:49:07 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8E1BC061A0C;
        Mon, 18 May 2020 16:49:07 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id n22so7255175qtv.12;
        Mon, 18 May 2020 16:49:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f+AY3FRaJmalcu4pX+pebzZ1sSzojNFexqC9nPXOHDA=;
        b=PPiv03doHBPiQaLfhP0vGLpZ+cWsqtMDcGZtDkNmGF0XAS+AvQB8+H9xAs0NPWafJz
         mChlxx3CoLR6BMF2WVFelYzEr2bYS0m3D/xBhzSaseTIfpyjVIPICw2Ag4EVa2l6EbPe
         37io0Efzx8HFNsk0iWDPKMY9fbWspXZdp3AfCZRYgLt0d4pNiyN0lu9Erx8qvkk/pKGq
         mSqaPLWbIkGY4mThBk9Y0VS3d4oSadGu4BDWPE6EdGWKpeTiCPLNb+8Z+X93KaCBcxGV
         0kirSpcxIcaCAOJVlT180srxVEwxNPANope2yFdD7iBNuZP+1V5L14Nyl0VPIBB3nKs1
         CVOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f+AY3FRaJmalcu4pX+pebzZ1sSzojNFexqC9nPXOHDA=;
        b=IySDpNlmewnToHLhAB6VfguE4/XKpAy/qG9uTzNh1595oI5VtrjLCnEB+CIRRj/xKh
         IqAkR0mDv7QJFzUL8fJ/EGVHtyqvnZOvYihH1oCjrY0VFm2h0sKKtjkuw+1A17EbLV5i
         W0cwWjLzOtao3EsseNV6S5X3HChUOgBLRQvUpOSyn0DgTpgH/mJb9lpfisATBHETik4W
         aGtBZ/7vUD4UXVabox+YHH8UpfiGojAh1AsSuRCOiYrMCfuxUnfqsrlnlx+YZOV8RyT6
         cYIr3qa2qiFe2qRPkxMJVr+0Xg8Ap2smMalmHRo7BT+ag1S7EvOMT56J/i184lvpwxoS
         US2w==
X-Gm-Message-State: AOAM531M1RPriNaqOJPk/nmCBnWo5HGtoxeh78OEecxNR2jFpm0SWeRl
        241O1qSm4x6qVkxVTmcseRWIWHBs8IUYou3aXTM=
X-Google-Smtp-Source: ABdhPJyvDOL7ag5J1IVA9/sORGWCwqv4imVl7lZONC8RM8xWipV5wfm6Q9qoFuNT4F4B4e1kwDO8Zu2xw0JLZtpCKLw=
X-Received: by 2002:ac8:1ae7:: with SMTP id h36mr18950456qtk.59.1589845747017;
 Mon, 18 May 2020 16:49:07 -0700 (PDT)
MIME-Version: 1.0
References: <1589800990-11209-1-git-send-email-alan.maguire@oracle.com>
In-Reply-To: <1589800990-11209-1-git-send-email-alan.maguire@oracle.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 18 May 2020 16:48:55 -0700
Message-ID: <CAEf4BzZZxXhO4QZ4XVYjd3SS2z9NHY6c-_ivvvE2nkCcA1iQPw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: add general instructions for test execution
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 18, 2020 at 4:24 AM Alan Maguire <alan.maguire@oracle.com> wrote:
>
> Getting a clean BPF selftests run involves ensuring latest trunk LLVM/clang
> are used, pahole is recent (>=1.16) and config matches the specified
> config file as closely as possible.  Document all of this in the general
> README.rst file.  Also note how to work around timeout failures.
>
> Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> ---

Awesome, thanks.

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/testing/selftests/bpf/README.rst | 46 ++++++++++++++++++++++++++++++++++
>  1 file changed, 46 insertions(+)
>

[...]
