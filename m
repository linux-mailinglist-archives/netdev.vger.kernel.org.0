Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3B263E2EB
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 22:49:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbiK3Vty (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 16:49:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiK3Vtx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 16:49:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 366225AE36;
        Wed, 30 Nov 2022 13:49:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C5D4E61DE9;
        Wed, 30 Nov 2022 21:49:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1A60C433D6;
        Wed, 30 Nov 2022 21:49:50 +0000 (UTC)
Date:   Wed, 30 Nov 2022 16:49:49 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Paul E. McKenney" <paulmck@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Joel Fernandes <joel@joelfernandes.org>, rcu@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@meta.com,
        David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-afs@lists.infradead.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH rcu 14/16] rxrpc: Use call_rcu_hurry() instead of
 call_rcu()
Message-ID: <20221130164949.26282b9a@gandalf.local.home>
In-Reply-To: <20221130214552.GW4001@paulmck-ThinkPad-P17-Gen-1>
References: <20221130181316.GA1012431@paulmck-ThinkPad-P17-Gen-1>
        <20221130181325.1012760-14-paulmck@kernel.org>
        <CAEXW_YS1nfsV_ohXDaB1i2em=+0KP1DofktS24oGFa4wPAbiiw@mail.gmail.com>
        <CANn89iKg-Ka96yGFHCUWXtug494eO5i2KU_c8GTPNXDi6mWpYg@mail.gmail.com>
        <20221130214552.GW4001@paulmck-ThinkPad-P17-Gen-1>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 30 Nov 2022 13:45:52 -0800
"Paul E. McKenney" <paulmck@kernel.org> wrote:

> On Wed, Nov 30, 2022 at 07:37:07PM +0100, Eric Dumazet wrote:
> > Ah, I see a slightly better name has been chosen ;)  
> 
> call_rcu_vite()?  call_rcu_tres_grande_vitesse()?  call_rcu_tgv()?
> 
> Sorry, couldn't resist!  ;-)
> 
>

  call_rcu_twitter_2_0()  ?

-- Steve
