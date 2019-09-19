Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85A5AB7986
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 14:33:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732160AbfISMdx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 08:33:53 -0400
Received: from www62.your-server.de ([213.133.104.62]:60624 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732153AbfISMdw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 08:33:52 -0400
Received: from [178.197.248.15] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iAvd9-0000Pz-4b; Thu, 19 Sep 2019 14:33:51 +0200
Date:   Thu, 19 Sep 2019 14:33:50 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH bpf 0/2] bpf: BTF fixes
Message-ID: <20190919123350.GC5504@pc-63.home>
References: <20190917174538.1295523-1-ast@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190917174538.1295523-1-ast@kernel.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25577/Thu Sep 19 10:20:13 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 17, 2019 at 10:45:36AM -0700, Alexei Starovoitov wrote:
> Two trivial BTF fixes.
> 
> Alexei Starovoitov (2):
>   bpf: fix BTF verification of enums
>   bpf: fix BTF limits
> 
>  include/uapi/linux/btf.h | 4 ++--
>  kernel/bpf/btf.c         | 5 ++---
>  2 files changed, 4 insertions(+), 5 deletions(-)

Applied, thanks!
