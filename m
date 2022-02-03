Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DCB64A8A4C
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 18:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352954AbiBCRkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 12:40:19 -0500
Received: from verein.lst.de ([213.95.11.211]:38389 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352587AbiBCRkS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Feb 2022 12:40:18 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id D06B368BFE; Thu,  3 Feb 2022 18:40:11 +0100 (CET)
Date:   Thu, 3 Feb 2022 18:40:10 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH 3/5] bpf, docs: Better document the legacy packet
 access instruction
Message-ID: <20220203174010.GA16681@lst.de>
References: <20220131183638.3934982-1-hch@lst.de> <20220131183638.3934982-4-hch@lst.de> <CAADnVQLiEQFzON5OEV_LVYzqJuZ68e0AnqhNC++vptbed6ioEw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQLiEQFzON5OEV_LVYzqJuZ68e0AnqhNC++vptbed6ioEw@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 03, 2022 at 09:32:38AM -0800, Alexei Starovoitov wrote:
> These two places make it sound like it's interpreter only behavior.
> I've reworded it like:
> -the interpreter context is a pointer to networking packet.  ``BPF_ABS``
> +the program context is a pointer to networking packet.  ``BPF_ABS``
> 
> -interpreter will abort the execution of the program.
> +program execution will be aborted.
> 
> and pushed to bpf-next with the rest of patches.

The interpreter thing is actually unchanged from the old text, but I
totally agree with your fixup.  Thanks!
