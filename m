Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F36B16C75F9
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 03:42:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231202AbjCXCmm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 22:42:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbjCXCml (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 22:42:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A6AC12F;
        Thu, 23 Mar 2023 19:42:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6B95B82202;
        Fri, 24 Mar 2023 02:42:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD33CC433D2;
        Fri, 24 Mar 2023 02:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679625757;
        bh=qr/I2rq/Nk6IhI6pHC1NrcrtV8HlhwtbKRcChWmSJAk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=i7ZgLTDncgSj6MuZwPZpK6jvP/ir4837GNSnuNM303s77SIhw7GmHExDwnSx7NJUT
         DugUv8Z7nYQipWLta7+61CgmOgAZSwPLUTw7APf7wRJEs2H0q42QV/93GE1aV1ezyB
         uijs/xkuIW1T1OhTL0mC9sZwMtBxmdOpARegjLHL32To9mMiiFlu0KR9W6MVa5noDJ
         8h8h2+VaSK2a3HEDrVOVNialA05ebObJo1pCkd/0b2zQ3y8e2nHljx4gsq2WyGnjZy
         L6+64CqbwLyfbABtFXsM+1QEt2e8hAP6fni5hg06V4684SF2svKz3RZ0iQVDcBapZ2
         cT9wcDReGuDZg==
Date:   Thu, 23 Mar 2023 19:42:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, Bagas Sanjaya <bagasdotme@gmail.com>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Florian Fainelli <f.fainelli@gmail.com>, corbet@lwn.net,
        jesse.brandeburg@intel.com, mkl@pengutronix.de,
        linux-doc@vger.kernel.org, stephen@networkplumber.org,
        romieu@fr.zoreil.com
Subject: Re: [PATCH net-next v3] docs: networking: document NAPI
Message-ID: <20230323194235.66fbd368@kernel.org>
In-Reply-To: <e9caa256-482d-1cc0-4244-e9d4c5615f01@blackwall.org>
References: <20230322053848.198452-1-kuba@kernel.org>
        <e9caa256-482d-1cc0-4244-e9d4c5615f01@blackwall.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Mar 2023 12:39:59 +0200 Nikolay Aleksandrov wrote:
> > +It is recommended to pin each kernel thread to a single CPU, the same
> > +CPU as services the interrupt. Note that the mapping between IRQs and  
> 
> "... the same CPU as services the interrupt ...", should it be
> "the same CPU that services the interrupt" ?

"the same as" is a very common idiom.
There's a slight ellipsis there, perhaps, the full sentence is:

| It is recommended to pin each kernel thread to a single CPU, the same
| CPU as [the CPU which] services the interrupt.

Let me add the missing part.
