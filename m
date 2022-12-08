Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D6946477C0
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 22:12:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbiLHVMh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 16:12:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiLHVM0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 16:12:26 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0A7B06FF3A;
        Thu,  8 Dec 2022 13:12:26 -0800 (PST)
Date:   Thu, 8 Dec 2022 22:12:23 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Li Qiong <liqiong@nfschina.com>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, coreteam@netfilter.org,
        Yu Zhe <yuzhe@nfschina.com>
Subject: Re: [PATCH v2] netfilter: add a 'default' case to 'switch
 (tuplehash->tuple.xmit_type)'
Message-ID: <Y5JTN8JLJJtMp1Ye@salvia>
References: <20221202070331.10865-1-liqiong@nfschina.com>
 <20221206074414.12208-1-liqiong@nfschina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221206074414.12208-1-liqiong@nfschina.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 06, 2022 at 03:44:14PM +0800, Li Qiong wrote:
> Add a 'default' case in case return a uninitialized value of ret.

Applied, thanks.
