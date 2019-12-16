Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E1CE1208A0
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 15:29:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728055AbfLPO3l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 09:29:41 -0500
Received: from www62.your-server.de ([213.133.104.62]:40564 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727579AbfLPO3k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 09:29:40 -0500
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1igrNS-0000Ms-Ga; Mon, 16 Dec 2019 15:29:38 +0100
Date:   Mon, 16 Dec 2019 15:29:38 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Prashant Bhole <prashantbhole.linux@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next] libbpf: fix build by renaming variables
Message-ID: <20191216142938.GF14887@linux.fritz.box>
References: <20191216082738.28421-1-prashantbhole.linux@gmail.com>
 <20191216132512.GD14887@linux.fritz.box>
 <CAADnVQKB7hUmXBMmPfFUH4ZxSQfRtam0aEWykBNMhrKS+HjcwQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAADnVQKB7hUmXBMmPfFUH4ZxSQfRtam0aEWykBNMhrKS+HjcwQ@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25665/Mon Dec 16 10:52:23 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 16, 2019 at 06:02:26AM -0800, Alexei Starovoitov wrote:
> On Mon, Dec 16, 2019 at 5:25 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
> > On Mon, Dec 16, 2019 at 05:27:38PM +0900, Prashant Bhole wrote:
> > > In btf__align_of() variable name 't' is shadowed by inner block
> > > declaration of another variable with same name. Patch renames
> > > variables in order to fix it.
> > >
> > >   CC       sharedobjs/btf.o
> > > btf.c: In function ‘btf__align_of’:
> > > btf.c:303:21: error: declaration of ‘t’ shadows a previous local [-Werror=shadow]
> > >   303 |   int i, align = 1, t;
> > >       |                     ^
> > > btf.c:283:25: note: shadowed declaration is here
> > >   283 |  const struct btf_type *t = btf__type_by_id(btf, id);
> > >       |
> > >
> > > Fixes: 3d208f4ca111 ("libbpf: Expose btf__align_of() API")
> > > Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
> >
> > Applied, thanks!
> 
> Prashant,
> Thanks for the fixes.
> Which compiler do use?
> Sadly I didn't see any of those with my gcc 6.3.0
> Going to upgrade it. Need to decide which one.

I've seen it with:

$ gcc --version
gcc (GCC) 9.0.1 20190312 (Red Hat 9.0.1-0.10)
