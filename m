Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65E402EFF54
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 13:15:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726251AbhAIMNT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 07:13:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725896AbhAIMNT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jan 2021 07:13:19 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49F87C061786;
        Sat,  9 Jan 2021 04:12:39 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1kyD6M-0005Tk-Dv; Sat, 09 Jan 2021 13:12:14 +0100
Date:   Sat, 9 Jan 2021 13:12:14 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Dinghao Liu <dinghao.liu@zju.edu.cn>
Cc:     kjlu@umn.edu, Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: Fix memleak in nf_nat_init
Message-ID: <20210109121214.GD19605@breakpoint.cc>
References: <20210109120121.15938-1-dinghao.liu@zju.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210109120121.15938-1-dinghao.liu@zju.edu.cn>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dinghao Liu <dinghao.liu@zju.edu.cn> wrote:
> When register_pernet_subsys() fails, nf_nat_bysource
> should be freed just like when nf_ct_extend_register()
> fails.

Acked-by: Florian Westphal <fw@strlen.de>
