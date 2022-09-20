Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2E665BE147
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 11:04:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230504AbiITJEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 05:04:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231158AbiITJCX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 05:02:23 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EEBB6CD08;
        Tue, 20 Sep 2022 02:02:05 -0700 (PDT)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1oaZ8W-0008Mk-G8; Tue, 20 Sep 2022 11:01:48 +0200
Message-ID: <d6d6b208-aec0-a4c3-8350-dbe2f474e7c0@leemhuis.info>
Date:   Tue, 20 Sep 2022 11:01:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Content-Language: en-US, de-DE
To:     Chris Clayton <chris2553@googlemail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        regressions@lists.linux.dev, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
References: <e5d757d7-69bc-a92a-9d19-0f7ed0a81743@googlemail.com>
 <20220908191925.GB16543@breakpoint.cc>
 <78611fbd-434e-c948-5677-a0bdb66f31a5@googlemail.com>
 <20220908214859.GD16543@breakpoint.cc> <YxsTMMFoaNSM9gLN@salvia>
 <a3c79b7d-526f-92ce-144a-453ec3c200a5@googlemail.com>
 <YxvwKlE+nyfUjHx8@salvia> <20220919124024.0c341af4@kernel.org>
 <20220919202310.GA3498@breakpoint.cc> <20220919135715.6057331d@kernel.org>
 <fc8792bf-2d67-496a-6d90-940de21694d9@googlemail.com>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
Subject: Re: removing conntrack helper toggle to enable auto-assignment [was
 Re: b118509076b3 (probably) breaks my firewall]
In-Reply-To: <fc8792bf-2d67-496a-6d90-940de21694d9@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1663664525;eb65bcf0;
X-HE-SMSGID: 1oaZ8W-0008Mk-G8
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Chris, thx for CCing the regression list, I've been watching this thread.

On 20.09.22 08:49, Chris Clayton wrote:
>
> So I guess I'm an unusual case in that I don't rely on distro maintainers to fix up stuff like this on the rare
> occasions it comes along. On reflection, I'd say leave it be

Okay. With a bit of luck only very few users are affected by this; if
not we might need to revisit this.

> - as I said earlier, it just seemed rather late in the 6.0
> development cycle for this to pop up.

With security fixes that can happen, as delaying the fix might the
inferior of two choices. :-/

Ciao, Thorsten
