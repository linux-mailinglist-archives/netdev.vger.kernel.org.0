Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9240350E9CF
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 21:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245040AbiDYT74 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 15:59:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234273AbiDYT7y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 15:59:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89D5167D1A;
        Mon, 25 Apr 2022 12:56:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2C187B81A55;
        Mon, 25 Apr 2022 19:56:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FC71C385A4;
        Mon, 25 Apr 2022 19:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650916606;
        bh=xu5LqxL1Smy06xFA5MlkKfDIT4HK1pcD/S1NZx3iUzo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bua0NtWA+z7o7XF3q+DdmZVk1XhDf3/HziYNKtqdOlIyZljJEY7oCAZ5sm9bCMrmf
         dvKsU7cXEdveAWLNCnTo6vbA96DsTTvLhylAy8oq5i5vppiiwJ7FtNTfP9vEIfFQRW
         4bNgEuFH8nMFpUELf4ZUj6wu2U0nW65oU+og3dRW1anh8H4SS5/KTWsa6yQer1Yi8i
         6vZIsW8hZxDiYybhUKKve0Cgu5cDQoCAyB8mpSs/jUKJQ3p/s0dJndHaRlNcNRR1h8
         SLtF+3CH/80SD3iI6UlzsvvXoAPkVYFQ37nUPyVprWw7gg7mNI2icDmsiqyA2Euloi
         xFd1n3PKhxxqg==
Date:   Mon, 25 Apr 2022 12:56:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     xiangxia.m.yue@gmail.com, netdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Simon Horman <horms@verge.net.au>,
        Julian Anastasov <ja@ssi.bg>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, Shuah Khan <shuah@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Akhmat Karakotov <hmukos@yandex-team.ru>
Subject: Re: [net-next v4 0/3] use standard sysctl macro
Message-ID: <20220425125644.52e3aad4@kernel.org>
In-Reply-To: <Ymb6ukQNDh6VBT59@bombadil.infradead.org>
References: <20220422070141.39397-1-xiangxia.m.yue@gmail.com>
        <YmK/PM2x5PTG2b+c@bombadil.infradead.org>
        <20220422124340.2382da79@kernel.org>
        <Ymb6ukQNDh6VBT59@bombadil.infradead.org>
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

On Mon, 25 Apr 2022 12:47:06 -0700 Luis Chamberlain wrote:
> I have a better option. I checked to see the diff stat between
> the proposed patch to see what the chances of a conflict are
> and so far I don't see any conflict so I think this patchset
> should just go through your tree.
> 
> So feel free to take it in! Let me know if that's OK!

Ok, assuming the netfilter and bpf patches I saw were the only other
conversions we can resolve the conflicts before code reaches Linus...
