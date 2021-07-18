Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85D0E3CCA7B
	for <lists+netdev@lfdr.de>; Sun, 18 Jul 2021 21:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233207AbhGRTkE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Jul 2021 15:40:04 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:53384 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232869AbhGRTj5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Jul 2021 15:39:57 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 46F1E1FF85;
        Sun, 18 Jul 2021 19:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1626637017; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4VE9wboOFBx1A8aW4S+ryH5vyFPrMvrAxG+rYAOecbI=;
        b=ukHRmbXDBEVbDHcM8eunsLDAOCZk5tNxG2yqo2wO+OmNccN+pO9QVa8fBvTTQ+h1/EaJe+
        qsC1Me6BrCQHMrj/f3WSmmaTpkRy3BWLxX1oG5wrL3f/tcP4ZLSyMqvPiEb1Kzeuo4vzpa
        F7wuGKbvUdPQgRGF0k2/WVsElwduTII=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1626637017;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4VE9wboOFBx1A8aW4S+ryH5vyFPrMvrAxG+rYAOecbI=;
        b=P4Wce5HwkC9qDoGp1bzga35bz0KN5aO0WYhI+Y8CCVO4Vs+nvxKEGEASXw86rC2vKUtHP2
        DJOa6+oJWTVjvIDA==
Received: from kitsune.suse.cz (kitsune.suse.cz [10.100.12.127])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id AEAC5A3B83;
        Sun, 18 Jul 2021 19:36:56 +0000 (UTC)
Date:   Sun, 18 Jul 2021 21:36:55 +0200
From:   Michal =?iso-8859-1?Q?Such=E1nek?= <msuchanek@suse.de>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-riscv@lists.infradead.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH] libbpf: Remove from kernel tree.
Message-ID: <20210718193655.GP24916@kitsune.suse.cz>
References: <20210718065039.15627-1-msuchanek@suse.de>
 <c621c6c6-ad2d-5ce0-3f8c-014daf7cad64@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c621c6c6-ad2d-5ce0-3f8c-014daf7cad64@iogearbox.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 18, 2021 at 09:04:16PM +0200, Daniel Borkmann wrote:
> On 7/18/21 8:50 AM, Michal Suchanek wrote:
> > libbpf shipped by the kernel is outdated and has problems. Remove it.
> > 
> > Current version of libbpf is available at
> > 
> > https://github.com/libbpf/libbpf
> > 
> > Link: https://lore.kernel.org/bpf/b07015ebd7bbadb06a95a5105d9f6b4ed5817b2f.camel@debian.org/
> > Signed-off-by: Michal Suchanek <msuchanek@suse.de>
> 
> NAK, I'm not applying any of this. If there are issues, then fix them. If

They are fixed in the github version.

> you would have checked tools/lib/bpf/ git history, you would have found
> that libbpf is under active development in the upstream kernel tree and

So is the github version.

> you could have spared yourself this patch.

You could have spared me a lot of problems if there was only one source
for libbpf.

Can't you BPF people agree on one place to develop the library?

Thanks

Michal
