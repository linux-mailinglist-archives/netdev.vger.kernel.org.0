Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5BECA0A4
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 16:54:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729300AbfJCOyF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 10:54:05 -0400
Received: from www62.your-server.de ([213.133.104.62]:38296 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727611AbfJCOyF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 10:54:05 -0400
Received: from 57.248.197.178.dynamic.dsl-lte-bonding.zhbmb00p-msn.res.cust.swisscom.ch ([178.197.248.57] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iG2UU-0001Cf-Rt; Thu, 03 Oct 2019 16:54:03 +0200
Date:   Thu, 3 Oct 2019 16:54:02 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     KP Singh <kpsingh@chromium.org>
Cc:     Song Liu <liu.song.a23@gmail.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf] samples/bpf: fix build for task_fd_query_user.c
Message-ID: <20191003145402.GC9196@pc-66.home>
References: <20191001112249.27341-1-bjorn.topel@gmail.com>
 <CAPhsuW5c9v0OnU4g+eYkPjBCuNMjC_69pFhzr=nTfDMAy4bK6w@mail.gmail.com>
 <CACYkzJ6EuhtEPDH=3Gr8eo5=NtUVgCMvqq64POX31pB-gVSbTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACYkzJ6EuhtEPDH=3Gr8eo5=NtUVgCMvqq64POX31pB-gVSbTA@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25591/Thu Oct  3 10:30:38 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 02, 2019 at 11:02:09PM +0200, KP Singh wrote:
> On Wed, Oct 2, 2019 at 8:46 PM Song Liu <liu.song.a23@gmail.com> wrote:
> > On Tue, Oct 1, 2019 at 4:26 AM Björn Töpel <bjorn.topel@gmail.com> wrote:
> > >
> > > From: Björn Töpel <bjorn.topel@intel.com>
> > >
> > > Add missing "linux/perf_event.h" include file.
> > >
> > > Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
> >
> > Acked-by: Song Liu <songliubraving@fb.com>
> 
> Tested-by: KP Singh <kpsingh@google.com>
> 
> (https://lore.kernel.org/bpf/20191002185233.GA3650@chromium.org/T/#t)

Applied, thanks! Given also KP and Florent sent a similar patch earlier,
I've added Reported-by and improved the commit message a bit to something
more useful with regards to *why* we suddenly need to add the include.
