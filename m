Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1261D617B4C
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 12:04:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbiKCLEG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 07:04:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbiKCLEE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 07:04:04 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 389A76168;
        Thu,  3 Nov 2022 04:04:03 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1oqY0b-0001id-DU; Thu, 03 Nov 2022 12:03:41 +0100
Date:   Thu, 3 Nov 2022 12:03:41 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Ziyang Xuan <william.xuanziyang@huawei.com>
Cc:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: nfnetlink: fix potential dead lock in
 nfnetlink_rcv_msg()
Message-ID: <20221103110341.GA29268@breakpoint.cc>
References: <20221103011202.2160107-1-william.xuanziyang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221103011202.2160107-1-william.xuanziyang@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ziyang Xuan <william.xuanziyang@huawei.com> wrote:
> When type is NFNL_CB_MUTEX and -EAGAIN error occur in nfnetlink_rcv_msg(),
> it does not execute nfnl_unlock(). That would trigger potential dead lock.
>
> Fixes: 50f2db9e368f ("netfilter: nfnetlink: consolidate callback types")

Applied to nf:testing, thanks.
