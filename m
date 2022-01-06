Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A73E4862DE
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 11:23:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237880AbiAFKXQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 05:23:16 -0500
Received: from foss.arm.com ([217.140.110.172]:51770 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237872AbiAFKXQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jan 2022 05:23:16 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8011411D4;
        Thu,  6 Jan 2022 02:23:15 -0800 (PST)
Received: from FVFF77S0Q05N (unknown [10.57.10.56])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4E38C3F774;
        Thu,  6 Jan 2022 02:23:12 -0800 (PST)
Date:   Thu, 6 Jan 2022 10:23:06 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     Palmer Dabbelt <palmer@dabbelt.com>
Cc:     jszhang3@mail.ustc.edu.cn, tglx@linutronix.de,
        Paul Walmsley <paul.walmsley@sifive.com>,
        aou@eecs.berkeley.edu, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, john.fastabend@gmail.com,
        kpsingh@kernel.org, masahiroy@kernel.org, michal.lkml@markovi.net,
        ndesaulniers@google.com, wangkefeng.wang@huawei.com,
        tongtiangen@huawei.com, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 09/12] riscv: extable: add `type` and `data` fields
Message-ID: <YdbAgybzS2Uw9/qC@FVFF77S0Q05N>
References: <20211118152155.GB9977@lakrids.cambridge.arm.com>
 <mhng-84ef2902-21c8-4cde-9d02-aa89f913a981@palmer-ri-x1c9>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <mhng-84ef2902-21c8-4cde-9d02-aa89f913a981@palmer-ri-x1c9>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 05, 2022 at 07:21:26PM -0800, Palmer Dabbelt wrote:
> On Thu, 18 Nov 2021 07:21:55 PST (-0800), mark.rutland@arm.com wrote:
> > On Thu, Nov 18, 2021 at 07:42:49PM +0800, Jisheng Zhang wrote:
> > > On Thu, 18 Nov 2021 19:26:05 +0800 Jisheng Zhang wrote:
> > > Hi Mark, Thomas,
> > > 
> > > x86 and arm64 version of sort_relative_table routine are the same, I want to
> > > unify them, and then use the common function for riscv, but I'm not sure
> > > which name is better. Could you please suggest?
> > 
> > I sent a patch last week which unifies them as
> > sort_relative_table_with_data():
> > 
> >   https://lore.kernel.org/linux-arm-kernel/20211108114220.32796-1-mark.rutland@arm.com/
> > 
> > Thomas, are you happy with that patch?
> > 
> > With your ack it could go via the riscv tree for v5.17 as a preparatory
> > cleanup in this series.
> > 
> > Maybe we could get it in as a cleanup for v5.16-rc{2,3} ?
> 
> I don't see anything on that thread, and looks like last time I had to touch
> sorttable I just took it via the RISC-V tree.  I went ahead and put Mark's
> patch, along with this patch set, on my for-next. 

FWIW, that sounds good to me. Thanks for picking that up!

> I had to fix up a few minor issues, so LMK if anything went off the rails.

I assume that was just for this patch set, as I couldn't spot any change to my
patch in the riscv for-next branch.

Thanks,
Mark.
