Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF90E69EB1C
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 00:20:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbjBUXUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 18:20:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbjBUXUi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 18:20:38 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 88B66298CA;
        Tue, 21 Feb 2023 15:20:37 -0800 (PST)
Date:   Wed, 22 Feb 2023 00:20:32 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Hangyu Hua <hbh25y@gmail.com>
Cc:     kadlec@netfilter.org, fw@strlen.de, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: netfilter: fix possible refcount leak in
 ctnetlink_create_conntrack()
Message-ID: <Y/VRwLYyEkdxQR/B@salvia>
References: <20230210071730.21525-1-hbh25y@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230210071730.21525-1-hbh25y@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 10, 2023 at 03:17:30PM +0800, Hangyu Hua wrote:
> nf_ct_put() needs to be called to put the refcount got by
> nf_conntrack_find_get() to avoid refcount leak when
> nf_conntrack_hash_check_insert() fails.

Applied to nf, thanks
