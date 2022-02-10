Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62E794B0941
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 10:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238318AbiBJJNd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 04:13:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238312AbiBJJNb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 04:13:31 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0B922F1C;
        Thu, 10 Feb 2022 01:13:32 -0800 (PST)
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 4A827601BA;
        Thu, 10 Feb 2022 10:13:18 +0100 (CET)
Date:   Thu, 10 Feb 2022 10:13:29 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>, Yi Chen <yiche@redhat.com>
Subject: Re: [PATCH nf] selftests: netfilter: disable rp_filter on router
Message-ID: <YgTXHziKmce/fzDY@salvia>
References: <20220210033205.928458-1-liuhangbin@gmail.com>
 <YgTQ5KS1b2CZWvnR@Laptop-X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YgTQ5KS1b2CZWvnR@Laptop-X1>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 10, 2022 at 04:46:28PM +0800, Hangbin Liu wrote:
> Hi Pablo, Florian,
> On Thu, Feb 10, 2022 at 11:32:05AM +0800, Hangbin Liu wrote:
> > +ip netns exec ${nsrouter} sysctl net.ipv4.conf.veth0.rp_filter=0 > /dev/null
> > +ip netns exec ${nsrouter} sysctl net.ipv4.conf.veth1.rp_filter=0 > /dev/null
> 
> Oh, disable rp_filter on veth0 is enough for the current testing. But for the
> format and maybe a preparation for future testing. Disable veth1 rp_filter
> should also be OK. If you think there is no need to do this on veth1.
> I can send a v2 patch.

Send v2, I'll toss v1 patch.

Thanks.
