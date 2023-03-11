Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3616B58BA
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 06:42:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbjCKFmq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 00:42:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229654AbjCKFmp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 00:42:45 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D93301194DE;
        Fri, 10 Mar 2023 21:42:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A36E9CE2B1A;
        Sat, 11 Mar 2023 05:42:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 612B1C433EF;
        Sat, 11 Mar 2023 05:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678513359;
        bh=vBsyiOrtuUZnDxuciAPgUxX3KyQyRTvAK3jxbBTUy3Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bpi6GngOzA4nmdKPwHkLJV/d/NGsxv7qgNil8rQ3KiyYlBukFWDGj/RHbOITnta54
         78+oFobyxO2bgPGkn15n1ZuJ8OpAgDli564I6N6Kp2Vr76UHEv7ntU9GOlLwBlb7il
         1kAypYdqeaGZaO8IXezKW+qHvrg1kb+5iug9TRyCEVQZyWZvCiVu0sWE8rhzjapoQd
         ElER1+jVwm6yqhFkFC1c+fzOUSHrzeRi7i5FuOh/4/MHk7oyH3nmhjoEVIYHTyPt7s
         PeHky/4fZ43DE9E0MPMSOQCc2dR3AKcqGPPJZcxEjWdEwvqR3D6BtbKJynxmI4lIZq
         vACICT7MccIOg==
Date:   Fri, 10 Mar 2023 21:42:37 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     mptcp@lists.linux.dev, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <martineau@kernel.org>,
        Jiang Biao <benbjiang@tencent.com>,
        Menglong Dong <imagedong@tencent.com>,
        Mengen Sun <mengensun@tencent.com>,
        Shuah Khan <shuah@kernel.org>, Florian Westphal <fw@strlen.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Christoph Paasch <cpaasch@apple.com>, stable@vger.kernel.org,
        Geliang Tang <geliang.tang@suse.com>
Subject: Re: [PATCH net v2 0/8] mptcp: fixes for 6.3
Message-ID: <20230310214237.7ac422ed@kernel.org>
In-Reply-To: <20230227-upstream-net-20230227-mptcp-fixes-v2-0-47c2e95eada9@tessares.net>
References: <20230227-upstream-net-20230227-mptcp-fixes-v2-0-47c2e95eada9@tessares.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 09 Mar 2023 15:49:56 +0100 Matthieu Baerts wrote:
> Note that checkpatch.pl is now complaining about the "Closes" tag but
> discussions are ongoing to add an exception:
> 
>   https://lore.kernel.org/all/a27480c5-c3d4-b302-285e-323df0349b8f@tessares.net/

I've also complained about that series. One day we'll be a grown up
project where foundational tools are properly maintained and changes
to them reviewed. One day...
