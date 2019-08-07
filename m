Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 306D185422
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 21:55:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388917AbfHGTzH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 15:55:07 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:41630 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388270AbfHGTzH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 15:55:07 -0400
Received: by mail-qk1-f195.google.com with SMTP id d10so2082830qko.8;
        Wed, 07 Aug 2019 12:55:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OziV8ZMpf3AbKIgWGay+ysxohoYeYkTtlGmtUbAV8rk=;
        b=GFA4sNmMkZXNNr4ShaFqm9G15/Ym213W+0q42hzMfDI13FenfhpZsCIC2sUp1KdyKn
         FTEBkz3fiKkN3DfSGxcOJZXwzuSBVsu4eXgdqOUaugBSEh00Z21/ube2AxSdNiHioD90
         EcgJrpumbcNpJ3iB0FC8vyf8QcvKw71dJB6bBM269h8SDis/RVOn25LUjAC/bfvXyPTj
         5d1h36blJdNwxPtxCr2KuQrTzTcuVFCmBmcwxZqnhF7RqocxRrKoamS8lbuOELDjZ0HJ
         F4lldKzIauP97Kf3/yl/nUf7/bLcR6dPTZqXUbrkKMvnmkPqb/rS+P5WhkU366wQDkU5
         HQGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OziV8ZMpf3AbKIgWGay+ysxohoYeYkTtlGmtUbAV8rk=;
        b=CQ71K4bURZ5FINA2oR+ap9O6F4PLgQyGWgJ4Un3I88XTY43ghkpBjIREHCoVcXzNaA
         n2yZuQYt2v7Js2dfJiTNrFC7IEqus/cScA+GYNhKQVjWCP/H9osd14c64oC28M4Sd2PX
         9W0pxtGEkGOkB7fXYecejr3+3rCwYw3QPIpfMrzao0o+ADp4UWbynVvIab2YEzoBDQXd
         Wk5eqzxWtEoR55fRPJObQDVEb+TUmM8gYhbJCPRmkk7Gvf7UY1uiwse9JjpNN7gesrCV
         C2rpupsdajd1iXS1L1U1sTUfiYfaR3VI0Zqa58rUBLRVSJ6Y/rhX8WhhzDesC+Z2Iy+n
         h5jQ==
X-Gm-Message-State: APjAAAVbjjmN0FeuUm3viKU7dPs1X4VklqkkGNpAKabDD2t/JbrwBRot
        8sScbbm08pSu6Lfaac4My4PVpfE4ZzU1spNzh78=
X-Google-Smtp-Source: APXvYqxC43MNp1s7v3hxd2BsBd5v3JOuhOFEY/VDEwF6ousHChvFZamDoxiZlBLrpUJUVICrH4eq4/3KMDhhHKl9vsI=
X-Received: by 2002:a37:660d:: with SMTP id a13mr10178007qkc.36.1565207706080;
 Wed, 07 Aug 2019 12:55:06 -0700 (PDT)
MIME-Version: 1.0
References: <20190807053806.1534571-1-andriin@fb.com> <20190807053806.1534571-2-andriin@fb.com>
 <20190807193110.p5flmxojmdjdg4dj@ast-mbp>
In-Reply-To: <20190807193110.p5flmxojmdjdg4dj@ast-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 7 Aug 2019 12:54:54 -0700
Message-ID: <CAEf4BzZ4M33arWAjHcCv7SjqeMpktJ_waFevb8JZ4B=6dXb+6g@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 01/14] libbpf: add helpers for working with
 BTF types
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>, Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 7, 2019 at 12:31 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Aug 06, 2019 at 10:37:53PM -0700, Andrii Nakryiko wrote:
> > Add lots of frequently used helpers that simplify working with BTF
> > types.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ..
> > +/* get bitfield size of a member, assuming t is BTF_KIND_STRUCT or
> > + * BTF_KIND_UNION. If member is not a bitfield, zero is returned. */
>
> Invalid comment style.
>

oops, fixing
