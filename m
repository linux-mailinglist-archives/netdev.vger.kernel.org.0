Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39EB85606ED
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 19:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231273AbiF2REJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 13:04:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230072AbiF2REF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 13:04:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B54C3BA7C;
        Wed, 29 Jun 2022 10:04:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD83A61E38;
        Wed, 29 Jun 2022 17:04:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ACF9C341C8;
        Wed, 29 Jun 2022 17:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656522243;
        bh=LT/4rclcv8CQ0DzOB/V1Ibt/rIEd3slMQebLqTbu1MU=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=nQtcMEpfYeKbWO6wJ3nY4KeR2Eh+CWhTbuRsPbiSFKjc49LK7je/UNPcsvfIws0qY
         GrcJgwe9Zl+1aYqhsmXs/xlFIO1GAJAv05b3k8STp/S9XqwjQd//LpNSQkkHmkdQbD
         1K0R8dbv7+QZn4t/W8O961z8x71BrzkbU3EMc46H4rdGBhsZCrfue1ER4+io6v+FUg
         pHVs1T2KnolYy7oPAyyUL8rkqHJdmdfHD5zkFsWg9rryZ8Z/JvK7i0VFo507XeK5zh
         DnZbMMLlruplBrxswUzUhDbbd3OdaOhog76V88/4sYxlKWR4WZOm1Pos+8/QMzbqnh
         7uH12fphg1CjQ==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id B68635C0E5F; Wed, 29 Jun 2022 10:04:02 -0700 (PDT)
Date:   Wed, 29 Jun 2022 10:04:02 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Todd Kjos <tkjos@android.com>,
        Martijn Coenen <maco@android.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Christian Brauner <brauner@kernel.org>,
        Hridya Valsaraju <hridya@google.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Theodore Ts'o <tytso@mit.edu>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Alex Xu (Hello71)" <alex_y_xu@yahoo.ca>,
        Paolo Abeni <pabeni@redhat.com>, Rob Herring <robh@kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Neeraj Upadhyay <quic_neeraju@quicinc.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        wireguard@lists.zx2c4.com, netdev@vger.kernel.org,
        rcu@vger.kernel.org, linux-kselftest@vger.kernel.org,
        sultan@kerneltoast.com
Subject: Re: [PATCH] remove CONFIG_ANDROID
Message-ID: <20220629170402.GJ1790663@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20220629150102.1582425-1-hch@lst.de>
 <20220629150102.1582425-2-hch@lst.de>
 <Yrx5Lt7jrk5BiHXx@zx2c4.com>
 <20220629161020.GA24891@lst.de>
 <Yrx6EVHtroXeEZGp@zx2c4.com>
 <20220629161527.GA24978@lst.de>
 <20220629163444.GG1790663@paulmck-ThinkPad-P17-Gen-1>
 <20220629163701.GA25519@lst.de>
 <YryBvAvhnyZ4mZKD@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YryBvAvhnyZ4mZKD@zx2c4.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 29, 2022 at 06:45:48PM +0200, Jason A. Donenfeld wrote:
> On Wed, Jun 29, 2022 at 06:37:01PM +0200, Christoph Hellwig wrote:
> > be a policy set somewhere either in the kernel or fed into the kernel
> > by userspace.  Then we can key it off that, and I suspect it is
> > probably going to be a runtime variable and not a config option.
> 
> Right, this would be a good way of addressing it.
> 
> Maybe some Android people on the list have a good idea off hand of what
> Android uses at runtime to control this, and how it'd be accessible in
> the kernel?

In case it helps, in the case of CONFIG_RCU_EXP_CPU_STALL_TIMEOUT,
the Android guys can use things like defconfig at kernel-build time or
the rcu_exp_cpu_stall_timeout kernel-boot/sysfs parameter at boot time
or runtime.

							Thanx, Paul
