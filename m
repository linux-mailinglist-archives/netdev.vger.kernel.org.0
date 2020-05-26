Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FE241E1B0E
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 08:13:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729628AbgEZGNO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 02:13:14 -0400
Received: from verein.lst.de ([213.95.11.211]:43248 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726363AbgEZGNN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 02:13:13 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id BE22268BEB; Tue, 26 May 2020 08:13:09 +0200 (CEST)
Date:   Tue, 26 May 2020 08:13:09 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Christoph Hellwig <hch@lst.de>, x86@kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-parisc@vger.kernel.org, linux-um@lists.infradead.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: clean up and streamline probe_kernel_* and friends v4
Message-ID: <20200526061309.GA15549@lst.de>
References: <20200521152301.2587579-1-hch@lst.de> <20200525151912.34b20b978617e2893e484fa3@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200525151912.34b20b978617e2893e484fa3@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 25, 2020 at 03:19:12PM -0700, Andrew Morton wrote:
> hm.  Applying linux-next to this series generates a lot of rejects against
> powerpc:
> 
> -rw-rw-r-- 1 akpm akpm  493 May 25 15:06 arch/powerpc/kernel/kgdb.c.rej
> -rw-rw-r-- 1 akpm akpm 6461 May 25 15:06 arch/powerpc/kernel/trace/ftrace.c.rej
> -rw-rw-r-- 1 akpm akpm  447 May 25 15:06 arch/powerpc/mm/fault.c.rej
> -rw-rw-r-- 1 akpm akpm  623 May 25 15:06 arch/powerpc/perf/core-book3s.c.rej
> -rw-rw-r-- 1 akpm akpm 1408 May 25 15:06 arch/riscv/kernel/patch.c.rej
> 
> the arch/powerpc/kernel/trace/ftrace.c ones aren't very trivial.
> 
> It's -rc7.  Perhaps we should park all this until 5.8-rc1?

As this is a pre-condition for the set_fs removal I'd really like to
get the actual changes in.  All these conflicts seem to be about the
last three cleanup patches just doing renaming, so can we just skip
those three for now?  Then we can do the rename right after 5.8-rc1
when we have the least chances for conflicts.
