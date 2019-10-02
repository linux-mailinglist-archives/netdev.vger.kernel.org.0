Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 974ADC4A0A
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 10:56:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727209AbfJBI4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 04:56:00 -0400
Received: from www62.your-server.de ([213.133.104.62]:39636 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725852AbfJBIz7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 04:55:59 -0400
Received: from [2a02:120b:2c12:c120:71a0:62dd:894c:fd0e] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iFaQL-0004eR-MZ; Wed, 02 Oct 2019 10:55:53 +0200
Date:   Wed, 2 Oct 2019 10:55:53 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Brian Vazquez <brianvv.kernel@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Brian Vazquez <brianvv@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Stanislav Fomichev <sdf@google.com>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf 2/2] selftests/bpf: test_progs: don't leak server_fd
 in test_sockopt_inherit
Message-ID: <20191002085553.GA6226@pc-66.home>
References: <20191001173728.149786-1-brianvv@google.com>
 <20191001173728.149786-3-brianvv@google.com>
 <CAEf4BzYxs6Ace8s64ML3pA9H4y0vgdWv_vDF57oy3i-O_G7c-g@mail.gmail.com>
 <CABCgpaWbPN+2vSNdynHtmDxrgGbyzHa_D-y4-X8hLrQYbhTx=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABCgpaWbPN+2vSNdynHtmDxrgGbyzHa_D-y4-X8hLrQYbhTx=A@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25589/Tue Oct  1 10:30:33 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 01, 2019 at 08:42:30PM -0700, Brian Vazquez wrote:
> Thanks for reviewing the patches Andrii!
> 
> Although Daniel fixed them and applied them correctly.

After last kernel/maintainer summit at LPC, I reworked all my patchwork scripts [0]
which I use for bpf trees in order to further reduce manual work and add more sanity
checks at the same time. Therefore, the broken Fixes: tag was a good test-case. ;-)

Thanks,
Daniel

  [0] https://git.kernel.org/pub/scm/linux/kernel/git/dborkman/pw.git/

> On Tue, Oct 1, 2019 at 8:20 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Tue, Oct 1, 2019 at 10:40 AM Brian Vazquez <brianvv@google.com> wrote:
> > >
> >
> > I don't think there is a need to add "test_progs:" to subject, "
> > test_sockopt_inherit" is specific enough ;)
> >
> > > server_fd needs to be close if pthread can't be created.
> >
> > typo: closed
> >
> > > Fixes: e3e02e1d9c24 ("selftests/bpf: test_progs: convert test_sockopt_inherit")
> > > Cc: Stanislav Fomichev <sdf@google.com>
> > > Signed-off-by: Brian Vazquez <brianvv@google.com>
> > > ---
> >
> > Acked-by: Andrii Nakryiko <andriin@fb.com>
> >
> > >  tools/testing/selftests/bpf/prog_tests/sockopt_inherit.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
