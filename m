Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C17AB34A7D8
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 14:11:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbhCZNLY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 09:11:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:44066 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229882AbhCZNLH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 09:11:07 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 74BBFADD7;
        Fri, 26 Mar 2021 13:11:06 +0000 (UTC)
Date:   Fri, 26 Mar 2021 14:11:01 +0100
From:   Borislav Petkov <bp@suse.de>
To:     Sedat Dilek <sedat.dilek@gmail.com>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the tip tree
Message-ID: <20210326131101.GA27507@zn.tnic>
References: <20210322143714.494603ed@canb.auug.org.au>
 <20210322090036.GB10031@zn.tnic>
 <CA+icZUVkE73_31m0UCo-2mHOHY5i1E54_zMb7yp18UQmgN5x+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+icZUVkE73_31m0UCo-2mHOHY5i1E54_zMb7yp18UQmgN5x+A@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 26, 2021 at 09:57:43AM +0100, Sedat Dilek wrote:
> The commit b90829704780 "bpf: Use NOP_ATOMIC5 instead of
> emit_nops(&prog, 5) for BPF_TRAMP_F_CALL_ORIG" is now in Linus Git
> (see [1]).
> 
> Where will Stephen's fixup-patch be carried?
> Linux-next?
> net-next?
> <tip.git#x86/cpu>?

I guess we'll resolve it on our end and pick up sfr's patch, most
likely.

Thanks for letting me know.

-- 
Regards/Gruss,
    Boris.

SUSE Software Solutions Germany GmbH, GF: Felix Imendörffer, HRB 36809, AG Nürnberg
