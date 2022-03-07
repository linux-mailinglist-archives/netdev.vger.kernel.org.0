Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 414834D07DF
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 20:47:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245138AbiCGTsJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 14:48:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245133AbiCGTsC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 14:48:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB0EB5DA6D;
        Mon,  7 Mar 2022 11:47:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 69EB7B816F4;
        Mon,  7 Mar 2022 19:47:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 14AEAC340EB;
        Mon,  7 Mar 2022 19:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646682425;
        bh=wnIHskNDTiWGuOn6SMaYqSAfatEdRhyYgNpNgobbHFg=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=ME+em3BSiR0V3FiDLe4WlgPoSBcGC5qCbMxstPVPpqdaXAJ9gmiJ/5b6WYrz4sNap
         i4yWmarXYDCLjAR80lOqZpiVxDCOvblwtuvkD8gL17u6GXmvVlI1tshXwKc/DuaSvb
         cFUmPID2TY5IeTJA/8KOguIb7D1NyF9l6sqsydRbAcIHhZuAqtf4xZGZ/Xi9pJxm3l
         0bxYxmFUhN13/KVSwxpjB9Xku1Nrx46QgTke1sgSVHYss2DEo+urvBx/QcPbz4c9yk
         S7ZTTXyL7lIqPkAV/Lm6GDy7t1+dCBlB6KXciLdS3qwbNvN++xa/TC6fJr+G4F7vtN
         FKxixISfsWJ0Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F2B9CE6D3DE;
        Mon,  7 Mar 2022 19:47:04 +0000 (UTC)
Subject: Re: [GIT PULL] virtio: last minute fixes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220307060332-mutt-send-email-mst@kernel.org>
References: <20220307060332-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20220307060332-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: 3dd7d135e75cb37c8501ba02977332a2a487dd39
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 06be3029703fed2099b7247c527ab70d75255178
Message-Id: <164668242498.29310.4137734389077787873.pr-tracker-bot@kernel.org>
Date:   Mon, 07 Mar 2022 19:47:04 +0000
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dan.carpenter@oracle.com, david@redhat.com, jasowang@redhat.com,
        lkp@intel.com, mail@anirudhrb.com, mst@redhat.com,
        pasic@linux.ibm.com, sgarzare@redhat.com, si-wei.liu@oracle.com,
        stable@vger.kernel.org,
        syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com,
        wang.yi59@zte.com.cn, xieyongji@bytedance.com,
        zhang.min9@zte.com.cn
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Mon, 7 Mar 2022 06:03:32 -0500:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/06be3029703fed2099b7247c527ab70d75255178

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
