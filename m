Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22FF52159BB
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 16:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729287AbgGFOim (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 10:38:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729148AbgGFOik (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 10:38:40 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00D4FC061755;
        Mon,  6 Jul 2020 07:38:39 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1jsSGI-0005GB-J2; Mon, 06 Jul 2020 16:38:26 +0200
Date:   Mon, 6 Jul 2020 16:38:26 +0200
From:   Florian Westphal <fw@strlen.de>
To:     wenxu@ucloud.cn
Cc:     davem@davemloft.net, pablo@netfilter.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-next 1/3] netfilter: nf_defrag_ipv4: Add
 nf_ct_frag_gather support
Message-ID: <20200706143826.GA32005@breakpoint.cc>
References: <1593959312-6135-1-git-send-email-wenxu@ucloud.cn>
 <1593959312-6135-2-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1593959312-6135-2-git-send-email-wenxu@ucloud.cn>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

wenxu@ucloud.cn <wenxu@ucloud.cn> wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> Add nf_ct_frag_gather for conntrack defrag and it will
> elide the CB clear when packets are defragmented by
> connection tracking

Why is this patch required?
Can't you rework ip_defrag to avoid the cb clear if you need that?
