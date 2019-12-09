Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD0A116D4E
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 13:49:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727610AbfLIMte (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 07:49:34 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:52231 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727403AbfLIMtd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 07:49:33 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 714504b5
        for <netdev@vger.kernel.org>;
        Mon, 9 Dec 2019 11:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type:content-transfer-encoding; s=mail; bh=xUqq53kk40Pa
        RW6u1XxXI0JPgYk=; b=qQQss+BzxNG6IujtnBRLVBMx2UfVXXeNkMoAZUmUmSDH
        gBQswu+tiZioSDUWD/rq2N7FoQc++Ruop5b7W30yRLFHdKFdk+jrVuzpKVgVzF3W
        W2SrZVWc+z20iIZQaUs2xouAuvTx+urbWhh0011OhZUZnoVa1I6ZIyZ5ClVcizS+
        RfV4zgzE7gHAOWW/3mbMJIPE7B0urOVRUBiyP2q4+NliKqKixmfac1yz07M0BNFu
        KjCBrY2nhc6pJYcY/zoP8qK0EOEwOcaJMmrJtjh7BcDAv/KTDBAlWAXsmD2GhRFD
        H5mdM3sA+EIlrkolV580okANkw46OoQJFa4cCXjSUg==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 9b3621b6 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Mon, 9 Dec 2019 11:54:08 +0000 (UTC)
Received: by mail-oi1-f180.google.com with SMTP id b8so6180502oiy.5
        for <netdev@vger.kernel.org>; Mon, 09 Dec 2019 04:49:32 -0800 (PST)
X-Gm-Message-State: APjAAAVTAjVUV0FKvs30PlszY5mhZIFBsmo2430t7ne2YS1ZC+1romRf
        CIOtNLVmJlVTaFcl1kn62wg6UBNpOSQcVT38i3g=
X-Google-Smtp-Source: APXvYqwOzIdO7q1spvx3hUouA9yi+b9gMiJTQ7zsvN5FAvPerpV3NOoXuWjh3/dEq0IxWyqOCiJ0elBZC3i7KlTDbcE=
X-Received: by 2002:aca:2109:: with SMTP id 9mr8317760oiz.119.1575895771647;
 Mon, 09 Dec 2019 04:49:31 -0800 (PST)
MIME-Version: 1.0
References: <CAHmME9p1-5hQXv5QNqqHT+OBjn-vf16uAU2HtYcmwKMtLhnsTA@mail.gmail.com>
 <87d0cxlldu.fsf@toke.dk>
In-Reply-To: <87d0cxlldu.fsf@toke.dk>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 9 Dec 2019 13:49:20 +0100
X-Gmail-Original-Message-ID: <CAHmME9oUfp_1udMFNMpeXPeoa7aacdNp9Q31eKvoTBpu+G5rpQ@mail.gmail.com>
Message-ID: <CAHmME9oUfp_1udMFNMpeXPeoa7aacdNp9Q31eKvoTBpu+G5rpQ@mail.gmail.com>
Subject: Re: organization of wireguard linux kernel repos moving forward
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>
Cc:     WireGuard mailing list <wireguard@lists.zx2c4.com>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 9, 2019 at 1:43 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.=
dk> wrote:
>
> "Jason A. Donenfeld" <Jason@zx2c4.com> writes:
>
> > 2) wireguard-tools.git will have the userspace utilities and scripts,
> > such as wg(8) and wg-quick(8), and be easily packageable by distros.
> > This repo won't be live until we get a bit closer to the 5.6 release,
> > but when it is live, it will live at:
> > https://git.zx2c4.com/wireguard-tools/ [currently 404s]
> > https://git.kernel.org/pub/scm/linux/kernel/git/zx2c4/wireguard-tools.g=
it/
> > [currently 404s]
>
> Any plans for integrating this further with iproute2? One could imagine
> either teaching 'ip' about the wireguard-specific config (keys etc), or
> even just moving the 'wg' binary wholesale into iproute2?

I'd definitely be interested in this. Back in 2015, that was the plan.
Then it took a long time to get to where we are now, and since then
wg(8) has really evolved into its own useful thing. The easiest thing
would be to move wg(8) wholesale into iproute2 like you suggested;
that'd allow people to continue using their infrastructure and whatnot
they've used for a long time now. A more nuanced approach would be
coming up with a _parallel_ iproute2 tool with mostly the same syntax
as wg(8) but as a subcommand of ip(8). Originally the latter appealed
to me, but at this point maybe the former is better after all. I
suppose something to consider is that wg(8) is actually a
cross-platform tool now, with a unified syntax across a whole bunch of
operating systems. But it's also just boring C.
