Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D13E2FCF09
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 12:21:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389202AbhATLRQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 06:17:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730486AbhATKrz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 05:47:55 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C256C0613ED;
        Wed, 20 Jan 2021 02:46:59 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1l2B0H-00051F-Cb; Wed, 20 Jan 2021 11:46:21 +0100
Date:   Wed, 20 Jan 2021 11:46:21 +0100
From:   Florian Westphal <fw@strlen.de>
To:     menglong8.dong@gmail.com
Cc:     kuba@kernel.org, christian.brauner@ubuntu.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dong.menglong@zte.com.cn,
        daniel@iogearbox.net, gnault@redhat.com, ast@kernel.org,
        nicolas.dichtel@6wind.com, ap420073@gmail.com, edumazet@google.com,
        pabeni@redhat.com, jakub@cloudflare.com, bjorn.topel@intel.com,
        keescook@chromium.org, viro@zeniv.linux.org.uk, rdna@fb.com,
        maheshb@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 3/3] net: core: Namespace-ify sysctl_rmem_max
 and sysctl_wmem_max
Message-ID: <20210120104621.GM19605@breakpoint.cc>
References: <20210118143932.56069-1-dong.menglong@zte.com.cn>
 <20210118143932.56069-4-dong.menglong@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210118143932.56069-4-dong.menglong@zte.com.cn>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

menglong8.dong@gmail.com <menglong8.dong@gmail.com> wrote:
> From: Menglong Dong <dong.menglong@zte.com.cn>
> 
> For now, sysctl_wmem_max and sysctl_rmem_max are globally unified.
> It's not convenient in some case. For example, when we use docker
> and try to control the default udp socket receive buffer for each
> container.
> 
> For that reason, make sysctl_wmem_max and sysctl_rmem_max
> per-namespace.

I think having those values be restricted by init netns is a desirable
property.
