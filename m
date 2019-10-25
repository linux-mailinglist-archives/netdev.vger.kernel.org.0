Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84BFCE44BD
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 09:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407499AbfJYHnB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 03:43:01 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:36872 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406055AbfJYHnA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 03:43:00 -0400
Received: by mail-qk1-f196.google.com with SMTP id u184so899925qkd.4;
        Fri, 25 Oct 2019 00:42:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=eCMciiCDbX8jb8plKVhdLrZ15B5tJHlk2Aev+kt9I0Y=;
        b=OIySZeld5ZznaaMF7UAE9qMFtXh1IB2VRU3p1eJPKquocjhrD2MrZwKu+w4EUj4Ewb
         /PL29wNJp5woqhAUq8cZJI71qSvNwE0zrmdgh7wRhnaVF0v8YNox2icBdhgux7J04Xop
         7QW7Dx4e51m46raceMTlDq0B5EE0gmUyNLjjafvUFVyKfvkFbbFA2xrUBiAuumet8wkV
         nsGOqYUJYdazJ7v4phthGuM3/q//fRcybEWgwuUD+h2qxyBN5n6tqT/a/NX5/hqWHLOc
         DfOYUmKr6rwwwuGflGgx4B9fsUxKlK5oUys2BLcDdwYfxfkIHm5cju/t6M64SmFjsylv
         X/YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=eCMciiCDbX8jb8plKVhdLrZ15B5tJHlk2Aev+kt9I0Y=;
        b=LuZwwImLsEZj/MlAWWVNCtxIQ2ljY+fJwmZ2/qyQM+lCGuglywJgntnsTYXlPAj4d5
         vZ3Z2HdKhE94VMfGy4+dDG4ePVcDmf6G/wdd2R0TWbjtZ2RdHP5yIQnn0ZdXxcE4fuKH
         YJTiCIoH3H23qdsMqcTqOK8mXQz50UUDE4wmsneK/ixILCBUA25xxS6iQoyp8OU+M6eZ
         poomIM8yyOTLJyyoBSTRY0baRYg0Djbjp2O4BOdaibnAkBjq5q8E2Hpru2I1AK2TLIcK
         BD33G7scHhcElfuiU/pluQjtE6oyJkoIxkfO7+09pMPKq87JD8lkLhE18LlEO0N36bBY
         P3iw==
X-Gm-Message-State: APjAAAXqoYzNNrYTv1YzXF8SWvTdpCdDW7xAmUFOUd3DX4c679p7DBzL
        M/XnwP787qlBpMgn/suAckhKiUNMsesCqYQ3zxI=
X-Google-Smtp-Source: APXvYqz2mkOWlXqUiqJIVqOJ424SlOwwLymNgGGU85rHsFJC3Ef4nmL1rnIzPWnQWIws50w22LyxDiZyyVapjvYpdH4=
X-Received: by 2002:a05:620a:1364:: with SMTP id d4mr1692290qkl.218.1571989379371;
 Fri, 25 Oct 2019 00:42:59 -0700 (PDT)
MIME-Version: 1.0
References: <CAADnVQKwnMChzeGaC66A99cHn5szB4hPZaGXq8JAhd8sjrdGeA@mail.gmail.com>
 <68d6e154-8646-7904-f081-10ec32115496@intel.com>
In-Reply-To: <68d6e154-8646-7904-f081-10ec32115496@intel.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Fri, 25 Oct 2019 09:42:48 +0200
Message-ID: <CAJ+HfNigHWVk2b+UJPhdCWCTcW=Eh=yfRNHg4=Fr1mv98Pq=cA@mail.gmail.com>
Subject: Re: [Intel-wired-lan] FW: [PATCH bpf-next 2/4] xsk: allow AF_XDP
 sockets to receive packets directly from a queue
To:     "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf <bpf@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Netdev <netdev@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        "Herbert, Tom" <tom.herbert@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 24 Oct 2019 at 20:12, Samudrala, Sridhar
<sridhar.samudrala@intel.com> wrote:
>
[...]
>
> With mitigations ON
> -------------------
> Samples: 6K of event 'cycles', 4000 Hz, Event count (approx.): 5646512726
> bpf_prog_3c8251c7e0fef8db  bpf_prog_3c8251c7e0fef8db [Percent: local peri=
od]
>   45.05      push   %rbp
>    0.02      mov    %rsp,%rbp
>    0.03      sub    $0x8,%rsp
>   22.09      push   %rbx

[...]

>
> Do you see any issues with this data? With mitigations ON push %rbp and p=
ush %rbx overhead seems to
> be pretty high.

That's sample skid from the retpoline thunk when entring the XDP
program. Pretty expensive push otherwise! :-)

Another thought; Disclaimer: I'm no spectrev2 expert, and probably not
getting the mitigations well enough. So this is me trying to swim at
the deep end! Would it be possible to avoid the retpoline when
entering the XDP program. At least for some XDP program that can be
proved "safe"? If so, PeterZ's upcoming static_call could be used from
the driver side.


Bj=C3=B6rn
