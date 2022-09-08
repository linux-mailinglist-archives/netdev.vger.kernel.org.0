Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3CF55B1627
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 10:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231349AbiIHIAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 04:00:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231321AbiIHIA2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 04:00:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E436D1E3C;
        Thu,  8 Sep 2022 01:00:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F5F2B82041;
        Thu,  8 Sep 2022 08:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EDB6DC433C1;
        Thu,  8 Sep 2022 08:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662624019;
        bh=jUFtx1KBt3KNIY4iwx1Ga7HplznItOA+o+7lorq0K7Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GAGtZgabncXqzv+C+XbLfg/t4nlpRy+LVNrsszHV9fK/jRrD/n/g+z/I3FEiadK9p
         jDgxczeL9GqvteQuanJQOMLmdYP8AhwnV/VA5uYdRgKlXFEg0bXyBJ9Y2j89NJcgV+
         eDA08QmR5tkaIIWaosCTL8/3wD/0PqRvbvs3QC0SUILLqk0G+ygTrTQGEnEwAJOnVp
         eaminSxACPgcbJYkTF4BMVFt7CdWkHTzqI+D/J3UECGJcE524kFbtyMFu1u9bJEuCL
         SNUowgBZWfoavmCDI8S77vpqKZwG777jyUMtcA97n27xv8e+aKKJN0fhz11zQ3au5e
         BhuwKQ8RfDUeQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CACB9C73FEF;
        Thu,  8 Sep 2022 08:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V2 net-next 0/5] add some new features
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166262401882.15934.10787389592220440891.git-patchwork-notify@kernel.org>
Date:   Thu, 08 Sep 2022 08:00:18 +0000
References: <20220906091223.46142-1-huangguangbin2@huawei.com>
In-Reply-To: <20220906091223.46142-1-huangguangbin2@huawei.com>
To:     huangguangbin (A) <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lipeng321@huawei.com,
        lanhao@huawei.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 6 Sep 2022 17:12:18 +0800 you wrote:
> This series adds some new features for the HNS3 ethernet driver.
> 
> Patches #1~#3 support configuring dscp map to tc.
> 
> Patch 4# supports querying FEC statistics by command "ethtool -I --show-fec eth0".
> 
> Patch 5# supports querying and setting Serdes lane number.
> 
> [...]

Here is the summary with links:
  - [V2,net-next,1/5] net: hns3: add support config dscp map to tc
    https://git.kernel.org/netdev/net-next/c/0ba22bcb222d
  - [V2,net-next,2/5] net: hns3: support ndo_select_queue()
    https://git.kernel.org/netdev/net-next/c/f6e32724ca13
  - [V2,net-next,3/5] net: hns3: debugfs add dump dscp map info
    https://git.kernel.org/netdev/net-next/c/fddc02eb583a
  - [V2,net-next,4/5] net: hns3: add querying fec statistics
    https://git.kernel.org/netdev/net-next/c/2cb343b9d3e5
  - [V2,net-next,5/5] net: hns3: add support to query and set lane number by ethtool
    https://git.kernel.org/netdev/net-next/c/0f032f93c4ee

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


