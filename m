Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD5617ED6C
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 09:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388646AbfHBH1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 03:27:07 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:44903 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732392AbfHBH1H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 03:27:07 -0400
Received: by mail-qk1-f195.google.com with SMTP id d79so54011428qke.11;
        Fri, 02 Aug 2019 00:27:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=n/fVlaA6BYitJiodJ9o0tWCfpzxaKHH9gHlYbSMNnsg=;
        b=ZBvI0bVe6knQT6x5L7bbmOzwQnmrC8OgXSP812Y/NSY44647E3QVlIFY8RgRmIH98Y
         buyCLX4+jsfznFPgJw68OZ8J9MpnIfZo6qDfJQpAw5G+Fsgy6QOqaYJOmPI32W46RrxP
         Z0mp8oiVmxIpYS7P//nRdxVPHvgZiyEyMO5ERsLuSkcTYGA9SfhifhERA238KmFZG1I2
         faezPuy7ZnzvP3e5yQYm1N8nDFYa3+U6LKsbw8GtiBFNCNZ01xsSVvCCEzcQsZQR5h5f
         Ji4eE7+imbVh6xtCMWMvb+g922vOxi2lt6yh2Kg+j6XbD9A4S5EzN3O5KnfNO5aonY8V
         8rpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=n/fVlaA6BYitJiodJ9o0tWCfpzxaKHH9gHlYbSMNnsg=;
        b=eQjr6lJ+MI3htY4mmf+JJ9tuPuMvabROiPSbQ5AljOb/skHH5GOMVoqAv/PNI/MIpL
         mHOtEYMnnfb0mZ75uC+jez7YtChwFk0jrDIur1NikfNfW36r4s8yJflNfjR5r8QLfHRx
         ++qalcYiP/tXRQ5SKdv5WtJCuOH7fgi0CZkRgXYceA4/mRlxjrhTlrfsgQH3oU5E5oXE
         GMHQCT9KWxUnxrF+HPbABqTmnzjgtGoI29rgQqV6FwYeygZEEoHlfHcRU8igUcMaT5TV
         lN0poFWYc2gDE1LF38yVDvJPIRFIfg+LltCUCH0sj0V+Y81LsSlSOAxz76MphOMDRe/X
         d3JQ==
X-Gm-Message-State: APjAAAWo/83xbTICicRVe4AjToukY0u5fi9P8qNrtSIPTgJtFJGXSbG4
        AG+nbGaN/nplieWEryQcuosE21POsEPxpxCYKFToZJUYBa8=
X-Google-Smtp-Source: APXvYqwG6uI3ycnfVnu4sogNhHYa3FZElfzoqMjVYK2ovZgxntoOJsikibVVo0pzPvk17eNCP8ww/R4Gp10l1Pu3HOE=
X-Received: by 2002:a05:620a:11ac:: with SMTP id c12mr87392099qkk.232.1564730826483;
 Fri, 02 Aug 2019 00:27:06 -0700 (PDT)
MIME-Version: 1.0
References: <20190724051043.14348-1-kevin.laatz@intel.com> <20190730085400.10376-1-kevin.laatz@intel.com>
 <20190730085400.10376-4-kevin.laatz@intel.com> <CAJ+HfNifxfgycmZFz8eBZq=FZXAgNQezNqUiy3Q1z4JBrUEkew@mail.gmail.com>
 <CAEf4BzbTbX-Teth+4-yiorO-oHp+JhGfW2e08iBoCsBA4JCbMQ@mail.gmail.com>
 <CAJ+HfNhYe_FgV0tGTLzaFGVSiimVnthgESN8Psdtpxw696w0OQ@mail.gmail.com> <CAEf4Bzar-KgCjUEfKVeWzcB77xvXDagZFRQKDvWo1o9-JzCirw@mail.gmail.com>
In-Reply-To: <CAEf4Bzar-KgCjUEfKVeWzcB77xvXDagZFRQKDvWo1o9-JzCirw@mail.gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Fri, 2 Aug 2019 09:26:55 +0200
Message-ID: <CAJ+HfNhQFs4jgJORmdPh6zeJXXMd-9j3YgdSUac3PxRQrGzNDw@mail.gmail.com>
Subject: Re: [Intel-wired-lan] [PATCH bpf-next v4 03/11] libbpf: add flags to
 umem config
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Kevin Laatz <kevin.laatz@intel.com>,
        Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Bruce Richardson <bruce.richardson@intel.com>,
        ciara.loftus@intel.com,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2 Aug 2019 at 09:19, Andrii Nakryiko <andrii.nakryiko@gmail.com> wr=
ote:
>
> On Thu, Aug 1, 2019 at 12:34 AM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.=
com> wrote:
> >
[...]
> >
> > Old application, dynamically linked to new libbpf.so will crash,
> > right? Old application passes old version of xsk_umem_config, and new
> > library accesses (non-existing) flag struct member.
>
> I think we have similar problems for all the _xattr type of commands
> (as well some of btf stuff accepting extra opts structs). How is this
> problem solved in general? Do we version same function multiple times,
> one for each added field? It feels like there should be some better
> way to handle this...
>

If the size of the struct was passed as an argument (and extra care is
taken when adding members to the struct), it could be handled w/o
versioning... but that's not the case here. :-( Versioning is a mess
to deal with, so I'd be happy if it could be avoided...
