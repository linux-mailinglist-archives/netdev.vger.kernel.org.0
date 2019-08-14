Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58CA48D8AA
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 19:00:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728283AbfHNRAi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 13:00:38 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:38883 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbfHNRAi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 13:00:38 -0400
Received: by mail-lj1-f194.google.com with SMTP id r9so105453726ljg.5;
        Wed, 14 Aug 2019 10:00:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E+sQ4Gp9bqmCxkeVyuEBp1/sYuIBIs8MasIO4fyUW64=;
        b=e8Y2BtchZtExSm/jHOo/n///n39gkAZzHb/S/Xh553885+pGNP+CcQzviMLd5XaV9u
         Lmy3HNB+fWWoywz0hS5wkGP5YeGrVSBwaQi7Pxhti+VXYK2eTQ9fjP/P97t4FpbKisBL
         jHxFTE/CqhN4DPGyEZT+HLK3MB4z3trMvii39A2xbbgNLxlj64VTmQiXhsPjxU/DzJQ2
         aIVfToQ1J1DKNJHDYJK2cw2NrW6LtHKX2++BTAaNJYOi1QsFL/7ZSmmGEkGPHfpf59yd
         Ex5AuUuCyhPH7zUrO59YwU+bIMmkq9v/RiAkd7ja8GB3IlGkln9qFswwJmcqM8ZJ85P9
         YVlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E+sQ4Gp9bqmCxkeVyuEBp1/sYuIBIs8MasIO4fyUW64=;
        b=DMKMvVDXh7Ivfmh88I4P6tcJ8v1hynV7iE6dAvZ7BRCQVJ5Xo2oJi5iv0K4VUUlyXJ
         tXmYa6SYMb28NMDCW7XFGVlpsaxsCTQTjZKrJbq9VdpyaCuCjX2SrYzC0hbMPY13oxxq
         eXABgWkyITkcuLS2xW8njxxCIujj1LbR8l3Bjkvk9VpX7zaVm+Rs4c6nKf1cVBWZxZhu
         rz6TWC1FrVTjvrn9TilfR93tqlXegfiK/7q55T4Tr0XYKN7FLf5nMIFXWuUqF3dW7v1c
         tWAPyu6ES9GiFJoI/OeGqExEAbMoKVNDQoLB7tapDK4S0iwtKoQbEypc4SxZHKgGMUZ5
         Ei7g==
X-Gm-Message-State: APjAAAW46AEinq3t4d8htzsWLDVtLB22neHG2gW8CAd9/1pwnA36vuRR
        yc4lgJYlUYUdVfzhJtmYpzSm3OGq8DtC++odRB4=
X-Google-Smtp-Source: APXvYqwq/2ztRXrFUzvTMq/GsCRAFYPUqfuV5rEPOFM/kwhb8NTnnmkQzxpILUzsXl8UvVJPdS7Vv7xeJcUQmxdWx0E=
X-Received: by 2002:a2e:8102:: with SMTP id d2mr416378ljg.58.1565802036052;
 Wed, 14 Aug 2019 10:00:36 -0700 (PDT)
MIME-Version: 1.0
References: <20190814164742.208909-1-sdf@google.com> <20190814164742.208909-2-sdf@google.com>
In-Reply-To: <20190814164742.208909-2-sdf@google.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 14 Aug 2019 10:00:24 -0700
Message-ID: <CAADnVQJk=qSLR1A=1poPY85wNqiye3dMvXZOZ+1OFZSA78VARg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/4] selftests/bpf: test_progs: change formatting
 of the condenced output
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 14, 2019 at 9:47 AM Stanislav Fomichev <sdf@google.com> wrote:
>
> This makes it visually simpler to follow the output.
> Also, highlight with red color failures when outputting to tty.
>
> Before:
>   #1 attach_probe:FAIL
>   #2 bpf_obj_id:OK
>   #3/1 bpf_verif_scale:loop3.o:OK
>   #3/2 bpf_verif_scale:test_verif_scale1.o:OK
>   #3/3 bpf_verif_scale:test_verif_scale2.o:OK
>   #3/4 bpf_verif_scale:test_verif_scale3.o:OK
>   #3/5 bpf_verif_scale:pyperf50.o:OK
>   #3/6 bpf_verif_scale:pyperf100.o:OK
>   #3/7 bpf_verif_scale:pyperf180.o:OK
>   #3/8 bpf_verif_scale:pyperf600.o:OK
>   #3/9 bpf_verif_scale:pyperf600_nounroll.o:OK
>   #3/10 bpf_verif_scale:loop1.o:OK
>   #3/11 bpf_verif_scale:loop2.o:OK
>   #3/12 bpf_verif_scale:loop4.o:OK
>   #3/13 bpf_verif_scale:loop5.o:OK
>   #3/14 bpf_verif_scale:strobemeta.o:OK
>   #3/15 bpf_verif_scale:strobemeta_nounroll1.o:OK
>   #3/16 bpf_verif_scale:strobemeta_nounroll2.o:OK
>   #3/17 bpf_verif_scale:test_sysctl_loop1.o:OK
>   #3/18 bpf_verif_scale:test_sysctl_loop2.o:OK
>   #3/19 bpf_verif_scale:test_xdp_loop.o:OK
>   #3/20 bpf_verif_scale:test_seg6_loop.o:OK
>   #3 bpf_verif_scale:OK
>   #4 flow_dissector:OK
>
> After:
>   #  1     FAIL attach_probe
>   #  2       OK bpf_obj_id
>   #  3/1     OK bpf_verif_scale:loop3.o
>   #  3/2     OK bpf_verif_scale:test_verif_scale1.o
>   #  3/3     OK bpf_verif_scale:test_verif_scale2.o
>   #  3/4     OK bpf_verif_scale:test_verif_scale3.o
>   #  3/5     OK bpf_verif_scale:pyperf50.o
>   #  3/6     OK bpf_verif_scale:pyperf100.o
>   #  3/7     OK bpf_verif_scale:pyperf180.o
>   #  3/8     OK bpf_verif_scale:pyperf600.o
>   #  3/9     OK bpf_verif_scale:pyperf600_nounroll.o
>   #  3/10    OK bpf_verif_scale:loop1.o
>   #  3/11    OK bpf_verif_scale:loop2.o
>   #  3/12    OK bpf_verif_scale:loop4.o
>   #  3/13    OK bpf_verif_scale:loop5.o
>   #  3/14    OK bpf_verif_scale:strobemeta.o
>   #  3/15    OK bpf_verif_scale:strobemeta_nounroll1.o
>   #  3/16    OK bpf_verif_scale:strobemeta_nounroll2.o
>   #  3/17    OK bpf_verif_scale:test_sysctl_loop1.o
>   #  3/18    OK bpf_verif_scale:test_sysctl_loop2.o
>   #  3/19    OK bpf_verif_scale:test_xdp_loop.o
>   #  3/20    OK bpf_verif_scale:test_seg6_loop.o
>   #  3       OK bpf_verif_scale
>   #  4       OK flow_dissector

sorry this is nack.
I prefer consistency with test_verifier output.
