Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A73B5974CB
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 19:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240200AbiHQRKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 13:10:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237342AbiHQRKL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 13:10:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D95025FF59;
        Wed, 17 Aug 2022 10:10:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6EDC161207;
        Wed, 17 Aug 2022 17:10:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D0C8FC433D6;
        Wed, 17 Aug 2022 17:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660756209;
        bh=PRkPy6/BboxVIV4svm9kZjB5MPhqvOyWk7k0yChUSEg=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=lh2NLK6BXqd3jz9ktIz9fK0BvVEdSVXL/eTMZnDmDa3j4ezjftH9YXoz6VO7jC5tp
         /rdF41HsFHgBaekQrr5/wDLIbtmJ1ZEPQxV7JQcxC0wwEvab955lPIDERfCnGJ5E4b
         V3Sst53simH3O1dfYehQaS6cBmy7LqUVQRCc465srhSNCpE87NHO0kEpsQVPAerG1E
         javztSvqXVHLrGjlvvLxAclEtXrVpgqIJ8YPtRpI5dIkI4UYmhjWcUc2gs6NjFfbBt
         xECBWetJK9BPtiTxtBNQd+TyktaaQN+Fr4W2D/18ZyVdz3vxm9cZ61AIUEfotJrXyu
         LEGh5rutQgjig==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B5F6DC43142;
        Wed, 17 Aug 2022 17:10:09 +0000 (UTC)
Subject: Re: [GIT PULL] virtio: fixes
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220817063842-mutt-send-email-mst@kernel.org>
References: <20220817063842-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: Linux virtualization <virtualization.lists.linux-foundation.org>
X-PR-Tracked-Message-Id: <20220817063842-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: 5c669c4a4c6aa0489848093c93b8029f5c5c75ec
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 274a2eebf80c60246f9edd6ef8e9a095ad121264
Message-Id: <166075620968.6865.11130017018985824267.pr-tracker-bot@kernel.org>
Date:   Wed, 17 Aug 2022 17:10:09 +0000
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        kvm@vger.kernel.org, mst@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, andres@anarazel.de,
        linux@roeck-us.net
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Wed, 17 Aug 2022 06:38:42 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/274a2eebf80c60246f9edd6ef8e9a095ad121264

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
