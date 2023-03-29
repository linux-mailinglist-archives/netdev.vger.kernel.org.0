Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 063806CF2A7
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 21:02:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbjC2TCQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 15:02:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbjC2TCQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 15:02:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7FDF359B;
        Wed, 29 Mar 2023 12:02:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 82B4461DF4;
        Wed, 29 Mar 2023 19:02:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB825C433EF;
        Wed, 29 Mar 2023 19:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680116533;
        bh=0mjhTs/AYRfejYCc3xoMzi99euoO0sqrmgcR7sOfpkQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HJJZ43AFuKUy1mp0H/T0s5v9a2x9ldmLt7qkVqIakBdD2iMZSriLL4gtvv0dVHRhL
         Szf9ncF7aFnObEzjcLTUhRsH3JiNFUq3eMEqZEBR1kst8/K+lWmD01JKCnGp27K0mn
         Ioa3LdjG9QaSmumk6MTFXuwYeBbfNqXks5+kV6cn5h3nuGyGoRB7APLG7bfqFZiR00
         X3bTeMUGxxXYk2VkZfNimYczN5lvC7U+lHvlKayTgE/+Ay4hLRVi+DISsAPwEU61nB
         2ExC8zIsEWs997c/jZuQUWKK1BCF5i3wK84ljU+F5TNwYEtsWo7+xNggfcObRv6gCa
         Ee7dUNj9PB0jQ==
Date:   Wed, 29 Mar 2023 12:02:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, corbet@lwn.net, linux-doc@vger.kernel.org,
        Linux kernel regressions list <regressions@lists.linux.dev>
Subject: Re: [PATCH net-next] docs: netdev: clarify the need to sending
 reverts as patches
Message-ID: <20230329120212.08755afb@kernel.org>
In-Reply-To: <09f58115-e3f2-52be-47d6-85cde9b92d25@leemhuis.info>
References: <20230327172646.2622943-1-kuba@kernel.org>
        <09f58115-e3f2-52be-47d6-85cde9b92d25@leemhuis.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Mar 2023 11:04:01 +0200 Thorsten Leemhuis wrote:
> FWIW, I see how this is well meant, but I'm not really happy with the
> last sentence, as one of the problems I notice when handling regression
> is: it sometimes takes weeks to get regressions fixed that could have
> been solved quickly by reverting the culprit (and reapplying an improved
> version of the change or the change together and a fix later). That's
> why Documentation/process/handling-regressions.rst strongly suggest to
> revert changes that cause regressions if the problem can't be fixed
> quickly -- especially if the change made it into a proper release. The
> two texts thus now not slightly contradict each other.
> 
> I noticed that this change was already applied, but how would you feel
> about changing the second sentence into something like this maybe?

Please escalate the cases which can be fixed by easy reverts because 
I can't think of any in networking :(

The entire doc is based on our painful experience telling people the
same thing over and over again, we don't want to include things which
don't actually happen on netdev. Longer the doc is the less likely
people will actually read it :(
