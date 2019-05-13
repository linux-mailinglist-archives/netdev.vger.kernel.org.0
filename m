Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 125651BBDD
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 19:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731661AbfEMRZf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 13:25:35 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:34204 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730184AbfEMRZc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 May 2019 13:25:32 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C55FE341;
        Mon, 13 May 2019 10:25:31 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.72.51.249])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 03D353F6C4;
        Mon, 13 May 2019 10:25:29 -0700 (PDT)
Date:   Mon, 13 May 2019 18:25:27 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        bpf <bpf@vger.kernel.org>, syzbot <syzkaller@googlegroups.com>,
        Petar Penkov <ppenkov@google.com>,
        Stanislav Fomichev <sdf@google.com>
Subject: Re: [PATCH net] flow_dissector: disable preemption around BPF calls
Message-ID: <20190513172527.GB16567@lakrids.cambridge.arm.com>
References: <20190513163855.225489-1-edumazet@google.com>
 <20190513171745.GA16567@lakrids.cambridge.arm.com>
 <CANn89iJzsUbLXB_M5UZr2ieNyQdGHsKPFzqeQFGtKtL8d9pu0Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iJzsUbLXB_M5UZr2ieNyQdGHsKPFzqeQFGtKtL8d9pu0Q@mail.gmail.com>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 13, 2019 at 10:20:19AM -0700, 'Eric Dumazet' via syzkaller wrote:
> On Mon, May 13, 2019 at 10:17 AM Mark Rutland <mark.rutland@arm.com> wrote:
> >
> > On Mon, May 13, 2019 at 09:38:55AM -0700, 'Eric Dumazet' via syzkaller wrote:
> > > Various things in eBPF really require us to disable preemption
> > > before running an eBPF program.
> >
> > Is that true for all eBPF uses? I note that we don't disable preemption
> > in the lib/test_bpf.c module, for example.
> >
> > If it's a general requirement, perhaps it's worth an assertion within
> > BPF_PROG_RUN()?
> 
> The assertion is already there :)
> 
> This is how syzbot triggered the report.

Ah! :)

I also see I'm wrong about test_bpf.c, so sorry for the noise on both
counts!

Thanks,
Mark.
