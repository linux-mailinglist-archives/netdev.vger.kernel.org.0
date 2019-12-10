Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA689118FFA
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 19:47:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727704AbfLJSrS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 13:47:18 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:40732 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726771AbfLJSrS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 13:47:18 -0500
Received: by mail-qt1-f193.google.com with SMTP id t17so3729904qtr.7;
        Tue, 10 Dec 2019 10:47:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XBioWIVBdC2zwr+D+g2m/LS1PnuP1YM9UmsiV9itzGI=;
        b=nMOAW0dmYyReIFhzMJy5qX6lzfIZBFkYqW0Uh3jDqFXNlHTHkVFpG5fyHyQGWPIc3Q
         RUsSKqpJ0jAFUHq4GCenRW0KpQzzDf5yGZXQ1ZIgcEc9R3D9p4PBKIqTuxfLotW0MGmX
         mab0bd+BSRxS/W6YpH++PplUM1VQb8acBkZIBNucXNTd3a66LQBn7QAnH3WxAO84BnlS
         QfTnuU+w5GhaEA+jUXmPqUykIRKLlpg0QK85ySpbFSFZ0HvkvZK2cd7RN7R22OlnNR32
         87zplnjSUSfhRMtPng30kjuTiI5f6sAdwbcarF0moMnRckAPT2DGT2oTjBpbutFEhbS9
         Vh4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XBioWIVBdC2zwr+D+g2m/LS1PnuP1YM9UmsiV9itzGI=;
        b=mZcH50giHxc/7wbZWfw9S8D5WTEN+QAfIx1/0vsPXxV7PslBxBZBaivyw6S7rUos0b
         SXt0/1CL+zMEkWztc5gr/U+mRuq6uKMs7rYqoNyUJkP3Qy/CiGPRDAevsUM8r+zilyN3
         SriyeCLJAlgKP+hXhIeEYImJL2fGiHPnj4rXqz8VuuksxnkY6Gly/Iud13yAWvpMR6FX
         Pud2bkg1RzzNW7xfxO3mhC2t6TSYG/y6AjmBAbCnqDv9LKDA5JlD1fyMbPRkLpmIc5Th
         LmOmKXVxkmtYXNH656fpOrAXuPCnpqmMsQeF0XAznd3WYUtXtU8J3m49zz3gutYL0+NN
         NSfw==
X-Gm-Message-State: APjAAAWRe0bESVp+cFSQ1/vV/14OIC67P1T39d+3PRFTFOFn2uoz9k7C
        8tLNHj4Quj8j9J3EfFyemKMyipidOczc8ENxo04=
X-Google-Smtp-Source: APXvYqzQ3byzUCg+3PSKqDnnojqjuqTf5D9tycT5BeC5iJ09B4Mltec1+OzkLfBGNF1HzwPWtYdHuhyYRT19IVPiyQ8=
X-Received: by 2002:ac8:4050:: with SMTP id j16mr30862740qtl.171.1576003637378;
 Tue, 10 Dec 2019 10:47:17 -0800 (PST)
MIME-Version: 1.0
References: <20191210011438.4182911-1-andriin@fb.com> <20191210011438.4182911-4-andriin@fb.com>
 <20191209173353.64aeef0a@cakuba.netronome.com> <CAEf4BzbYvNJ0VV2jHLVK3jwk+_GvVhSWk_-YM2Twu5XkZduZVQ@mail.gmail.com>
 <20191210101716.56c34afc@cakuba.netronome.com>
In-Reply-To: <20191210101716.56c34afc@cakuba.netronome.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 10 Dec 2019 10:47:06 -0800
Message-ID: <CAEf4Bza=eZmN+y7zHCjCncnV6fK9_D45k1CJU5i6XZxtxcpVNg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 03/15] libbpf: move non-public APIs from libbpf.h
 to libbpf_internal.h
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 10, 2019 at 10:17 AM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Tue, 10 Dec 2019 09:04:58 -0800, Andrii Nakryiko wrote:
> > > I thought this idea was unpopular when proposed?
> >
> > There was a recent discussion about the need for unstable APIs to be
> > exposed to bpftool and we concluded that libbpf_internal.h is the most
> > appropriate place to do this.
>
> Mm. Do you happen to have lore link? Can't find now.
>

https://lkml.org/lkml/2019/11/27/1264

> My recollection is that only you and Alexei thought it was
> a good/workable idea.

Daniel and others didn't seem to mind either.
