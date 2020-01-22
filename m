Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48D67145E6A
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 23:12:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726054AbgAVWMi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 17:12:38 -0500
Received: from www62.your-server.de ([213.133.104.62]:43860 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725970AbgAVWMi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 17:12:38 -0500
Received: from 48.249.197.178.dynamic.dsl-lte-bonding.lssmb00p-msn.res.cust.swisscom.ch ([178.197.249.48] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iuOEf-0003Vj-QH; Wed, 22 Jan 2020 23:12:29 +0100
Date:   Wed, 22 Jan 2020 23:12:29 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH v2 bpf-next 0/3] bpf: Program extensions or dynamic
 re-linking
Message-ID: <20200122221229.GA27474@pc-9.home>
References: <20200121005348.2769920-1-ast@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200121005348.2769920-1-ast@kernel.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25703/Wed Jan 22 12:37:53 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 20, 2020 at 04:53:45PM -0800, Alexei Starovoitov wrote:
> The last few month BPF community has been discussing an approach to call
> chaining, since exiting bpt_tail_call() mechanism used in production XDP
> programs has plenty of downsides. The outcome of these discussion was a
> conclusion to implement dynamic re-linking of BPF programs. Where rootlet XDP
> program attached to a netdevice can programmatically define a policy of
> execution of other XDP programs. Such rootlet would be compiled as normal XDP
> program and provide a number of placeholder global functions which later can be
> replaced with future XDP programs. BPF trampoline, function by function
> verification were building blocks towards that goal. The patch 1 is a final
> building block. It introduces dynamic program extensions. A number of
> improvements like more flexible function by function verification and better
> libbpf api will be implemented in future patches.
> 
> v1->v2:
> - addressed Andrii's comments
> - rebase

Applied, thanks!
