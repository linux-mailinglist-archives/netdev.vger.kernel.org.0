Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D10A1C7CD5
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 23:52:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730034AbgEFVwA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 17:52:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728621AbgEFVv7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 17:51:59 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7162C061A0F;
        Wed,  6 May 2020 14:51:59 -0700 (PDT)
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jWRxN-0004dX-2p; Wed, 06 May 2020 23:51:57 +0200
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id 7735C100C8A; Wed,  6 May 2020 23:51:56 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: pulling cap_perfmon
In-Reply-To: <87sggdj8c6.fsf@nanos.tec.linutronix.de>
References: <CAADnVQJfD1dLVsfg4=c4f6ftRNF_4z0wELjFq8z=7voi-Ak=7w@mail.gmail.com> <87sggdj8c6.fsf@nanos.tec.linutronix.de>
Date:   Wed, 06 May 2020 23:51:56 +0200
Message-ID: <87h7wsk9z7.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei,

Thomas Gleixner <tglx@linutronix.de> writes:
> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>>
>> I'd like to pull
>> commit 980737282232 ("capabilities: Introduce CAP_PERFMON to kernel
>> and user space")
>> into bpf-next to base my CAP_BPF work on top of it.
>> could you please prepare a stable tag for me to pull ?
>> Last release cycle Thomas did a tag for bpf+rt prerequisite patches and
>> it all worked well during the merge window.
>> I think that one commit will suffice.
>
> I'll have a look.

here you go.

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-for-bpf-2020-05-06

Thanks,

        tglx
