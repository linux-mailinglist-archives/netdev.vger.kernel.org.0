Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 739381D3727
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 18:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726240AbgENQ6F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 12:58:05 -0400
Received: from verein.lst.de ([213.95.11.211]:52780 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726139AbgENQ6F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 May 2020 12:58:05 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 6C0B668BEB; Thu, 14 May 2020 18:58:02 +0200 (CEST)
Date:   Thu, 14 May 2020 18:58:02 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     ast@kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
        torvalds@linux-foundation.org, mhiramat@kernel.org,
        brendan.d.gregg@gmail.com, hch@lst.de, john.fastabend@gmail.com,
        yhs@fb.com
Subject: Re: [PATCH bpf 0/3] Restrict bpf_probe_read{,str}() and
 bpf_trace_printk()'s %s
Message-ID: <20200514165802.GA3059@lst.de>
References: <20200514161607.9212-1-daniel@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200514161607.9212-1-daniel@iogearbox.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 14, 2020 at 06:16:04PM +0200, Daniel Borkmann wrote:
> Small set of fixes in order to restrict BPF helpers for tracing which are
> broken on archs with overlapping address ranges as per discussion in [0].
> I've targetted this for -bpf tree so they can be routed as fixes. Thanks!

Does that mean you are targeting them for 5.7?
