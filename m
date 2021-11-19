Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD94456A1D
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 07:15:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbhKSGSf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 01:18:35 -0500
Received: from verein.lst.de ([213.95.11.211]:49976 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229502AbhKSGSe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 01:18:34 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id B926968AFE; Fri, 19 Nov 2021 07:15:28 +0100 (CET)
Date:   Fri, 19 Nov 2021 07:15:28 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Christoph Hellwig <hch@lst.de>, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-doc@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH 1/2] bpf, docs: prune all references to "internal BPF"
Message-ID: <20211119061528.GA15129@lst.de>
References: <20211115130715.121395-1-hch@lst.de> <20211115130715.121395-2-hch@lst.de> <1bb1c024-55a0-b9bf-8aa1-2bfd7a3c367d@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1bb1c024-55a0-b9bf-8aa1-2bfd7a3c367d@iogearbox.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 18, 2021 at 12:09:02AM +0100, Daniel Borkmann wrote:
> Thanks for the cleanup! For the code occurrences with 'internal BPF', I would
> just drop the term 'internal' so it's only 'BPF' which is consistent with the
> rest in the kernel. Usually eBPF is implied given all the old cBPF stuff is
> translated to it anyway. Bit confusing, but that's where it converged over the
> years in the kernel including git log. eBPF vs cBPF unless it's explicitly
> intended to be called out (like in the filter.rst docs).

Ok.

> nit: We can probably just drop that comment since it's not very useful anyway
> and already implied by the function name.

Sounds good.
