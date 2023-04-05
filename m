Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E55156D7DC4
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 15:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238246AbjDENcE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 09:32:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237960AbjDENcC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 09:32:02 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D618630F3;
        Wed,  5 Apr 2023 06:32:01 -0700 (PDT)
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1pk3F2-0006dY-C8; Wed, 05 Apr 2023 15:32:00 +0200
Message-ID: <833120c6-8a96-4773-9205-6d3aadbba6b7@leemhuis.info>
Date:   Wed, 5 Apr 2023 15:31:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [REGRESSION] v6.1+ bind() does not fail with EADDRINUSE if dual
 stack is bound
Content-Language: en-US, de-DE
To:     Paul Holzinger <pholzing@redhat.com>, stable@vger.kernel.org
Cc:     netdev@vger.kernel.org, regressions@lists.linux.dev,
        martin.lau@kernel.org, kuba@kernel.org
References: <e21bf153-80b0-9ec0-15ba-e04a4ad42c34@redhat.com>
From:   "Linux regression tracking #adding (Thorsten Leemhuis)" 
        <regressions@leemhuis.info>
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
In-Reply-To: <e21bf153-80b0-9ec0-15ba-e04a4ad42c34@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1680701521;fadc3b78;
X-HE-SMSGID: 1pk3F2-0006dY-C8
X-Spam-Status: No, score=-1.4 required=5.0 tests=NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[TLDR: This mail in primarily relevant for Linux kernel regression
tracking. See link in footer if these mails annoy you.]

On 10.03.23 17:01, Paul Holzinger wrote:
> 
> there seems to be a regression which allows you to bind the same port
> twice when the first bind call bound to all ip addresses (i. e. dual
> stack).
> [...]
> Original report: https://github.com/containers/podman/issues/17719
> 
> #regzbot introduced: 5456262d2baa

I had missed that a fix for this was applied, as it didn't contain a
link to the reports for this issue, hence I have to specify it manually
to resolve this:

#regzbot fix: d9ba9934285514f1f9
#regzbot ignore-activity

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
--
Everything you wanna know about Linux kernel regression tracking:
https://linux-regtracking.leemhuis.info/about/#tldr
That page also explains what to do if mails like this annoy you.


