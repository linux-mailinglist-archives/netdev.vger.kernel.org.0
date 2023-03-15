Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4986F6BB5D3
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 15:20:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232341AbjCOOUw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 10:20:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbjCOOUv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 10:20:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C90956526;
        Wed, 15 Mar 2023 07:20:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 74AE261D7F;
        Wed, 15 Mar 2023 14:20:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC94DC4339C;
        Wed, 15 Mar 2023 14:20:45 +0000 (UTC)
Date:   Wed, 15 Mar 2023 10:20:44 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     Mike Rapoport <mike.rapoport@gmail.com>,
        Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Pekka Enberg <penberg@kernel.org>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        rcu@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Josh Triplett <josh@joshtriplett.org>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Mike Rapoport <rppt@kernel.org>,
        Neeraj Upadhyay <quic_neeraju@quicinc.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "Paul E. McKenney" <paulmck@kernel.org>
Subject: Re: [PATCH 0/7] remove SLOB and allow kfree() with
 kmem_cache_alloc()
Message-ID: <20230315102031.29585157@gandalf.local.home>
In-Reply-To: <3018fb77-68d0-fb67-2595-7c58c6cf7a76@suse.cz>
References: <20230310103210.22372-1-vbabka@suse.cz>
        <ZA2gofYkXRcJ8cLA@kernel.org>
        <20230313123147.6d28c47e@gandalf.local.home>
        <3018fb77-68d0-fb67-2595-7c58c6cf7a76@suse.cz>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Mar 2023 14:53:14 +0100
Vlastimil Babka <vbabka@suse.cz> wrote:

> On 3/13/23 17:31, Steven Rostedt wrote:
> > Just remove that comment. And you could even add:
> > 
> > Suggested-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> > Fixes: e4c2ce82ca27 ("ring_buffer: allocate buffer page pointer")  
> 
> Thanks for the analysis. Want to take the following patch to your tree or
> should I make it part of the series?

I can take it if you send it as a proper patch and Cc
linux-trace-kernel@vger.kernel.org.

I'm guessing it's not required for stable.

-- Steve
