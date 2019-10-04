Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18295CB85F
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 12:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387478AbfJDKef (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 06:34:35 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:53232 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729427AbfJDKef (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 06:34:35 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us2.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 34056280072;
        Fri,  4 Oct 2019 10:34:33 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Fri, 4 Oct
 2019 03:34:28 -0700
Subject: Re: [PATCH bpf-next 0/9] xdp: Support multiple programs on a single
 interface through chain calls
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        "John Fastabend" <john.fastabend@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Lorenz Bauer <lmb@cloudflare.com>
CC:     Song Liu <songliubraving@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
References: <157002302448.1302756.5727756706334050763.stgit@alrua-x1>
 <E7319D69-6450-4BC3-97B1-134B420298FF@fb.com>
 <A754440E-07BF-4CF4-8F15-C41179DCECEF@fb.com> <87r23vq79z.fsf@toke.dk>
 <20191003105335.3cc65226@carbon>
 <CAADnVQKTbaxJhkukxXM7Ue7=kA9eWsGMpnkXc=Z8O3iWGSaO0A@mail.gmail.com>
 <87pnjdq4pi.fsf@toke.dk>
 <1c9b72f9-1b61-d89a-49a4-e0b8eead853d@solarflare.com>
 <5d964d8ccfd90_55732aec43fe05c47b@john-XPS-13-9370.notmuch>
 <87tv8pnd9c.fsf@toke.dk>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <68466316-c796-7808-6932-01d9d8c0a40b@solarflare.com>
Date:   Fri, 4 Oct 2019 11:34:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <87tv8pnd9c.fsf@toke.dk>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24952.005
X-TM-AS-Result: No-8.024700-4.000000-10
X-TMASE-MatchedRID: C/snMIRQLS3mLzc6AOD8DfHkpkyUphL9v/9ovxpTvIBsMPuLZB/IR3Iw
        ECVgOaniXZv12elAXYk2hlVDX2S+Ib+VKRYHl/ubX8aoF+qHHJ3oorYAfwrokEl/J9Ro+MABZFZ
        4+6wVBoyFhiX9bwPywDYOCES74k4UnKg65KVB+P1uh7qwx+D6TzFcf92WG8u/pNE6/wmkFAdpMf
        +k42Q07N0WkH6V+0rg9+eIYd9Ox/ayKRsiGe6y+QCSHRN4FLBrWw/S0HB7eoOykL7HJ0lm46BgO
        8/7EYOVf92MZgce96dCPYF0gRjARUrYfGvC1HVr0+C2Y9ztgG2eutXlSdRVjakNinB6fCXe1Is5
        GvhmGbw1aWq/d65GNQgBkd8UysKO5rARkHdbWIXN+qWlu2ZxaAeCHewokHM/kYldHqNEW7g+msb
        ci1PK/1QefH+t7oMfYRiQMlWnaceBDKLdTkiM2zdfT4zyWoZS64sVlliWKx+/WXZS/HqJ2gtuKB
        GekqUpOlxBO2IcOBZguiWqT9xKU1I0aMzN6p4NceTRNcWETPbMtA/VKIJbbioKap+HeVtzQwymt
        xuJ6y0=
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--8.024700-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24952.005
X-MDID: 1570185274-z_Dgpes2vve4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/10/2019 09:09, Toke Høiland-Jørgensen wrote:
> Having the mechanism be in-kernel makes solving these problems a lot
> easier, because the kernel can be responsible for state management, and
> it can enforce the chain call execution logic.
I would argue this isn't mechanism, but rather policy, because the
 mechanism we already have is sufficient to express the policy.

Enforcement is easily dealt with: you just don't give people the caps/
 perms to load XDP programs directly, so the only way they can do it is
 via your loader (which you give them a socket or dbus or something to
 talk to).  (Whereas your chain map doesn't really 'enforce' anything;
 anyone who can add themselves to the chain can also remove others.)
Then state inspection happens by querying the loader; if we assume that
 the distro provided the central loader, then they can also include the
 query in their standard system-dump tools.
Dynamic changes would just mean compiling a new dispatcher, then
 atomically replacing the old prog with the new (which we can already
 do), since the central loader daemon knows the call graph and can make
 changed versions easily.
Centralisation is something that happens normally in userspace; just
 count how many daemons your favourite init system runs to administer
 system resources and multiplex requests.  Probably we'd end up with
 one or two standard loaders and interfaces to them.
In any case, it seems like XDP users in userspace still need to
 communicate with each other in order to update the chain map (which
 seems to rely on knowing where one's own program fits into it); you
 suggest they might communicate through the chain map itself, and then
 veer off into the weeds of finding race-free ways of doing that.  This
 seems (to me) needlessly complex.

Incidentally, there's also a performance advantage to an eBPF dispatcher,
 because it means the calls to the individual programs can be JITted and
 therefore be direct, whereas an in-kernel data-driven dispatcher has to
 use indirect calls (*waves at spectre*).

> The fact that Lorenz et al are interested in this feature (even though
> they are essentially already doing what you suggested, by having a
> centralised daemon to manage all XDP programs), tells me that having
> kernel support for this is the right thing to do.
Maybe Lorenz could describe what he sees as the difficulties with the
 centralised daemon approach.  In what ways is his current "xdpd"
 solution unsatisfactory?

-Ed
