Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36F7D614865
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 12:18:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbiKALSn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 07:18:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbiKALSk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 07:18:40 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B587110AF
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 04:18:39 -0700 (PDT)
Date:   Tue, 1 Nov 2022 12:18:35 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Peng Wu <wupeng58@huawei.com>
Cc:     kadlec@netfilter.org, fw@strlen.de, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        coreteam@netfilter.org, netdev@vger.kernel.org, liwei391@huawei.com
Subject: Re: [PATCH -next] netfilter: nft_inner: fix return value check in
 nft_inner_parse_l2l3()
Message-ID: <Y2EAi0KTzywaJo1d@salvia>
References: <20221101013728.93115-1-wupeng58@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221101013728.93115-1-wupeng58@huawei.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 01, 2022 at 01:37:28AM +0000, Peng Wu wrote:
> In nft_inner_parse_l2l3(), the return value of skb_header_pointer() is
> 'veth' instead of 'eth' when case 'htons(ETH_P_8021Q)' and fix it.

Applied to nf-next, thanks
