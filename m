Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09D571E62EA
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 15:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390809AbgE1NxK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 09:53:10 -0400
Received: from www62.your-server.de ([213.133.104.62]:55736 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390804AbgE1NxH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 09:53:07 -0400
Received: from 75.57.196.178.dynamic.wline.res.cust.swisscom.ch ([178.196.57.75] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jeIxo-0003jE-DN; Thu, 28 May 2020 15:52:52 +0200
Date:   Thu, 28 May 2020 15:52:51 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Eelco Chaudron <echaudro@redhat.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Subject: Re: [PATCH bpf-next] libbpf: fix perf_buffer__free() API for sparse
 allocs
Message-ID: <20200528135251.GA24961@pc-9.home>
References: <159056888305.330763.9684536967379110349.stgit@ebuild>
 <CAEf4BzZ8h89QXQLFKM34iggW3M1AzBFKcqvq2J9Jn=Ur9yM7YA@mail.gmail.com>
 <54F16472-92CB-4A18-BC7D-0DB8741496E4@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54F16472-92CB-4A18-BC7D-0DB8741496E4@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25826/Thu May 28 14:33:30 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 28, 2020 at 09:24:58AM +0200, Eelco Chaudron wrote:
> On 27 May 2020, at 19:58, Andrii Nakryiko wrote:
> > On Wed, May 27, 2020 at 1:42 AM Eelco Chaudron <echaudro@redhat.com>
> > wrote:
> > > 
> > > In case the cpu_bufs are sparsely allocated they are not
> > > all free'ed. These changes will fix this.
> > > 
> > > Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
> > > ---
> > 
> > Thanks a lot!
> > 
> > You forgot:
> > 
> > Fixes: fb84b8224655 ("libbpf: add perf buffer API")
> 
> Thanks, I forgot that :(  Daniel do you want me to send a v2, or will you
> add it when you apply it?

No worries, added it. Applied to bpf-next, thanks!
