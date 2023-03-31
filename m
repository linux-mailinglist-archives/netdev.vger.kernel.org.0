Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C68016D1E20
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 12:37:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230444AbjCaKhG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 06:37:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231220AbjCaKg6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 06:36:58 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE7B41116E;
        Fri, 31 Mar 2023 03:36:39 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1piC7S-0008GB-RZ; Fri, 31 Mar 2023 12:36:30 +0200
Date:   Fri, 31 Mar 2023 12:36:30 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     edumazet@google.com, davem@davemloft.net, dsahern@kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, threeearcat@gmail.com
Subject: Re: general protection fault in raw_seq_start
Message-ID: <20230331103630.GE22079@breakpoint.cc>
References: <CANn89iK5D75-SNg28ALi4Zr9JEHnreBpfu_pq0_zLe4jDLT5rw@mail.gmail.com>
 <20230331071725.66950-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230331071725.66950-1-kuniyu@amazon.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> And I found this seems wrong.
> 
> c25b7a7a565e ("inet: ping: use hlist_nulls rcu iterator during lookup")

How so?
