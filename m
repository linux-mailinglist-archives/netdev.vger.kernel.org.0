Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1B158375C
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 05:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237443AbiG1DL6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 23:11:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234002AbiG1DL5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 23:11:57 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F9AE5C349
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 20:11:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id AEB0BCE244B
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 03:11:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A234C433D6;
        Thu, 28 Jul 2022 03:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658977912;
        bh=1SNSiKmrD55Mrexc+UHC5e3u9EGIYwjK8lNQa1fTIeU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jaZrT7fsmNp6KQ16mjK9VHBK30cCGsWaM8PVVC+SZ7HRBkrxPpVaBzVWVwZPJZeNY
         pqu9cbqiysyXwGqyFrf4mrRB0VIEOfhU7h/SzOkMzTyBc2Ithb5GYnUNtnaMguiDsu
         1VcE8GTdJd6PJu3ymA7L5nGbGNYAkBVlc6Dn4v3AlO6KbcrFqueqdilXjOlEIoboyP
         kNt9OLp5UGuklLAgIWkTTCfwOBHeUMY9XEoefBgTSOrP3cp0tqF9n77nsH9l3F0qB1
         HKLiDxdM3Lh336ZFeQKb45YUD7q+nwNlgBZCOIk0wEwHHWfSfECI121KNaaQcagb/5
         ujnAZ+loyrRhg==
Date:   Wed, 27 Jul 2022 20:11:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "Paolo Abeni" <pabeni@redhat.com>,
        Lorenzo Colitti <lorenzo@google.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Ayushman Dutta <ayudutta@amazon.com>, <netdev@vger.kernel.org>,
        <syzbot+a8430774139ec3ab7176@syzkaller.appspotmail.com>
Subject: Re: [PATCH v2 net] net: ping6: Fix memleak in ipv6_renew_options().
Message-ID: <20220727201151.62da5a99@kernel.org>
In-Reply-To: <20220728012220.46918-1-kuniyu@amazon.com>
References: <20220728012220.46918-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 Jul 2022 18:22:20 -0700 Kuniyuki Iwashima wrote:
>   - Remove ip6_flush_pending_frames() (Jakub Kicinski)

To be clear I was just asking if it's needed, I haven't checked the code
:)
