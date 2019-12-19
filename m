Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31FE5125909
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 02:03:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726769AbfLSBDq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 20:03:46 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:33452 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbfLSBDq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 20:03:46 -0500
Received: by mail-lf1-f68.google.com with SMTP id n25so3088426lfl.0;
        Wed, 18 Dec 2019 17:03:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jT5hb5SEsah1czjL3B1Bpd4FwaIjE7wJo9044Z3h+P8=;
        b=OU8SIxH9wZKD1hrscY0n4kYDWOsir8OgtJnws81il0j/rdyT/I4SCTz/K5PKj8wuNc
         jcoduHBasRLR2z6X3jMnKpxPsLtAGEgp+xQTjxdbX4buDy3GiICT1T+pj5rBnkvc3fo3
         LoV4oMuO42Ec7QrC/WfrpI1nOHZlSEkDIOxcHrJoaAZk6PVZ5VrM4lxZxLCdnufBfCBl
         s6RkQK768PJM07SQYu+zrGUtfRtMUujGM8PxBe7I0nNeqR55iqNkAPJMey8b2Pk0HDI9
         1L+MK1qJMID5Yzv0B3Uj2vOUmgvzGZOhXXsn7JpWarG/QKwKZ+fzT92AJArWEF4uhhyO
         Kd5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jT5hb5SEsah1czjL3B1Bpd4FwaIjE7wJo9044Z3h+P8=;
        b=io2XBCe1n2VNkwgrLElSYBCqYgwUv+BIH4mFFnTKRBTjPJuamJm9UtFwaDlQ8Fht2x
         euPNTULS97nFtkq2Li5VqPrbW34rLGhzX0L6XZt1Qugr2X/Ia+u6UPAERZGPfgskyiVV
         fl4et5w1i/f2+k3kxlDv/XIwLVK5zKIF7NOf8zuU480WGOySHwq/N3J2jmJo6rR3Ai8l
         +TvBWxwdDww2dpQAM52x69NFUlMcRStBr5Iix2ET3mmHNZpFkvlb9R5QszZPdPDYSMOC
         0fbjfnIuOkKRmfGC7ToDf7mSDSMs2xh0DRBqAdcZdXmJGL2SCbJkOF3YlY4kxcOHFy9I
         W+9g==
X-Gm-Message-State: APjAAAXSikJt6ltPCI+ytUZPsbFmQIAhZdjb7tV7Xsf2YhBsnyTXZiou
        IY2YlFDsOFhce+q89fcqytpFZ9S4pQb1Agdg7Fk=
X-Google-Smtp-Source: APXvYqwJ1bTa+ZCeaCERaDVZW8VjfpuR2336nirPKbPvClRbzSH+QFyWBiMEfqXl9Ahi4Ipokwnl+4OqvxJF80Gzrvo=
X-Received: by 2002:ac2:52a5:: with SMTP id r5mr3671573lfm.19.1576717423770;
 Wed, 18 Dec 2019 17:03:43 -0800 (PST)
MIME-Version: 1.0
References: <20191218214314.2403729-1-andriin@fb.com> <5fc9f067-019c-8cf0-6f27-fc2afecdd4ea@fb.com>
In-Reply-To: <5fc9f067-019c-8cf0-6f27-fc2afecdd4ea@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 18 Dec 2019 17:03:21 -0800
Message-ID: <CAADnVQL0DsDUW2QL0KhqzXDK5nZoqj8Rf=T9za+_53vg69LKOQ@mail.gmail.com>
Subject: Re: [Potential Spoof] [PATCH bpf-next] bpftool: simplify format
 string to not use positional args
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 18, 2019 at 3:28 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 12/18/19 1:43 PM, Andrii Nakryiko wrote:
> > Change format string referring to just single argument out of two available.
> > Some versions of libc can reject such format string.
> >
> > Reported-by: Nikita Shirokov <tehnerd@tehnerd.com>
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>
> Acked-by: Yonghong Song <yhs@fb.com>

Applied. Thanks
