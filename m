Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 714515989B0
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 19:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345374AbiHRRCt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 13:02:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345421AbiHRRAq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 13:00:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C6E86B674;
        Thu, 18 Aug 2022 10:00:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 05F2A6163F;
        Thu, 18 Aug 2022 17:00:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A377AC43146;
        Thu, 18 Aug 2022 17:00:31 +0000 (UTC)
Date:   Thu, 18 Aug 2022 13:00:41 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Valentin Schneider <vschneid@redhat.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Yury Norov <yury.norov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Mel Gorman <mgorman@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Barry Song <song.bao.hua@hisilicon.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Tony Luck <tony.luck@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Gal Pressman <gal@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [PATCH v2 1/5] bitops: Introduce find_next_andnot_bit()
Message-ID: <20220818130041.5b7c955f@gandalf.local.home>
In-Reply-To: <xhsmh35dtbjr0.mognet@vschneid.remote.csb>
References: <20220817175812.671843-1-vschneid@redhat.com>
        <20220817175812.671843-2-vschneid@redhat.com>
        <20220818100820.3b45808b@gandalf.local.home>
        <xhsmh35dtbjr0.mognet@vschneid.remote.csb>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 18 Aug 2022 17:26:43 +0100
Valentin Schneider <vschneid@redhat.com> wrote:

> How about:

> 
>   find the next set bit in (*addr1 & ~*addr2)

I understand the above better. But to convert that into English, we could
say:


  Find the next bit in *addr1 excluding all the bits in *addr2.

or

  Find the next bit in *addr1 that is not set in *addr2.

-- Steve
