Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90AF4121EA3
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 23:56:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbfLPW4Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 17:56:25 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:43968 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726561AbfLPW4Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 17:56:25 -0500
Received: by mail-lf1-f67.google.com with SMTP id 9so5494601lfq.10;
        Mon, 16 Dec 2019 14:56:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UmDUqTKmIWEPc54Kd+GJ1ToNmeS9g1WDsbZxI3NXmjA=;
        b=HIeOpyO1M5+U7CyzW94D6bxZNaqLuE0ISdVmnDirPhBVDyx1PMqWOMXzJhwiZHFaXa
         YwVKHC0In16z/FgrSc2Ewx80eKvQYnMGTcIduyMjDxPsaRNUGGAEaeFI+bKVpiaZ4hrC
         Kp1anypdaWvafsq3Xbdf4eavCe5LHmRK51jLih2M6aqGmGbMlXZqzRNGUrSibH4m8xL7
         66hV3wVdkYM4Y9mQgGqPMxn7L2svDyqfmTcyzz/LWl3/1Q7HgLCQZrW2Ahi7KxmVt3HQ
         WOpyWgP9sBsEsmQwU821CgdH9haH2R2XG04J+5t6/xw76agQM/TFCFdqjZivz4tTzaNh
         k8Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UmDUqTKmIWEPc54Kd+GJ1ToNmeS9g1WDsbZxI3NXmjA=;
        b=q1NRwANvinrjT9/weatYjZKB/CG+8dLayorfsVbxGQVcVNXswcEKyWdOV0bXrZPi43
         D9thYm+y4BmPHfDGNIWGH62pFRHDyOZvnlLRJSF3ufcfHdDjpNSFeWywY1da1Q2Ek5X4
         4Vtxouzah2ZoZD6xebzD9oBlsBYv1pCOqRqGumA2GPcuc0SHLA3c1OEs9U1X9GFlUdJM
         HMZWXJy3XqfCfLO3k11fq4wLQNROAPgRVrG41/5O3nWydMqFxOziqE/d3oylQs7By1bY
         592zIT9KbnsAM5Fgng9TrM85Y4EyMfvmLQCc9QR7KyG6UKbWcrptX3Vm2fSCwAoTzkvi
         XI+w==
X-Gm-Message-State: APjAAAWXA2Iwte+Cihp6USnHBZ6jZi2tU+SggpkxA+A5tEMlc7A+HlRQ
        CGyTvnD0vxA93o46xdbUX280hOOqAZwh8NcFVOM=
X-Google-Smtp-Source: APXvYqwwd4qOLBBpBONY15YUITIVQ/yqVXh68Mzdjo2u+s+egNLhsIx2G5puFiBxXpNoUOvyFV+YZ9OZsZIJwJnk7XY=
X-Received: by 2002:ac2:44d9:: with SMTP id d25mr919909lfm.15.1576536983459;
 Mon, 16 Dec 2019 14:56:23 -0800 (PST)
MIME-Version: 1.0
References: <20191216183830.3972964-1-andriin@fb.com> <b50659cb-4dcc-110e-e770-31615a11b5e7@fb.com>
In-Reply-To: <b50659cb-4dcc-110e-e770-31615a11b5e7@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 16 Dec 2019 14:56:12 -0800
Message-ID: <CAADnVQJXo0Ly4aeeg03Ku01bhU-pOY-Lhf0gEbbBJ24_=0pzNA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: add zlib as a dependency in pkg-config template
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>,
        Luca Boccassi <bluca@debian.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 16, 2019 at 11:34 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 12/16/19 10:38 AM, Andrii Nakryiko wrote:
> > List zlib as another dependency of libbpf in pkg-config template.
> > Verified it is correctly resolved to proper -lz flag:
> >
> > $ make DESTDIR=/tmp/libbpf-install install
> > $ pkg-config --libs /tmp/libbpf-install/usr/local/lib64/pkgconfig/libbpf.pc
> > -L/usr/local/lib64 -lbpf
> > $ pkg-config --libs --static /tmp/libbpf-install/usr/local/lib64/pkgconfig/libbpf.pc
> > -L/usr/local/lib64 -lbpf -lelf -lz
>
> Even without this patch, I already got -lz for static link libraries:
>
> -bash-4.4$ cat libbpf.pc.template
> ...
> Requires.private: libelf
> ...
> -bash-4.4$ pkg-config --libs --static
> /tmp/libbpf-install/usr/local/lib64/pkgconfig/libbpf.pc
> -L/usr/local/lib64 -lbpf -lelf -lz
>
> libelf depending on zlib. Maybe -lz is introduced due to libelf.
>
> But in any case, add explicit dependency to zlib from libbpf probably
> a good thing since libbpf directly uses its API functions.
>
> Acked-by: Yonghong Song <yhs@fb.com>

Applied. Thanks
