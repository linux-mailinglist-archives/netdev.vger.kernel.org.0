Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E0BA1090F2
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 16:22:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728478AbfKYPWA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 10:22:00 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:38096 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727785AbfKYPWA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 10:22:00 -0500
Received: by mail-qt1-f196.google.com with SMTP id 14so17579302qtf.5;
        Mon, 25 Nov 2019 07:21:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=LZ0guQtx/bZA42416TGTmVnleb9qGnfvYGy7LTAuTGM=;
        b=QcGAeYVg5/Re/0XCcd2jXtTULiuaCv4cSAKsEziF2zVZA9o7OqnIJ/zBlA9yFKD5H6
         iCu/4m4BV/1MbjfSB6pRkISCP16hU5fjvZVzPpQbFeOsF34dyuiz87/5IYps6xxUd2id
         3zuleMioYv1hkbAcZ/DpY2kqUDLgiWxDlpdVmyMWfubDSNKbTvhj5uTlGwQQ6zOELccm
         1DFeeA6gU+38thsTxADl62d6of3HO647es0YtGt2/FVas3e3Y+uP5l1lr4DxTRZ0VZiU
         UqugLza6El4dr2B4DGFZRKgMA2rqWVjccQdU+i5F7ep4Me5h3pHJje+ID1MtIDZacUCj
         QDcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=LZ0guQtx/bZA42416TGTmVnleb9qGnfvYGy7LTAuTGM=;
        b=a30H37rUIhBy/3lKZvMuYwef28OriguEoI+RepKYmu0OscaQaspuRn1O65eCsWj6kr
         Y++YoLDECLe7wNytdXJ8HhkVm0D2YumHerAuShYdtZjMyojpMBa+Alag7LibPjh0VksX
         g6S4s+r86OcQjNl7shF6kZNpN1IyO0zunhA5O+/cEX+Kssbvc/5opookLg+YUsHQgw1V
         GQbGNXuOmQ/brzTW4jtgQg5rZiQ7JDZSxYypdhN1r6cE3T+RysNu9DvnpyY4+K5KH/ay
         5CNBtHKGo/+exXQQnh2GLlirFtXON/XakgWttC+u5rQqhwLZgdeGPQjVvO2yqCAP6m9g
         OIhA==
X-Gm-Message-State: APjAAAUhRUYYrpu3UQFq5Ydx8Ev+wtHZ1y5A8EWc5t1m6BiUy5B0AXzL
        lX3zUO26x/v+GfgTth+eVd53hl7dvGNCuXIKXDs=
X-Google-Smtp-Source: APXvYqxENIyVAc9b6DjdDWBlzLm6+nfH4Cggc4at63U6+lmga/5ouMVHM9vhnCIXOuJcXaNw5T2YsnOIsaUWQ+cmgTs=
X-Received: by 2002:ac8:6941:: with SMTP id n1mr27203631qtr.36.1574695317665;
 Mon, 25 Nov 2019 07:21:57 -0800 (PST)
MIME-Version: 1.0
References: <20191123071226.6501-1-bjorn.topel@gmail.com> <20191123071226.6501-3-bjorn.topel@gmail.com>
 <875zj82ohw.fsf@toke.dk>
In-Reply-To: <875zj82ohw.fsf@toke.dk>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Mon, 25 Nov 2019 16:21:46 +0100
Message-ID: <CAJ+HfNhFERV+xE7EUup-tu_nBTTqG=7L8bWm+W8h_Lzth4zuKQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 2/6] xdp: introduce xdp_call
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf <bpf@vger.kernel.org>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Edward Cree <ecree@solarflare.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Nov 2019 at 12:18, Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat=
.com> wrote:
>
> Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> writes:
>
> > From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> >
> > The xdp_call.h header wraps a more user-friendly API around the BPF
> > dispatcher. A user adds a trampoline/XDP caller using the
> > DEFINE_XDP_CALL macro, and updates the BPF dispatcher via
> > xdp_call_update(). The actual dispatch is done via xdp_call().
> >
> > Note that xdp_call() is only supported for builtin drivers. Module
> > builds will fallback to bpf_prog_run_xdp().
>
> I don't like this restriction. Distro kernels are not likely to start
> shipping all the network drivers builtin, so they won't benefit from the
> performance benefits from this dispatcher.
>
> What is the reason these dispatcher blocks have to reside in the driver?
> Couldn't we just allocate one system-wide, and then simply change
> bpf_prog_run_xdp() to make use of it transparently (from the driver
> PoV)? That would also remove the need to modify every driver...
>

Good idea! I'll try that out. Thanks for the suggestion!

Bj=C3=B6rn


> -Toke
>
