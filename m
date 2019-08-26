Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7279D25B
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 17:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732089AbfHZPLd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 11:11:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:59624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727658AbfHZPLd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Aug 2019 11:11:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CC7F2080C;
        Mon, 26 Aug 2019 15:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566832292;
        bh=+3wHUCLAJU9VcfWi1FrlZA64sXlEodgwHT/8Q/mtsjI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OR4jEIiCGSjOeQ7p3D0b1a599hT5n5AXwsjSsd+L5p70ViHopNwSqtaDPjLPFcnje
         jPHj2tyExewzG7UQc6AoxoWeXV7E3TwIMQpaebUlf9XcakOvgkVAvgCz22YHxrm7DA
         i/mEEJD2gr0fxIM0iS3/kCd8nFfpGuIZ0K+CIp4M=
Date:   Mon, 26 Aug 2019 17:11:29 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     He Zhe <zhe.he@windriver.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, ndesaulniers@google.com,
        miguel.ojeda.sandonis@gmail.com, luc.vanoostenryck@gmail.com,
        schwidefsky@de.ibm.com, mst@redhat.com, gor@linux.ibm.com,
        andreyknvl@google.com, jpoimboe@redhat.com,
        liuxiaozhou@bytedance.com, yamada.masahiro@socionext.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: kernel/bpf/core.o: warning: objtool: ___bpf_prog_run.cold()+0x7:
 call without frame pointer save/setup
Message-ID: <20190826151129.GA21679@kroah.com>
References: <cf0273fb-c272-72be-50f9-b25bb7c7f183@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cf0273fb-c272-72be-50f9-b25bb7c7f183@windriver.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 26, 2019 at 10:42:53PM +0800, He Zhe wrote:
> Hi All,
> 
> Since 3193c0836f20 ("bpf: Disable GCC -fgcse optimization for ___bpf_prog_run()"),
> We have got the following warning,
> kernel/bpf/core.o: warning: objtool: ___bpf_prog_run.cold()+0x7: call without frame pointer save/setup
> 
> If reverting the above commit, we will get the following warning,
> kernel/bpf/core.o: warning: objtool: ___bpf_prog_run()+0x8b9: sibling call from callable instruction with modified stack frame
> if CONFIG_RETPOLINE=n, and no warning if CONFIG_RETPOLINE=y

Do you see this same problem on 5.3-rc6?

And what version of gcc are you using?

thanks,

greg k-h
