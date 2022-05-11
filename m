Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAD565231F5
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 13:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233342AbiEKLkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 07:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229975AbiEKLkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 07:40:17 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08018243107;
        Wed, 11 May 2022 04:40:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6CC3DCE238F;
        Wed, 11 May 2022 11:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AE8C7C34100;
        Wed, 11 May 2022 11:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652269212;
        bh=ZQbUUO8Y4AZVrR3mzv/zDquTt/wkFaDsgqrr/ygzt84=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Px+dw1LCvLNY4XT7pIfdjcpfLTmthQOKECoSt0CcKimhwarlDLWEg2CGjB5Q9jp4r
         A1v5QRWjR6QQ8Sp7jp14Fkwh/4yf/44o2s4W+BSM6UGVK36V/x9MyBjrodXSGURkZr
         QVW+izpepesUQt8oj8YjHkHIv8dZ6WJ1lVZzDT/mNGigLt4onaVk4Y08DDkAlamLEa
         telmn8/s3sz9U/3tbjtml4sjgJd+BUv7FoiEd5q0LKFCpFzZLn/VibAoFwS8gmrm1Y
         uAaKjUzh1baB+HmtNFLDsBsBVOebpb0sqR0qKZgrP2aSfR+a1M4sJzeQHUM9ZD8IXN
         rWVUxz7z3wzgg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 901CDF03931;
        Wed, 11 May 2022 11:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/3] s390/net: Cleanup some code checker findings
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165226921258.16940.11518826783364912077.git-patchwork-notify@kernel.org>
Date:   Wed, 11 May 2022 11:40:12 +0000
References: <20220510070508.334726-1-wintera@linux.ibm.com>
In-Reply-To: <20220510070508.334726-1-wintera@linux.ibm.com>
To:     Alexandra Winter <wintera@linux.ibm.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, hca@linux.ibm.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 10 May 2022 09:05:05 +0200 you wrote:
> clean up smatch findings in legacy code. I was not able to provoke
> any real failures on my systems, but other hardware reactions,
> timing conditions or compiler output, may cause failures.
> 
> There are still 2 smatch warnings left in s390/net:
> 
> drivers/s390/net/ctcm_main.c:1326 add_channel() warn: missing error code 'rc'
> This one is a false positive.
> 
> [...]

Here is the summary with links:
  - [net,1/3] s390/ctcm: fix variable dereferenced before check
    https://git.kernel.org/netdev/net/c/2c50c6867c85
  - [net,2/3] s390/ctcm: fix potential memory leak
    https://git.kernel.org/netdev/net/c/0c0b20587b9f
  - [net,3/3] s390/lcs: fix variable dereferenced before check
    https://git.kernel.org/netdev/net/c/671bb35c8e74

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


