Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43C7D64D92
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 22:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727438AbfGJUau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 16:30:50 -0400
Received: from ms.lwn.net ([45.79.88.28]:38458 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726111AbfGJUau (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Jul 2019 16:30:50 -0400
Received: from lwn.net (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id 181402BB;
        Wed, 10 Jul 2019 20:30:49 +0000 (UTC)
Date:   Wed, 10 Jul 2019 14:30:48 -0600
From:   Jonathan Corbet <corbet@lwn.net>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Kris Van Hees <kris.van.hees@oracle.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, dtrace-devel@oss.oracle.com,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        mhiramat@kernel.org, acme@kernel.org, ast@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Chris Mason <clm@fb.com>, brendan.d.gregg@gmail.com,
        davem@davemloft.net
Subject: Re: [PATCH V2 1/1 (was 0/1 by accident)] tools/dtrace: initial
 implementation of DTrace
Message-ID: <20190710143048.3923d1d9@lwn.net>
In-Reply-To: <c7f15d1d-1696-4d95-1729-4c4e97bdc43e@iogearbox.net>
References: <201907101537.x6AFboMR015946@aserv0122.oracle.com>
        <201907101542.x6AFgOO9012232@userv0121.oracle.com>
        <20190710181227.GA9925@oracle.com>
        <c7f15d1d-1696-4d95-1729-4c4e97bdc43e@iogearbox.net>
Organization: LWN.net
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 10 Jul 2019 21:32:25 +0200
Daniel Borkmann <daniel@iogearbox.net> wrote:

> Looks like you missed Brendan Gregg's prior feedback from v1 [0]. I haven't
> seen a strong compelling argument for why this needs to reside in the kernel
> tree given we also have all the other tracing tools and many of which also
> rely on BPF such as bcc, bpftrace, ply, systemtap, sysdig, lttng to just name
> a few.

So I'm just watching from the sidelines here, but I do feel the need to
point out that Kris appears to be trying to follow the previous feedback
he got from Alexei, where creating tools/dtrace is exactly what he was
told to do:

  https://lwn.net/ml/netdev/20190521175617.ipry6ue7o24a2e6n@ast-mbp.dhcp.thefacebook.com/

Now he's being told the exact opposite.  Not the best experience for
somebody who is trying to make the kernel better.

There are still people interested in DTrace out there.  How would you
recommend that Kris proceed at this point?

Thanks,

jon
