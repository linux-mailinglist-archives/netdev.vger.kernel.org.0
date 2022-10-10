Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C5535FA6EB
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 23:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbiJJVXw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 17:23:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbiJJVXu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 17:23:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CFF36C107;
        Mon, 10 Oct 2022 14:23:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 82D9261033;
        Mon, 10 Oct 2022 21:23:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E47ADC433D7;
        Mon, 10 Oct 2022 21:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665437026;
        bh=LW6qbMwcNGlPWguPr3/tioF4lSPOeC7TNnM9SOAJNC8=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=j5OHXjHstpAmokFGUNn/YWj1urnovTw1Poen8SZNuKNfbzPjWUNba/atuBvFAmCR+
         LLQGEsvzkDgX/9UGYhGOqCCFlwwMlARKMxFsnBeCzLH6igWRHz6PuUrP/SgzVprE/F
         J7oDAVdu8d7KUgeJAEOl0uNHolOZTcdKTBBlR/msJ37+eqfw/6bsbTm6o45rLno62I
         JZi7QNkjIdukUrd3hLcRUT3QqMdsq1bpurWlyBi93TcECQd8YYSOAFfwdMVcqhDHOD
         amXCndh9xl2LzVWe4guhjjkaLRzC9mQv6mxUVt/2aFGjmgcIpHV6tIEpVYRtMrWt8i
         l4X4Zvazet1zg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D2C29E2A05F;
        Mon, 10 Oct 2022 21:23:46 +0000 (UTC)
Subject: Re: [GIT PULL] virtio: fixes, features
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20221010132030-mutt-send-email-mst@kernel.org>
References: <20221010132030-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20221010132030-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: 71491c54eafa318fdd24a1f26a1c82b28e1ac21d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 8aeab132e05fefc3a1a5277878629586bd7a3547
Message-Id: <166543702685.28157.12851164302122498438.pr-tracker-bot@kernel.org>
Date:   Mon, 10 Oct 2022 21:23:46 +0000
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        alvaro.karsz@solid-run.com, angus.chen@jaguarmicro.com,
        gavinl@nvidia.com, jasowang@redhat.com, lingshan.zhu@intel.com,
        mst@redhat.com, wangdeming@inspur.com, xiujianfeng@huawei.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Mon, 10 Oct 2022 13:20:30 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/8aeab132e05fefc3a1a5277878629586bd7a3547

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
