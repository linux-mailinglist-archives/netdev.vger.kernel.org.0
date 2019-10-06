Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D6C7CCDBD
	for <lists+netdev@lfdr.de>; Sun,  6 Oct 2019 03:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbfJFB3d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Oct 2019 21:29:33 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:37326 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727065AbfJFB3d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Oct 2019 21:29:33 -0400
Received: by mail-lf1-f68.google.com with SMTP id w67so6925349lff.4;
        Sat, 05 Oct 2019 18:29:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ZYtn+GoipNmwlHwDX0mcW104MlWb+HJidUKOiHj+/Ig=;
        b=MdIX7Xj/h7zWTySBIkKbBqQ2x2fkRG4a6qWzbsCZ4bLogJFQCXIQU6eq2/IIVlInGE
         S6tAh2spbF11JB3/3Uxre0C6Yj89CZDt7yLGh7t1QcNjPxfLcTLObxedTqmqMGPuQ8JF
         iig5t6r341SVBUXiWvu5if7AarhaLgFC7RVhtpTerz9HS+0P8IqDaKEsSu3A3edL42D+
         Q4Rsub9GeEXPd0WzrDRvVk6I6ELXv5xY66Yr9N5FHBEBheWOzeDXtUopRdNXz651spys
         y/QWl1FNDaR9PgaTT+9QyQZDIzl01T4Vo1W71GcXdI3XYXHn7sn7phyVflSCPRSZDr2/
         gsLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ZYtn+GoipNmwlHwDX0mcW104MlWb+HJidUKOiHj+/Ig=;
        b=uJfUmBqeNp6ZDGvxdbq5PH7OZVC3/cg/mF8mt+a0SEYN5z79bSlxbbnyhhwlSyrch+
         F8/XpRpV0z2T1Vk3IOSFdi6UJajyTqzAR0nnDshIQDFaRplNE9wWWntpnZv4ZRu+dV5q
         9aWEH/wNVR3qToquH9sQitzs3k7iPz9DbxRfJcBVsTRh7oWpZQwk7qQEqviX5Tl3DDJI
         xhky04SwqsSiKzvpfP4HGWVo0dFV7wOo0JxZ6peLz4gzlXBRdDo/IHmp47AY5/VwGaB9
         8uR97iZ2bEn+4faWp9lz/b31c9/rks7FiuMa4IO24VCDkN0bEfzKRIvD3+Du3TfpanOW
         xphw==
X-Gm-Message-State: APjAAAW72dljvxO2lpq14UZcWqM8ujUt5UatXEb2VFNeM2MGpxfyPJMV
        vdKPnD1nOfuekM/pyKBl21hkMatCnXerTJK0VtdDJQ==
X-Google-Smtp-Source: APXvYqxLJs/f7g1XTaW/V45nzghlBYfqYWzLR7UupEho+Us8kEPDQetUmvZ4PnD5PVtPlPYvZMy/3vD/yJgwIb8hdog=
X-Received: by 2002:a19:ac45:: with SMTP id r5mr12754891lfc.6.1570325369399;
 Sat, 05 Oct 2019 18:29:29 -0700 (PDT)
MIME-Version: 1.0
References: <20191004153444.1711278-1-toke@redhat.com>
In-Reply-To: <20191004153444.1711278-1-toke@redhat.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sat, 5 Oct 2019 18:29:18 -0700
Message-ID: <CAADnVQJGP-ZPXWMtvCoANdNCn384kP7QwDzDz+kQuA=FzRpfPg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2] libbpf: Add cscope and tags targets to Makefile
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 4, 2019 at 8:36 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
>
> Using cscope and/or TAGS files for navigating the source code is useful.
> Add simple targets to the Makefile to generate the index files for both
> tools.
>
> Acked-by: Andrii Nakryiko <andriin@fb.com>
> Tested-by: Andrii Nakryiko <andriin@fb.com>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

Applied. Thanks
