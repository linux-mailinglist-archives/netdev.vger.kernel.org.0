Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A279682C49
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 13:10:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231416AbjAaMKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 07:10:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231220AbjAaMKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 07:10:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59A49265AA;
        Tue, 31 Jan 2023 04:10:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0FD64B81C34;
        Tue, 31 Jan 2023 12:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A32A6C4339B;
        Tue, 31 Jan 2023 12:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675167017;
        bh=05Q0a0laoCL7B6cNeIdWae9i1mi1jqE1MmHEn48y7wY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AiLDIkfX/yC0s7oWbtxL2qgShGmaWg6DGpF2fcHDuTAYOpe4a0iGTOaS6tx1RZ7Na
         y9uZae2xgPIq5V8e5Uwh3KWRbXPs/2kTYa4F1NdAZpGtECOprYO7b8lUGzbEWfbpRf
         ZHvZzYUDj+Y/+NwYcyBDD/3Bj82qhjsbu3dP1BO5Rrkfj4jl7Tkbtin8JNyymkiFJa
         IO+rix27EvPxnRVABnUcTTGGzu6v5gKk15JhkBCsgtnRe4Nk9cbI10R/FYiCalCEjJ
         AewgByYVYe6k8wGX3tbIjdvlUsVbjKG5sps5v2mWvEaoR+hd2pQAJkeYt52xf2vZOQ
         ciDD188aOinZw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7574CC4314C;
        Tue, 31 Jan 2023 12:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/9] Documentation: correct lots of spelling errors (series 2)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167516701747.19012.10728935395396675001.git-patchwork-notify@kernel.org>
Date:   Tue, 31 Jan 2023 12:10:17 +0000
References: <20230129231053.20863-1-rdunlap@infradead.org>
In-Reply-To: <20230129231053.20863-1-rdunlap@infradead.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-kernel@vger.kernel.org, corbet@lwn.net,
        linux-doc@vger.kernel.org, tj@kernel.org, lizefan.x@bytedance.com,
        hannes@cmpxchg.org, cgroups@vger.kernel.org, agk@redhat.com,
        snitzer@kernel.org, dm-devel@redhat.com, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        dan.j.williams@intel.com, vishal.l.verma@intel.com,
        dave.jiang@intel.com, nvdimm@lists.linux.dev, vkoul@kernel.org,
        dmaengine@vger.kernel.org, song@kernel.org,
        linux-raid@vger.kernel.org, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, jdelvare@suse.com, linux@roeck-us.net,
        linux-hwmon@vger.kernel.org, jiri@nvidia.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, paulmck@kernel.org, frederic@kernel.org,
        quic_neeraju@quicinc.com, josh@joshtriplett.org,
        rcu@vger.kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        sparclinux@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Sun, 29 Jan 2023 15:10:44 -0800 you wrote:
> Maintainers of specific kernel subsystems are only Cc-ed on their
> respective patches, not the entire series. [if all goes well]
> 
> These patches are based on linux-next-20230127.
> 
> 
>  [PATCH 1/9] Documentation: admin-guide: correct spelling
>  [PATCH 2/9] Documentation: driver-api: correct spelling
>  [PATCH 3/9] Documentation: hwmon: correct spelling
>  [PATCH 4/9] Documentation: networking: correct spelling
>  [PATCH 5/9] Documentation: RCU: correct spelling
>  [PATCH 6/9] Documentation: scsi/ChangeLog*: correct spelling
>  [PATCH 7/9] Documentation: scsi: correct spelling
>  [PATCH 8/9] Documentation: sparc: correct spelling
>  [PATCH 9/9] Documentation: userspace-api: correct spelling
> 
> [...]

Here is the summary with links:
  - [4/9] Documentation: networking: correct spelling
    https://git.kernel.org/netdev/net-next/c/a266ef69b890

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


