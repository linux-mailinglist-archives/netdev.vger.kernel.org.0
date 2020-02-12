Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13CEB15A410
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 09:57:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728606AbgBLI46 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 03:56:58 -0500
Received: from smtpq3.tb.mail.iss.as9143.net ([212.54.42.166]:45162 "EHLO
        smtpq3.tb.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728534AbgBLI46 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 03:56:58 -0500
X-Greylist: delayed 1232 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Feb 2020 03:56:56 EST
Received: from [212.54.42.110] (helo=smtp7.tb.mail.iss.as9143.net)
        by smtpq3.tb.mail.iss.as9143.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        (envelope-from <karsdejong@home.nl>)
        id 1j1nVO-0002VA-AH; Wed, 12 Feb 2020 09:36:22 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=home.nl;
        s=201809corplgsmtpnl; h=To:Subject:Date:From;
        bh=OuSzKhfxW8Gje2W8iT3ROQfQieVCxF7/6LjQe5C2nlU=; b=C1tZig2yOeXhiBttMk490YvCX0
        dpjontyCTTk/xJa/3dIL65DhVpdOJl5etAJlJxJpIPaz33rrpjIsfK4AQFqsys7mUHJ8k6E7s361f
        4VFIvxmByp2Qyf5nNrThPYAiIlpQZmtbeZJhVuj3wktmZDe+zwOF4wpJ53cm87asc54F09BhOAWq9
        UNKuaM8R91Dm7zoNYtPn8ZoQrsZX6cWb+E7pn1pdSZA7940UEDqS5NMyL487f9B13ldMXerHc0LLJ
        Q+kh82B5NlCChuB7Jt4gGza35fScNsVN+Xw9ezZgOJ7PLskAv4PPQj7KSpRwXqxbqfijzj8iT0zWL
        HsH5ALgQ==;
Received: from mail-wr1-f48.google.com ([209.85.221.48])
        by smtp7.tb.mail.iss.as9143.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <karsdejong@home.nl>)
        id 1j1nVO-0001vK-75; Wed, 12 Feb 2020 09:36:22 +0100
Received: by mail-wr1-f48.google.com with SMTP id y11so1106568wrt.6;
        Wed, 12 Feb 2020 00:36:22 -0800 (PST)
X-Gm-Message-State: APjAAAV3AtQMX4mqcKQ6yTeGknTVyv9+ft5rP0fFnE0vl0SRCBYbDp/r
        PGE5GiMfgh4prLzfEEZWg7GRysDLsYUagi6WL8s=
X-Google-Smtp-Source: APXvYqypjRsTG8DHRIbsXdGcPAkCfbey86PfEpUgceAU5FztilErtQJztFGZaFVToi09qUn3H+IsvJz7CZ3ylvF5Cf0=
X-Received: by 2002:a5d:4d04:: with SMTP id z4mr15132130wrt.157.1581496581870;
 Wed, 12 Feb 2020 00:36:21 -0800 (PST)
MIME-Version: 1.0
References: <20200211174126.GA29960@embeddedor> <CAMuHMdV3DY1X3s7fvZz8MpxvqsUZAOivc18f40Ca8kHiZqfqKw@mail.gmail.com>
In-Reply-To: <CAMuHMdV3DY1X3s7fvZz8MpxvqsUZAOivc18f40Ca8kHiZqfqKw@mail.gmail.com>
From:   Kars de Jong <karsdejong@home.nl>
Date:   Wed, 12 Feb 2020 09:36:10 +0100
X-Gmail-Original-Message-ID: <CACz-3rgCkoJ-Zx_RBTLBH0yOhz36dH+io+VFRgsXNx2qqwKVMQ@mail.gmail.com>
Message-ID: <CACz-3rgCkoJ-Zx_RBTLBH0yOhz36dH+io+VFRgsXNx2qqwKVMQ@mail.gmail.com>
Subject: Re: [PATCH] treewide: Replace zero-length arrays with flexible-array member
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        linux-m68k <linux-m68k@lists.linux-m68k.org>
Content-Type: text/plain; charset="UTF-8"
X-SourceIP: 209.85.221.48
X-Authenticated-Sender: karsdejong@home.nl (via SMTP)
X-Ziggo-spambar: /
X-Ziggo-spamscore: 0.0
X-Ziggo-spamreport: CMAE Analysis: v=2.3 cv=UJNG4BXy c=1 sm=1 tr=0 a=9+rZDBEiDlHhcck0kWbJtElFXBc=:19 a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=IkcTkHD0fZMA:10 a=l697ptgUJYAA:10 a=tBb2bbeoAAAA:8 a=_Wotqz80AAAA:8 a=YMzxVbYnAAAA:20 a=wNy__qbTz1_nECwbz_UA:9 a=QEXdDO2ut3YA:10 a=Oj-tNtZlA1e06AYgeCfH:22 a=buJP51TR1BpY-zbLSsyS:22
X-Ziggo-Spam-Status: No
X-Spam-Status: No
X-Spam-Flag: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Op wo 12 feb. 2020 om 09:00 schreef Geert Uytterhoeven <geert@linux-m68k.org>:
>
> Hi Gustavo,
>
> On Tue, Feb 11, 2020 at 10:49 PM Gustavo A. R. Silva
> <gustavo@embeddedor.com> wrote:
> > --- a/arch/m68k/tools/amiga/dmesg.c
> > +++ b/arch/m68k/tools/amiga/dmesg.c
> > @@ -34,7 +34,7 @@ struct savekmsg {
> >      u_long magic2;     /* SAVEKMSG_MAGIC2 */
> >      u_long magicptr;   /* address of magic1 */
> >      u_long size;
> > -    char data[0];
> > +       char data[];
> >  };
>
> JFTR, this file is not really part of the kernel, but supposed to be compiled
> by an AmigaOS compiler, which may predate the introduction of support
> for flexible array members.

FYI, there's a reasonably modern toolchain for AmigaOS which can
compile this just fine (https://github.com/bebbo/amiga-gcc).

> Well, even if you keep it included, I guess the rare users can manage ;-)
> My binary dates back to 1996, and I have no plans to recompile it.

I did, just to check whether it still worked.

Kind regards,

Kars.
