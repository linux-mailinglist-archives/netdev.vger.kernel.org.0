Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15D865FEA95
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 10:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbiJNIcz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 04:32:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbiJNIcx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 04:32:53 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55204190E77;
        Fri, 14 Oct 2022 01:32:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=3ysRf/XUGmt7J2wKxcUncSlHGfraCO3geaEjIZ3t3jE=; b=bCT42uP4yLYoNnO2O7/c9/kixP
        +c/n/awFAt7H02QLSzD61rQ+3X0DRt3o3XCPqcKXvRnzYO36zKbs6oikeaKggkJVGJf3WvOjMfN+a
        lMuDc65d6PaMDhOrQN00gtnjfDiy+LZbAOqjYe5UKE6sr0iD0Dps21b47+J55t4yAUOL/CtxNEutz
        BXCdeq6F/oB70T2ZyxO6wZ/9PRr0OcUNDnCu57HhiFssG+N4k1cavgKogX8AlGUsCj5elRtva49jV
        vgb8JYt4EPLh5oXKmgEam0tT7IA9MmflASFLc1eeN6tkpcySsoGUtIbR2T9gxjC4QezdEwJxYOjb2
        0+2tu58A==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ojG75-003MZI-6g; Fri, 14 Oct 2022 08:32:15 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id BA4FB30012F;
        Fri, 14 Oct 2022 10:32:14 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id A30BD203DBB33; Fri, 14 Oct 2022 10:32:14 +0200 (CEST)
Date:   Fri, 14 Oct 2022 10:32:14 +0200
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
Subject: Re: [PATCH v2 2/4] sched/isolation: Improve documentation
Message-ID: <Y0kejqowLYqHIS43@hirez.programming.kicks-ass.net>
References: <20221013184028.129486-1-leobras@redhat.com>
 <20221013184028.129486-3-leobras@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221013184028.129486-3-leobras@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 13, 2022 at 03:40:27PM -0300, Leonardo Bras wrote:

> +/* Kernel parameters like nohz_full and isolcpus allow passing cpu numbers
> + * for disabling housekeeping types.
> + *
> + * The functions bellow work the opposite way, by referencing which cpus
> + * are able to perform the housekeeping type in parameter.
> + */

So checkpatch should have bitten your head off for this drug-indiced
comment style :-)

https://lore.kernel.org/all/CA+55aFyQYJerovMsSoSKS7PessZBr4vNp-3QUUwhqk4A4_jcbg@mail.gmail.com/
