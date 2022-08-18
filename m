Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1A71598C44
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 21:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242967AbiHRTAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 15:00:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345501AbiHRTA3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 15:00:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 876B060519
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 12:00:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4282CB8235B
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 19:00:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD76BC433C1;
        Thu, 18 Aug 2022 19:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660849226;
        bh=Y6tFkpn15+IXEWZGby3sOa0HYPWnWiA2o4ELKmgpeg8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iHkPa21kQzrT/YR37vy49yHLNUWLHrnk6ZWxqmbQwiwO5WJybsZVTc3E3+k4ecLlC
         q8SlBYPNgFSYaquiJCdRWIhnpR0wcEggWqTUA+2dSwRpMi0N73XRpxAtqasNdu/8lt
         3wbKbqvo0biriCcre27Ynb6pBRs1b63lOJIqEMGgNm8V4e9pE7ISUBwUPGT+UGBW2B
         dCsJ6k+5f8BC2ZPOH3tbEk4DYBJuAC+jVBkQDu91t1hj+YWJ6mdrtIZwdSYzPbt0h3
         +wVwBzBIk/JUXjvxON57X8y232/gB5SbY6HO0t/I7UhRbke9+SguzePVJlEvawQAeR
         Hpy497gtc0sxw==
Date:   Thu, 18 Aug 2022 12:00:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH v3 net 00/17] net: sysctl: Fix data-races around
 net.core.XXX
Message-ID: <20220818120025.3b854d35@kernel.org>
In-Reply-To: <20220818182653.38940-1-kuniyu@amazon.com>
References: <20220818182653.38940-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 18 Aug 2022 11:26:36 -0700 Kuniyuki Iwashima wrote:
> This series fixes data-races around all knobs in net_core_table and
> netns_core_table except for bpf stuff.

No need to repost or split this one, but for future reference please 
be reminded that the limit is 15 patches per series:

https://www.kernel.org/doc/html/latest/process/maintainer-netdev.html
