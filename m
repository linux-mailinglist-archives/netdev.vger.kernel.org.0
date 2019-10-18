Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE6ACDCDD8
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 20:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410748AbfJRSU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 14:20:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:46290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394221AbfJRSU2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Oct 2019 14:20:28 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D946E20820;
        Fri, 18 Oct 2019 18:20:26 +0000 (UTC)
Date:   Fri, 18 Oct 2019 14:20:25 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Yonghong Song <yhs@fb.com>
Cc:     YueHaibing <yuehaibing@huawei.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH bpf-next] bpf: Fix build error without CONFIG_NET
Message-ID: <20191018142025.244156f8@gandalf.local.home>
In-Reply-To: <ee9a06ec-33a0-3b39-92d8-21bd86261cc2@fb.com>
References: <20191018090344.26936-1-yuehaibing@huawei.com>
        <ee9a06ec-33a0-3b39-92d8-21bd86261cc2@fb.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Oct 2019 18:11:07 +0000
Yonghong Song <yhs@fb.com> wrote:

> On 10/18/19 2:03 AM, YueHaibing wrote:
> > If CONFIG_NET is n, building fails:
> > 
> > kernel/trace/bpf_trace.o: In function `raw_tp_prog_func_proto':
> > bpf_trace.c:(.text+0x1a34): undefined reference to `bpf_skb_output_proto'
> > 
> > Wrap it into a #ifdef to fix this.
> > 
> > Reported-by: Hulk Robot <hulkci@huawei.com>
> > Fixes: a7658e1a4164 ("bpf: Check types of arguments passed into helpers")
> > Signed-off-by: YueHaibing <yuehaibing@huawei.com>  
> 
> Acked-by: Yonghong Song <yhs@fb.com>

I'm getting ready for another push to Linus. Want me to pull this into
my tree?

-- Steve
