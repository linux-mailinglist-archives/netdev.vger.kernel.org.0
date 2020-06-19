Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8A881FFF6E
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 02:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729508AbgFSAru (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 20:47:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727109AbgFSArs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 20:47:48 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 501D0C06174E;
        Thu, 18 Jun 2020 17:47:48 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id g18so5985215qtu.13;
        Thu, 18 Jun 2020 17:47:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:user-agent:in-reply-to:references:mime-version
         :content-transfer-encoding:subject:to:cc:from:message-id;
        bh=+4+6CvG1C/38bGjDcBVwLXZkjFZscNoT61+OCP1gY7o=;
        b=IcNjupV8ri81Ub3p46dVIJIRXXr4WqedCZOfuEgXozHxf83HYqNNu3//hTUCVv2hj2
         oxUmYu3yFHZA5bzpvCjinV64ZjYYPjB8RBuDgcssaWiu11i+HGjmXvydx0ycF2uSKIZY
         9rtKW/5rF1YaqjjZo9S943U97YEoB7xtt6l94hDhfDAVGz5Us89+g9jvOHQIWxlenAP5
         +tcCpwZSjhCdmJB0pxa8EeKpzIi/2cTIPsXFQ4EbCNcOrVwbyDTBR0fAfVX/Yswau8nv
         QVmU1RnuqvvWCgKwzds4P2hk7E2aFYGpZ7j+PRyX/crYDsD5hDisDloFV9sfvRaeFJ5F
         7Ztg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:user-agent:in-reply-to:references
         :mime-version:content-transfer-encoding:subject:to:cc:from
         :message-id;
        bh=+4+6CvG1C/38bGjDcBVwLXZkjFZscNoT61+OCP1gY7o=;
        b=mjW0MM5n1EBY3ChBCK5XvGJ4mvXbzfV07ho7c5H1xPi4TfHTNAymKYgySry1JEhy9P
         1T6U0i0zJtbWS0h9IeC+gBSqW8EzhpMUmbVBZdNNlP9Il+FMVWXky3Hwzynvax67hT9E
         i5Ztx9OQv0CcpP8zplUb/tiojpNIgDckjPNrr75/6rXevy7Dx883lhaOhaaJzgHq0qKz
         HIp4/fg/HSIfypJU2drMCtHUaEChyikBqx+fiDnyDOhv+WnrOMXcH2KUnaXEeRC9c8tC
         YOv6b/glDAzgdrYoxshcqdBw4n4VQTCgq3Mdi+3F0nzrA5s2ptA7kVlem+Q8cGXPqyub
         AR0g==
X-Gm-Message-State: AOAM531zAeIcYdx95jxbkwDgm3da88P4vCCMLnbbIhw8OerwWVr/xqDp
        EbGnPex44nUmZ4se6nhno6w=
X-Google-Smtp-Source: ABdhPJwUq6qZNGPPEaKRzL/4/+/2NXFdk1B5gzf0iRym22QIhpq+jkJRkEqntXuYValv+wVGkD73rQ==
X-Received: by 2002:ac8:668f:: with SMTP id d15mr972556qtp.113.1592527667455;
        Thu, 18 Jun 2020 17:47:47 -0700 (PDT)
Received: from [192.168.86.185] ([179.97.37.151])
        by smtp.gmail.com with ESMTPSA id n63sm4162234qkn.104.2020.06.18.17.47.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Jun 2020 17:47:46 -0700 (PDT)
Date:   Thu, 18 Jun 2020 21:47:03 -0300
User-Agent: K-9 Mail for Android
In-Reply-To: <CAEf4BzaL3bc8Hmm20Y-qEqfr7kZS2s8-KeE8M6Mz9ni81CSu4w@mail.gmail.com>
References: <20200616100512.2168860-1-jolsa@kernel.org> <20200616100512.2168860-3-jolsa@kernel.org> <CAEf4BzaL3bc8Hmm20Y-qEqfr7kZS2s8-KeE8M6Mz9ni81CSu4w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 02/11] bpf: Compile btfid tool at kernel compilation start
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Message-ID: <F126D92D-E9D8-4895-AA4E-717B553AC45A@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On June 18, 2020 9:40:32 PM GMT-03:00, Andrii Nakryiko <andrii=2Enakryiko@=
gmail=2Ecom> wrote:
>On Tue, Jun 16, 2020 at 3:06 AM Jiri Olsa <jolsa@kernel=2Eorg> wrote:
>>
>> The btfid tool will be used during the vmlinux linking,
>> so it's necessary it's ready for it=2E
>>
>
>Seeing troubles John runs into, I wonder if it maybe would be better
>to add it to pahole instead? It's already a dependency for anything
>BTF-related in the kernel=2E It has libelf, libbpf linked and set up=2E
>WDYT? I've cc'ed Arnaldo as well for an opinion=2E

I was reading this thread with a low prio, but my gut feeling was that yea=
h, since pahole is already there, why not have it do this?

I'll try to look at this tomorrow and see if this is more than just a hunc=
h=2E

- Arnaldo


--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
