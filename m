Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4080379AFC
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 23:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388613AbfG2VWA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 17:22:00 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:37159 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388163AbfG2VWA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 17:22:00 -0400
Received: by mail-qk1-f195.google.com with SMTP id d15so45060067qkl.4;
        Mon, 29 Jul 2019 14:21:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C84sxv73eH75Clfr5+rTq2+e4XDmVFZtJVK23fY/sHM=;
        b=LKkl6KJ1MXhVSzBW+x95+svZbssvymwD1VSyP/YOUt/5TdzXf3LsJJDvnhyB6FL9or
         zJGSbknaGvz2bGziwOmxNK7uoyxDcVvadSJunvQuk10Ft1gJ6B0zuYS1uwiis6fTJWFP
         RxBgNC2ZlED6HF25CM0nnOXChOMe7zue41Hk+Tm/A8HNm6RsPRfUlFlcJ46CAds2+o9l
         KW385H1cQqfqFfMZoHqpj2V5/PojueJMVzeqK8f8hMA0ZjgF2xXwm80hpaz/pwnJBMfU
         EmS61ekreqrYErWj4nF56l66lL3AMqPFV6R0paLbnNwPT4+sYE2BCyBcc+7xlvxQeU2s
         vBvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C84sxv73eH75Clfr5+rTq2+e4XDmVFZtJVK23fY/sHM=;
        b=mAHDd+1Efeq10p0FFLKkW6m3MhKZ1jYTxPwTWu//hBNgucpOrBOJCgJhnxHKZrD2Lv
         UgnH0lAyg9iD87siU2yWl8u0/AYyZHMyGeptlOrrdFyXVXhCCOJ7kc/HMfL7BsqaQ7AV
         85lVNNeeOi9cWySFuklodyppIQ9FFfJfnyEL5Gm2O+oHBH+QdvMNMpGV+pILzIIeNeki
         E8mC35G/ZZxdIlHIraEiQ4QKAMrRGJXFvPSNJxPX4ybF9ZD9awBZIFssnkFow4rxkkB/
         hH8BnvsKjgAm6+50U7w2IU7QrEqAVxFlUcmqAkd5CdSnVKr99sbUrKYeniSmh5cn1Ev+
         Ht5g==
X-Gm-Message-State: APjAAAVuic9vayIqyOWRnAR59cfzFpyo7ceIjHMrm8+cXFmJIhN4r3Ij
        quhLw8Fu6npLFi5zpNZAub8L82jqiM5OMAReqmk=
X-Google-Smtp-Source: APXvYqy9WURouUYeZEJy0seHA+97fHcw0pFiQe6HAtY535q6sRjqX6lZF8ccs1lUGtr3RtvpMHbrxvT7WPChkz5VPD4=
X-Received: by 2002:a37:6d85:: with SMTP id i127mr74136475qkc.74.1564435319121;
 Mon, 29 Jul 2019 14:21:59 -0700 (PDT)
MIME-Version: 1.0
References: <20190724192742.1419254-1-andriin@fb.com> <20190724192742.1419254-11-andriin@fb.com>
In-Reply-To: <20190724192742.1419254-11-andriin@fb.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Mon, 29 Jul 2019 14:21:48 -0700
Message-ID: <CAPhsuW5UORgSG1nh1YxEskpJcrpGegxV6x5FXwfADaERi-z6HQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 10/10] selftests/bpf: add CO-RE relocs ints tests
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 24, 2019 at 1:34 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Add various tests validating handling compatible/incompatible integer
> types.
>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>
