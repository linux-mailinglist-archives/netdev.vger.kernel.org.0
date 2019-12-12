Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94E9B11D216
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 17:19:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729836AbfLLQTa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 11:19:30 -0500
Received: from www62.your-server.de ([213.133.104.62]:57736 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729591AbfLLQTa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 11:19:30 -0500
Received: from [194.230.159.122] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1ifRBS-0007Ab-RJ; Thu, 12 Dec 2019 17:19:23 +0100
Date:   Thu, 12 Dec 2019 17:19:22 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Paul Burton <paulburton@kernel.org>
Cc:     Paul Chaignon <paul.chaignon@orange.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>,
        Mahshid Khezri <khezri.mahshid@gmail.com>,
        paul.chaignon@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH bpf 2/2] bpf, mips: limit to 33 tail calls
Message-ID: <20191212161922.GA1264@localhost.localdomain>
References: <cover.1575916815.git.paul.chaignon@gmail.com>
 <b8eb2caac1c25453c539248e56ca22f74b5316af.1575916815.git.paul.chaignon@gmail.com>
 <20191210232316.aastpgbirqp4yaoi@lantea.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191210232316.aastpgbirqp4yaoi@lantea.localdomain>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25661/Thu Dec 12 10:47:42 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 10, 2019 at 03:23:16PM -0800, Paul Burton wrote:
> On Mon, Dec 09, 2019 at 07:52:52PM +0100, Paul Chaignon wrote:
> > All BPF JIT compilers except RISC-V's and MIPS' enforce a 33-tail calls
> > limit at runtime.  In addition, a test was recently added, in tailcalls2,
> > to check this limit.
> > 
> > This patch updates the tail call limit in MIPS' JIT compiler to allow
> > 33 tail calls.
> > 
> > Fixes: b6bd53f9c4e8 ("MIPS: Add missing file for eBPF JIT.")
> > Reported-by: Mahshid Khezri <khezri.mahshid@gmail.com>
> > Signed-off-by: Paul Chaignon <paul.chaignon@orange.com>
> 
> I'd be happy to take this through mips-fixes, but equally happy for it
> to go through the BPF/net trees in which case:

We took the series via bpf, thanks!
