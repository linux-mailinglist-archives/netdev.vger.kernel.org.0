Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 035F6456A21
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 07:16:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbhKSGTs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 01:19:48 -0500
Received: from verein.lst.de ([213.95.11.211]:49983 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229521AbhKSGTr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 01:19:47 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 6BF3968AFE; Fri, 19 Nov 2021 07:16:43 +0100 (CET)
Date:   Fri, 19 Nov 2021 07:16:42 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-doc@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH 2/2] bpf, doc: split general purpose eBPF documentation
 out of filter.rst
Message-ID: <20211119061642.GB15129@lst.de>
References: <20211115130715.121395-1-hch@lst.de> <20211115130715.121395-3-hch@lst.de> <20211118005613.g4sqaq2ucgykqk2m@ast-mbp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211118005613.g4sqaq2ucgykqk2m@ast-mbp>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 17, 2021 at 04:56:13PM -0800, Alexei Starovoitov wrote:
> I think the split would be good in the long term, but please make the links
> more obvious somehow in the filter.rst, since a bunch of posts on the web
> link back to that file. The folks who will be reading the revamped filter.rst
> would need a very obvious way to navigate to new pages.

What would be a good way to make it more obvious?  Add a section with
links to the three new documentents and/or the Documentation/bpf/
index?

> In terms of followups and cleanup... please share what you have in mind.

The prime issue I'd like to look in is to replace all the references
to classic BPF and instead make the document standadlone.
