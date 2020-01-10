Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A059013676B
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 07:29:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731552AbgAJG30 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 01:29:26 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:37135 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731520AbgAJG30 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 01:29:26 -0500
Received: by mail-qk1-f194.google.com with SMTP id 21so935787qky.4;
        Thu, 09 Jan 2020 22:29:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SlbmF6x149/UwAmOGa35Bjng3DKciQXe2A1/DjMwWug=;
        b=GISKrf/VlySaTnA9t5acnC7eN92dgD+oR/kOZfqX6w5tnH9/w/7sWY2cWtucO6bz8n
         h4pwulaprd8ADkWdCF6hpLWTNF31YBBIwLbCU4+1KS5eFmFm41cDDLSIEWBK9YG8XrR0
         RNmkO7PXHWCFwCH0N2xhHuHd9oz5mZVVXhcaAtpcTcjSNshmJWkc6/ScjEORmE4KnPn1
         S7DHzc/JRuDbe9NJT+H3C/ktPQ3ww0ZXj1SZswHKhTmeIZ7rmnkmDxUMIH6QNjkg5vFN
         JNv07zqxS5P4XGTo+ypOSVUNUFbFTFJwqNuTUUEyPLNCkN61gkYqqPPBF4d+UispeqMU
         Qwnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SlbmF6x149/UwAmOGa35Bjng3DKciQXe2A1/DjMwWug=;
        b=Bm0KdUzkMWH0Vl2D9giRO9t+JY4Nuk+hxLJ/n3kdsZlGIxhier7qkPmDcG0EBZrW4w
         jQX5bEaQN4RLOt9euw/uTm6Fz4fFFarBfYl8K39s+u7q9d4PVATvXDAo7csynq5V1bzn
         1sFUTD2smEEpYqGIKxTBt2ybCzagxXcoB8Z6wnsP9JzL3IDw3cmeBj98I3mFKeawQoSJ
         vFceWq9kR3/UIoMucPXrNAWpYPOYR/aTTNbBW4wHTkVrBlPszfm3KJ1NITmsq8xVaLk2
         cYI8Yth7COqpnEUq/mQyQxK4xx0IwzXvd0H00XUVz7S+OV6V8eqcziFGAZwHhGTKsxBr
         PsWg==
X-Gm-Message-State: APjAAAXJVs5/P9e7Houv2e2ECqpzMpCCHgZWtWj6IVsccq3MJA97mGLx
        A2K8lZDxvaVH8GxHklEjp/273ZLEHkOExQolXRw=
X-Google-Smtp-Source: APXvYqxA91uVB3M7x5SIebwRqJ6ZNN0S0Sjgcu6TLhT1J+RRMex/Kq18rjllNGIYsKmPUU61eYxR50h8V2cN6g9q4Ig=
X-Received: by 2002:a05:620a:5ae:: with SMTP id q14mr1662440qkq.437.1578637765178;
 Thu, 09 Jan 2020 22:29:25 -0800 (PST)
MIME-Version: 1.0
References: <20200110051716.1591485-1-andriin@fb.com> <CAADnVQ+AtbJ1M-Fss5WocSP=EmKgyZrCYUN8NtOFSx5DeYf2gg@mail.gmail.com>
In-Reply-To: <CAADnVQ+AtbJ1M-Fss5WocSP=EmKgyZrCYUN8NtOFSx5DeYf2gg@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 9 Jan 2020 22:29:14 -0800
Message-ID: <CAEf4BzYCR4E-qRKN9EpJKKgwU=T8pYFcuhiH=vrnt2cGuDgmaQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/3] Fix usage of bpf_helper_defs.h in selftests/bpf
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 9, 2020 at 9:58 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Thu, Jan 9, 2020 at 9:17 PM Andrii Nakryiko <andriin@fb.com> wrote:
> >
> > Fix issues with bpf_helper_defs.h usage in selftests/bpf. As part of that, fix
> > the way clean up is performed for libbpf and selftests/bpf. Some for Makefile
> > output clean ups as well.
>
> feature auto-detect and few unnecessary installs are now
> happening even when make shouldn't be doing anything.
> But overall it's still an improvement.

It's because of bpftool dependency. Don't see an easy way around that
yet, but I'll keep it on a back-burner...

> Applied. Thanks
