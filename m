Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC338FA5C
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 07:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726277AbfHPFX1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 01:23:27 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:39669 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725971AbfHPFX1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 01:23:27 -0400
Received: by mail-qk1-f196.google.com with SMTP id 125so3795098qkl.6;
        Thu, 15 Aug 2019 22:23:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uHyOSrsLg+OpTAnL/CHZKBv938Zif7lAbBDshh9pX/c=;
        b=lYK9LS3N7wVCkLjV2IsreoUe7z+fSQ9B/mQ08Q3vfdBmDbtZUiYi0wa6QMOZSXWJGI
         RB2Lc+mK0FrrdoMlT6ptkYsIjxwwNCbc16b4K6kKgiytfPkhEWKpzljzg4L0JYplp0Ao
         ETAEXJjEe2KA+kSlN9b10R5CNaKIivxG4iAKKQfotYPv0bLjPoAZgxVklWZ3e98qNmra
         SEWCCfTaEBlGNusKq86KxYTZEzcSGJbLJTPhL0WNeO9RMXJ2Q7gue0fCSusiCBvug4q4
         uMNs2Lp3LJtq5jf6jR4TwpZ5exqo1S7by7/bal6Mhlx8nOUvgj/a8+RS1ptYVSHDrofR
         4law==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uHyOSrsLg+OpTAnL/CHZKBv938Zif7lAbBDshh9pX/c=;
        b=AGE64x333SK+w483f4/+Jj8LNUuUfGP80yr0WxdHsp6lERYUZnNeSW3AB3+AnGTHgb
         BONk7edO18+NFMGV/V8DnCEYadPH8MXs1t5d1JkNHwdxoVh8q6qKQe602it7Vknsu2WI
         bLL48m+IpSdI9UzKnMIChpqElhrMA1HT6om0152jXSEj+256jukmouwDOExYhVvFPcfu
         bVmSLb7NHiBjHlcI4RVaVrZsAzKYB+bvnoa2etkUVoeMl6iK5H1hoPWxidQjY97M5Jkc
         p9bR8aHGhHDEyFdYc6W46XR6y9KU087Cj2abkabyBeCGGSsnVfSryEifQhaD1xss3PEk
         Wpqg==
X-Gm-Message-State: APjAAAWhYq1feGVWXgenVaXxX7vKWpBFRJkGGKYBhdUAanfo/ywWjtxW
        4hZj6nugtm8PFVFDnA3IlLcsMIZy1tRVh9BcFvQ=
X-Google-Smtp-Source: APXvYqxvHQeKguD98k0XdADD/VXzOjaffIHkuxcXXYHy0FpA90De4BOpFPS7MfUZZ1XksLjDU+lcQvwf79yN3UzAR8E=
X-Received: by 2002:a37:9b48:: with SMTP id d69mr7465606qke.449.1565933006557;
 Thu, 15 Aug 2019 22:23:26 -0700 (PDT)
MIME-Version: 1.0
References: <20190814164742.208909-1-sdf@google.com> <20190814164742.208909-3-sdf@google.com>
 <CAEf4BzZR12JgbSvBqS7LMZjLcsneVDfFL9XyZdi3gtneyA9X9g@mail.gmail.com>
 <CAEf4BzaE-KiW1Xt049A4s25YiaLeTH3yhgahwLUdpXNjF1sVpA@mail.gmail.com>
 <20190814195330.GL2820@mini-arch> <CAEf4BzaEJcTKV6s8cVinpJcBStvs2LAJ+obNjevw54EOQq1QdQ@mail.gmail.com>
 <CAADnVQ+Bz6R17bassdr3xOR7rhbuw-HbdXYu-hHkxE8S2WiNrA@mail.gmail.com>
In-Reply-To: <CAADnVQ+Bz6R17bassdr3xOR7rhbuw-HbdXYu-hHkxE8S2WiNrA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 15 Aug 2019 22:23:15 -0700
Message-ID: <CAEf4BzbA_GtJSSxtVKLL+x3hScSw6zVy2cKPgBcYCa1eisr28g@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/4] selftests/bpf: test_progs: test__skip
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Stanislav Fomichev <sdf@fomichev.me>,
        Stanislav Fomichev <sdf@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 15, 2019 at 10:16 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Aug 14, 2019 at 1:01 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> > >
> > > Let me know if you see a value in highlighting test vs subtest skip.
> > >
> > > Other related question is: should we do verbose output in case
> > > of a skip? Right now we don't do it.
> >
> > It might be useful, I guess, especially if it's not too common. But
> > Alexei is way more picky about stuff like that, so I'd defer to him. I
> > have no problem with a clean "SKIPPED: <test>/<subtest> (maybe some
> > reason for skipping here)" message.
>
> Since test_progs prints single number for FAILED tests then single number
> for SKIPPED tests is fine as well.

I'm fine with single number, but it should count number of subtests
skipped, if there are subtests within test, same as for FAILED.
