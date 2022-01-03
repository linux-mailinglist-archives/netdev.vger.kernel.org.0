Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45E2A482FB6
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 10:57:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232554AbiACJ5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 04:57:17 -0500
Received: from verein.lst.de ([213.95.11.211]:46058 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229742AbiACJ5R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jan 2022 04:57:17 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id E26BD68AA6; Mon,  3 Jan 2022 10:57:12 +0100 (CET)
Date:   Mon, 3 Jan 2022 10:57:12 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-doc@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH 3/4] bpf, docs: Generate nicer tables for instruction
 encodings
Message-ID: <20220103095712.GA29880@lst.de>
References: <20211223101906.977624-1-hch@lst.de> <20211223101906.977624-4-hch@lst.de> <20211231004324.wvfqqgntnpswhzby@ast-mbp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211231004324.wvfqqgntnpswhzby@ast-mbp>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 30, 2021 at 04:43:24PM -0800, Alexei Starovoitov wrote:
> > +  ========  =====  =========================
> > +  code      value  description
> > +  ========  =====  =========================
> > +  BPF_JA    0x00   BPF_JMP only
> >    BPF_JEQ   0x10
> >    BPF_JGT   0x20
> >    BPF_JGE   0x30
> >    BPF_JSET  0x40
> 
> Not your fault, but the new table looks odd with
> only some opcodes documented.
> Same issue with BPF_ALU table.
> In the past the documented opcodes were for eBPF only and
> not documented in both, so it wasn't that bad.
> At least there was a reason for discrepancy.
> Now it just odd.
> May be add a comment to all rows?

Yes, having the description everywhere would be good.  But I'll have to
do research to actually figure out what should go in there for some.

> > +  =============  =====  =====================
> > +  mode modifier  value  description
> > +  =============  =====  =====================
> > +  BPF_IMM        0x00   used for 64-bit mov
> > +  BPF_ABS        0x20
> > +  BPF_IND        0x40
> > +  BPF_MEM        0x60
> 
> May be say here that ABS and IND are legacy for compat with classic only?
> and MEM is the most common modifier for load/store?

Sure.
