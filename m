Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4878240C787
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 16:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237929AbhIOOfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 10:35:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237528AbhIOOfl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 10:35:41 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 441F9C061574;
        Wed, 15 Sep 2021 07:34:22 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mQVzL-0005gG-JQ; Wed, 15 Sep 2021 16:34:15 +0200
Date:   Wed, 15 Sep 2021 16:34:15 +0200
From:   Florian Westphal <fw@strlen.de>
To:     youling 257 <youling257@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>, pablo@netfilter.org,
        netfilter-devel@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 09/10] netfilter: x_tables: never register
 tables by default
Message-ID: <20210915143415.GA20414@breakpoint.cc>
References: <20210811084908.14744-10-pablo@netfilter.org>
 <20210915095116.14686-1-youling257@gmail.com>
 <20210915095650.GG25110@breakpoint.cc>
 <CAOzgRdb_Agb=vNcAc=TDjyB_vSjB8Jua_TPtWYcXZF0G3+pRAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOzgRdb_Agb=vNcAc=TDjyB_vSjB8Jua_TPtWYcXZF0G3+pRAg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

youling 257 <youling257@gmail.com> wrote:
> record video screenshot, http://s7tu.com/images/2021/09/15/chBnr0.jpg

Looks like its running 'iptables -t raw -L' at time of crash,
but this works fine here.

Can you send me your .config and tell me which kernel version
this is exactly?
