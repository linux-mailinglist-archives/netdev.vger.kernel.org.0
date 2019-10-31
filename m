Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C92AEA87E
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 02:04:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbfJaBEE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 21:04:04 -0400
Received: from www62.your-server.de ([213.133.104.62]:43076 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726273AbfJaBED (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 21:04:03 -0400
Received: from 38.249.197.178.dynamic.dsl-lte-bonding.lssmb00p-msn.res.cust.swisscom.ch ([178.197.249.38] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iPysU-0000PM-L8; Thu, 31 Oct 2019 02:03:55 +0100
Date:   Thu, 31 Oct 2019 02:03:54 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     davem@davemloft.net, jolsa@redhat.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH bpf-next] bpf: Fix bpf jit kallsym access
Message-ID: <20191031010354.GA11351@pc-63.home>
References: <20191030233019.1187404-1-ast@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191030233019.1187404-1-ast@kernel.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25618/Wed Oct 30 09:54:22 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 30, 2019 at 04:30:19PM -0700, Alexei Starovoitov wrote:
> Jiri reported crash when JIT is on, but net.core.bpf_jit_kallsyms is off.
> bpf_prog_kallsyms_find() was skipping addr->bpf_prog resolution
> logic in oops and stack traces. That's incorrect.
> It should only skip addr->name resolution for 'cat /proc/kallsyms'.
> That's what bpf_jit_kallsyms and bpf_jit_harden protect.
> 
> Reported-by: Jiri Olsa <jolsa@redhat.com>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> Fixes: 3dec541b2e63 ("bpf: Add support for BTF pointers to x86 JIT")

ACK makes sense, applied, thanks!
