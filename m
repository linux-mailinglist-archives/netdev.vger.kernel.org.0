Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A43FB6CD5D5
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 11:04:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbjC2JEj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 05:04:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230458AbjC2JEf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 05:04:35 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 290A749FA;
        Wed, 29 Mar 2023 02:04:17 -0700 (PDT)
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1phRir-0007eL-U1; Wed, 29 Mar 2023 11:04:01 +0200
Message-ID: <09f58115-e3f2-52be-47d6-85cde9b92d25@leemhuis.info>
Date:   Wed, 29 Mar 2023 11:04:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH net-next] docs: netdev: clarify the need to sending
 reverts as patches
Content-Language: en-US, de-DE
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        corbet@lwn.net, linux-doc@vger.kernel.org,
        Linux kernel regressions list <regressions@lists.linux.dev>
References: <20230327172646.2622943-1-kuba@kernel.org>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <20230327172646.2622943-1-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1680080657;5f4960ef;
X-HE-SMSGID: 1phRir-0007eL-U1
X-Spam-Status: No, score=-0.0 required=5.0 tests=NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27.03.23 19:26, Jakub Kicinski wrote:
> We don't state explicitly that reverts need to be submitted
> as a patch. It occasionally comes up.
>  [...]
> +In cases where full revert is needed the revert has to be submitted
> +as a patch to the list with a commit message explaining the technical
> +problems with the reverted commit. Reverts should be used as a last resort,
> +when original change is completely wrong; incremental fixes are preferred.
> +

FWIW, I see how this is well meant, but I'm not really happy with the
last sentence, as one of the problems I notice when handling regression
is: it sometimes takes weeks to get regressions fixed that could have
been solved quickly by reverting the culprit (and reapplying an improved
version of the change or the change together and a fix later). That's
why Documentation/process/handling-regressions.rst strongly suggest to
revert changes that cause regressions if the problem can't be fixed
quickly -- especially if the change made it into a proper release. The
two texts thus now not slightly contradict each other.

I noticed that this change was already applied, but how would you feel
about changing the second sentence into something like this maybe?

```
Use reverts to quickly fix regressions that otherwise would take too
long to resolve. Apart from this reverts should be used as a last
resort, when the original change is completely wrong; incremental fixes
are preferred.
```

Or maybe this?

```
Incremental fixes in general are preferred over reverts, but the latter
are useful to quickly fix regressions that otherwise would take too long
to resolve. Apart from this reverts should be used as a last resort,
when the original change is completely wrong.
```

Ciao, Thorsten
