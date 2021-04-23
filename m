Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0876F3698BA
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 19:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243414AbhDWR4L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 13:56:11 -0400
Received: from mx2.suse.de ([195.135.220.15]:50986 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231400AbhDWR4I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 13:56:08 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 74A49B19D;
        Fri, 23 Apr 2021 17:55:30 +0000 (UTC)
Date:   Fri, 23 Apr 2021 19:55:28 +0200
From:   Michal =?iso-8859-1?Q?Such=E1nek?= <msuchanek@suse.de>
To:     Yonghong Song <yhs@fb.com>
Cc:     linux-kernel@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: linux-next failing build due to missing cubictcp_state symbol
Message-ID: <20210423175528.GF6564@kitsune.suse.cz>
References: <20210423130530.GA6564@kitsune.suse.cz>
 <316e86f9-35cc-36b0-1594-00a09631c736@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <316e86f9-35cc-36b0-1594-00a09631c736@fb.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 23, 2021 at 07:41:29AM -0700, Yonghong Song wrote:
> 
> 
> On 4/23/21 6:05 AM, Michal Suchánek wrote:
> > Hello,
> > 
> > I see this build error in linux-next (config attached).
> > 
> > [ 4939s]   LD      vmlinux
> > [ 4959s]   BTFIDS  vmlinux
> > [ 4959s] FAILED unresolved symbol cubictcp_state
> > [ 4960s] make[1]: ***
> > [/home/abuild/rpmbuild/BUILD/kernel-vanilla-5.12~rc8.next.20210422/linux-5.12-rc8-next-20210422/Makefile:1277:
> > vmlinux] Error 255
> > [ 4960s] make: *** [../Makefile:222: __sub-make] Error 2
> 
> Looks like you have DYNAMIC_FTRACE config option enabled already.
> Could you try a later version of pahole?

Is this requireent new?

I have pahole 1.20, and master does build without problems.

If newer version is needed can a check be added?

Thanks

Michal
