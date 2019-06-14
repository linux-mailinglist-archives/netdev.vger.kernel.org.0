Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 711D346BC1
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 23:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726353AbfFNVT0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 17:19:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46642 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725908AbfFNVT0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 17:19:26 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5BCBC30832CC;
        Fri, 14 Jun 2019 21:19:21 +0000 (UTC)
Received: from treble (ovpn-121-232.rdu2.redhat.com [10.10.121.232])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CBE6061B7F;
        Fri, 14 Jun 2019 21:19:17 +0000 (UTC)
Date:   Fri, 14 Jun 2019 16:19:16 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     x86@kernel.org, Alexei Starovoitov <ast@kernel.org>,
        linux-kernel@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>,
        Kairui Song <kasong@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Laight <David.Laight@ACULAB.COM>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v2 4/5] x86/bpf: Fix 64-bit JIT frame pointer usage
Message-ID: <20190614211916.jnxakyfwilcv6r57@treble>
References: <cover.1560534694.git.jpoimboe@redhat.com>
 <178097de8c1bd6a877342304f3469eac4067daa4.1560534694.git.jpoimboe@redhat.com>
 <20190614210555.q4ictql3tzzjio4r@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190614210555.q4ictql3tzzjio4r@ast-mbp.dhcp.thefacebook.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Fri, 14 Jun 2019 21:19:26 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 14, 2019 at 02:05:56PM -0700, Alexei Starovoitov wrote:
> Have you tested it ?
> I really doubt, since in my test both CONFIG_UNWINDER_ORC and
> CONFIG_UNWINDER_FRAME_POINTER failed to unwind through such odd frame.

Hm, are you seeing selftest failures?  They seem to work for me.

> Here is much simple patch that I mentioned in the email yesterday,
> but you failed to listen instead of focusing on perceived 'code readability'.
> 
> It makes one proper frame and both frame and orc unwinders are happy.

I'm on my way out the door and I just skimmed it, but it looks fine.

Some of the code and patch description look familiar, please be sure to
give me proper credit.

-- 
Josh
