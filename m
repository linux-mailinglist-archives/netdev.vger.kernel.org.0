Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0CEC59F369
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 08:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234405AbiHXGGa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 02:06:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbiHXGGa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 02:06:30 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7AB01BCBE;
        Tue, 23 Aug 2022 23:06:28 -0700 (PDT)
Date:   Wed, 24 Aug 2022 08:06:21 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH nf] netfilter: nf_defrag_ipv6: allow
 nf_conntrack_frag6_high_thresh increases
Message-ID: <YwW/3dbRyuQnF8P7@salvia>
References: <20220823233848.2759487-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220823233848.2759487-1-eric.dumazet@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 23, 2022 at 04:38:48PM -0700, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Currently, net.netfilter.nf_conntrack_frag6_high_thresh can only be lowered.
> 
> I found this issue while investigating a probable kernel issue
> causing flakes in tools/testing/selftests/net/ip_defrag.sh
> 
> In particular, these sysctl changes were ignored:
> 	ip netns exec "${NETNS}" sysctl -w net.netfilter.nf_conntrack_frag6_high_thresh=9000000 >/dev/null 2>&1
> 	ip netns exec "${NETNS}" sysctl -w net.netfilter.nf_conntrack_frag6_low_thresh=7000000  >/dev/null 2>&1
> 
> This change is inline with commit 836196239298 ("net/ipfrag: let ip[6]frag_high_thresh
> in ns be higher than in init_net")

Applied, thanks
