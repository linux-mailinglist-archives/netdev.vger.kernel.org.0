Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF3BC10F273
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 22:57:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726074AbfLBV5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 16:57:25 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:37023 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725825AbfLBV5Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 16:57:24 -0500
Received: by mail-qt1-f196.google.com with SMTP id w47so1464530qtk.4;
        Mon, 02 Dec 2019 13:57:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6VxLgXL3DqmQ1VDYv5dFHrIFz0lPsv+vZq63pd9PDAA=;
        b=m2rd4IYQ/gxlouukwkl1G9JO2SYo98Zsvevp+hzgcxjwi5jaZs1rsJu4GUdduJp6s8
         dgbZRhONGKq/lO+oqWF6M+VsxSEtb+XXp7zakmfsS+9+PnoGC/7NnA6oVFwyrdIc+Gyv
         t78561jqyq2ovC6FgtTZd/fSY+BAvWZnby1vscGpczogTNI2U0KXOWB40rEjok0S/v6V
         /Rmdb3TageZKpK8toQJFaGlGa46U00+5R1TGRf9ESitqxwKYDIX0U7OVfl1AO6vFQvUz
         qRX0cHZkWe7MwlvMuxuYSZkGghDRGw6RDNFYD3+9eZsSSlWgw7cNnRCs55iEK/jRB2J2
         havQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6VxLgXL3DqmQ1VDYv5dFHrIFz0lPsv+vZq63pd9PDAA=;
        b=hmZcTGR7NvVh+rcBIbccuaGvxITdcxWkcNkZ6oakz1x6T2VW2AXqPGB/Y98Y6ThypX
         GbwTIo248dQsO1IcYN2MukF3SFl7zem1yH0PEOw9PSCsqvqSftXC6nAkFgVd/rF4Uvx9
         jfHDV+E/hD8RBa3R6Z9waUZMx8vKT+W5chIzpYzUC8LtQq3DJ+stYXDB1joiyBOLrgc1
         JY1E9FHkX+qRsBU/nBtXMWfYKpqpU9p0D6OZLOqLkgFl2YOpZBwhDGcqLlmU7bgKKyj1
         r+vYZ2H8/qTWlb62rYSmCtyM7usi03vGsCYpZV3iXL3U6LYucSiv7cAEd0cv56HDDC3H
         qXQg==
X-Gm-Message-State: APjAAAWO7EDXTzzwCezWT+66h+vQJABxsLsY1k997sGHzQM173nitsxa
        V1Y/aZCzlLvwo4P3ukydqTfekdG89a3l3H/ih7M=
X-Google-Smtp-Source: APXvYqwX/KxnSoByURZI9ZdOypnqwHj7uuJDi1UpdEl7CGHUqdOxfpRkLNRRLK0O0YBHSU/8TiXP8WUVoZG8lFDFDjk=
X-Received: by 2002:ac8:6613:: with SMTP id c19mr1826035qtp.117.1575323843575;
 Mon, 02 Dec 2019 13:57:23 -0800 (PST)
MIME-Version: 1.0
References: <20191202202112.167120-1-sdf@google.com> <CAEf4BzZGOSAFU-75hymmv2pThs_WJd+o25zFO0q4XQ=mWpYgZA@mail.gmail.com>
 <20191202214935.GA202854@mini-arch>
In-Reply-To: <20191202214935.GA202854@mini-arch>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 2 Dec 2019 13:57:12 -0800
Message-ID: <CAEf4BzYzY2WsiDoGokeo9AjmYfnrAhEn0YhTeQV6Gt-53WhR4A@mail.gmail.com>
Subject: Re: [PATCH bpf] selftests/bpf: bring back c++ include/link test
To:     Stanislav Fomichev <sdf@fomichev.me>
Cc:     Stanislav Fomichev <sdf@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 2, 2019 at 1:49 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
>
> On 12/02, Andrii Nakryiko wrote:
> > On Mon, Dec 2, 2019 at 12:28 PM Stanislav Fomichev <sdf@google.com> wrote:
> > > +# Make sure we are able to include and link libbpf against c++.
> > > +$(OUTPUT)/test_cpp: test_cpp.cpp $(BPFOBJ)
> > > +       $(CXX) $(CFLAGS) $^ -lelf -o $@
> >
> > let's use $(LDLIBS) instead here
> Sure, I'll send a v2 with $(LDLIBS); it might be worth doing for
> consistency.
>
> Just curious: any particular reason you want to do it?
> (looking it tools/build/features, I don't see any possible -lelf
> cross-dependency)

The main reason is that I'd like to only have one (at least one per
Makefile) place where we specify expected library dependencies. In my
extern libbpf change I was adding explicit dependency on zlib, for
instance, and having to grep for -lxxx to see where I should add -lz
is error-prone and annoying. Nothing beyond that.
