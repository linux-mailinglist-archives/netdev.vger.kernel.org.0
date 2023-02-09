Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33099690FF9
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 19:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbjBISKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 13:10:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbjBISKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 13:10:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1DBD64642;
        Thu,  9 Feb 2023 10:10:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A5BB61B80;
        Thu,  9 Feb 2023 18:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B25AEC4339C;
        Thu,  9 Feb 2023 18:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675966220;
        bh=Kqv2IeDdyGgw89vV7rbiWhgPk1mwq9gF7uiqZ8xUTFY=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=fjjKu9uCcA1G6D/ZmYE1zmaz2DVmyJInX+OMgV6qlUqCvvBkkr/KZHH9GUsoeE8P2
         7v4jiPGR3/BlViB/3GQ5bXV4kWe3f2qvJcp5QDZPjES/TWNy4G9n60lbHQ+dNeDwRF
         SsQlDHN4DoqxXg0PjjpadeMpFtwBkxe22e4itlFSiBKYv2GMPt7I7UoIIioibNX4dQ
         w4MCfnbBvLUSfHuOL4tO6Zqo+uDlpK7CgSViU18kOvR7+vuplxlV8wUwcjPsgyYNdC
         jOfaDwzUgWua8SZcQu2YQdpVl9sr6JeyT1ELzDWA0zUtg6kPwIE2VQ+Jd5Y+LZCmWC
         JQkMMFTWuQm7Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9D0D6E49FB1;
        Thu,  9 Feb 2023 18:10:20 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for 6.2-rc8
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20230209144227.37380-1-pabeni@redhat.com>
References: <20230209144227.37380-1-pabeni@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20230209144227.37380-1-pabeni@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.2-rc8
X-PR-Tracked-Commit-Id: 3a082086aa200852545cf15159213582c0c80eba
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 35674e787518768626d3a0ffce1c13a7eeed922d
Message-Id: <167596622063.10454.13144244311299397693.pr-tracker-bot@kernel.org>
Date:   Thu, 09 Feb 2023 18:10:20 +0000
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu,  9 Feb 2023 15:42:27 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-6.2-rc8

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/35674e787518768626d3a0ffce1c13a7eeed922d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
