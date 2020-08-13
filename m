Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7309243A70
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 15:01:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726606AbgHMNBb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Aug 2020 09:01:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:56630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726131AbgHMNBb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Aug 2020 09:01:31 -0400
Received: from quaco.ghostprotocols.net (177.207.136.251.dynamic.adsl.gvt.net.br [177.207.136.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60C992078D;
        Thu, 13 Aug 2020 13:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597323690;
        bh=1KOO84jBp9k+vGNx1PLhbzn8bP6+PJCQeuZYx6xdx/k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kGUPXWdcoZ4yL8eY3VdCnSHYNaNMlfsZcxOlOSzA8v0O3rXynGwN3qL0o1WXOwjA/
         0k1o1iLSWtsn+c5gslmMgNly9ZNQGMivPXorPSscTJoNJ77bRLo7XvAj8NlJ5kOYCx
         r+NrNYsTG0aoGpG61GcbkIQO4pMk7BeqCjKCJxW4=
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id A86BE4097F; Thu, 13 Aug 2020 10:01:27 -0300 (-03)
Date:   Thu, 13 Aug 2020 10:01:27 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Tom Hebb <tommyhebb@gmail.com>
Cc:     Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <bpf@vger.kernel.org>
Subject: Re: [PATCH] tools build feature: Quote CC and CXX for their arguments
Message-ID: <20200813130127.GO13995@kernel.org>
References: <20200812221518.2869003-1-daniel.diaz@linaro.org>
 <CAMcCCgRGpi+3D4479MLU2xQZJYBA1c6mzZ=bb1VLEwPg3VAgLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMcCCgRGpi+3D4479MLU2xQZJYBA1c6mzZ=bb1VLEwPg3VAgLg@mail.gmail.com>
X-Url:  http://acmel.wordpress.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Wed, Aug 12, 2020 at 07:31:32PM -0700, Tom Hebb escreveu:
> On Wed, Aug 12, 2020 at 3:15 PM Daniel Díaz <daniel.diaz@linaro.org> wrote:
> >   Makefile.config:414: *** No gnu/libc-version.h found, please install glibc-dev[el].  Stop.
> >   Makefile.perf:230: recipe for target 'sub-make' failed
> >   make[1]: *** [sub-make] Error 2
> >   Makefile:69: recipe for target 'all' failed
> >   make: *** [all] Error 2
> >
> > With CC and CXX quoted, some of those features are now detected.
> >
> > Fixes: e3232c2f39ac ("tools build feature: Use CC and CXX from parent")
> >
> > Signed-off-by: Daniel Díaz <daniel.diaz@linaro.org>
> 
> Whoops, I'm the one who introduced this issue. Fix looks good, thanks!
> 
> Reviewed-by: Thomas Hebb <tommyhebb@gmail.com>
> Fixes: e3232c2f39ac ("tools build feature: Use CC and CXX from parent")

Thanks, applied.

- Arnaldo
