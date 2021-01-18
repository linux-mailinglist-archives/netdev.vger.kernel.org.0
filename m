Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD8D2F9DE0
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 12:19:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388628AbhARLSP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 06:18:15 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40182 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390035AbhARLQd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 06:16:33 -0500
Received: from ip5f5af0a0.dynamic.kabel-deutschland.de ([95.90.240.160] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1l1SVE-00023L-IE; Mon, 18 Jan 2021 11:15:20 +0000
Date:   Mon, 18 Jan 2021 12:15:18 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     menglong8.dong@gmail.com
Cc:     kuba@kernel.org, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dong.menglong@zte.com.cn, daniel@iogearbox.net, gnault@redhat.com,
        ast@kernel.org, nicolas.dichtel@6wind.com, ap420073@gmail.com,
        edumazet@google.com, pabeni@redhat.com, jakub@cloudflare.com,
        bjorn.topel@intel.com, keescook@chromium.org,
        viro@zeniv.linux.org.uk, rdna@fb.com, maheshb@google.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: core: Namespace-ify sysctl_wmem_default
 and sysctl_rmem_default
Message-ID: <20210118111518.nsrtv52xsanf7q6d@wittgenstein>
References: <20210117102319.193756-1-dong.menglong@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210117102319.193756-1-dong.menglong@zte.com.cn>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 17, 2021 at 06:23:19PM +0800, menglong8.dong@gmail.com wrote:
> From: Menglong Dong <dong.menglong@zte.com.cn>
> 
> For now, sysctl_wmem_default and sysctl_rmem_default are globally
> unified. It's not convenient in some case. For example, when we
> use docker and try to control the default udp socket receive buffer
> for each container.
> 
> For that reason, make sysctl_wmem_default and sysctl_rmem_default
> per-namespace.
> 
> Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>
> ---

Hey Menglong,

I was about to review the two patches you sent:

1. [PATCH net-next] net: core: Namespace-ify sysctl_rmem_max and sysctl_wmem_max
   https://lore.kernel.org/lkml/20210117104743.217194-1-dong.menglong@zte.com.cn
2. [PATCH net-next] net: core: Namespace-ify sysctl_wmem_default and sysctl_rmem_default
   https://lore.kernel.org/lkml/20210117102319.193756-1-dong.menglong@zte.com.cn

and I had to spend some time figuring out that 2. is dependent on 1. I
first thought I got the base wrong.

I'd suggest you resend both patches as a part of a single series with a
cover letter mentioning the goal and use-case for these changes and also
pass --base=<base-commit>
when creating the patch series which makes it way easier to figure out
what to apply it to when wanting to review a series in the larger
context of a tree.

Thanks!
Christian
