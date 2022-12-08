Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A52A8647779
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 21:46:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbiLHUqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 15:46:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiLHUqR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 15:46:17 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E435818E32;
        Thu,  8 Dec 2022 12:46:16 -0800 (PST)
Date:   Thu, 8 Dec 2022 21:46:13 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Qingfang DENG <dqfext@gmail.com>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] netfilter: flowtable: really fix NAT IPv6 offload
Message-ID: <Y5JNFcUp2JrmgVfR@salvia>
References: <20221208123529.567883-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221208123529.567883-1-dqfext@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 08, 2022 at 08:35:29PM +0800, Qingfang DENG wrote:
> The for-loop was broken from the start. It translates to:
> 
> 	for (i = 0; i < 4; i += 4)
> 
> which means the loop statement is run only once, so only the highest
> 32-bit of the IPv6 address gets mangled.
> 
> Fix the loop increment.

Applied, thanks
