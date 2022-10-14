Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19AC65FEA89
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 10:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbiJNI3d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 04:29:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbiJNI3b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 04:29:31 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 425871C25D2;
        Fri, 14 Oct 2022 01:29:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=gD39mBbo0s0UHYxPnZ34EfcXGTw8rckrJNocMHrWBSw=; b=UgSEIjRpo8QQ6VdXqqsR63zRgt
        ylKpQJPUyweLufskIjrb8gvM9b78nEcOO4QtONDjOoOuZYqGod6cnJAxyrumh86ggF4OLWXjhjgjp
        I3+vtCg5SbKRSCOJXJX3APOHORxYj46N64JOnsb/Tz4DFhP6Lq40frO/3PrbLcVBdReVPwATApgyA
        zvxE0q/yo9L75twoJikwyaAQsRToWyjQJ5NyEpC/kbx977dn8mPKRTh42grM7XmaQeuQYd/nYs9mR
        NqudyS26pk8TArNtJU1Ulqu5dkJb2VwCNZgRJ4vHic1LlLtYq+0J3Os9xMF8ZItYmWaqSLGCneW0l
        RLZtuGTQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ojG3p-007TAC-90; Fri, 14 Oct 2022 08:28:53 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 1BEC930012F;
        Fri, 14 Oct 2022 10:28:46 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id D31C6203CF67F; Fri, 14 Oct 2022 10:28:46 +0200 (CEST)
Date:   Fri, 14 Oct 2022 10:28:46 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Leonardo Bras <leobras@redhat.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Valentin Schneider <vschneid@redhat.com>,
        Tejun Heo <tj@kernel.org>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Phil Auld <pauld@redhat.com>,
        Antoine Tenart <atenart@kernel.org>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Wang Yufen <wangyufen@huawei.com>, mtosatti@redhat.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 1/4] sched/isolation: Fix style issues reported by
 checkpatch
Message-ID: <Y0kdvpcrCCD9qY8q@hirez.programming.kicks-ass.net>
References: <20221013184028.129486-1-leobras@redhat.com>
 <20221013184028.129486-2-leobras@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221013184028.129486-2-leobras@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 13, 2022 at 03:40:26PM -0300, Leonardo Bras wrote:
> scripts/checkpatch.pl warns about:
> - extern prototypes should be avoided in .h files

Checkpatch is wrong... :-)

(and yeah, I know the opinions on extern are divided, but I like it)
