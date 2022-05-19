Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3044D52D9FA
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 18:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241962AbiESQOh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 12:14:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236153AbiESQOf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 12:14:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 138D5C9ECD;
        Thu, 19 May 2022 09:14:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A416161BD4;
        Thu, 19 May 2022 16:14:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0EFD8C385AA;
        Thu, 19 May 2022 16:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652976874;
        bh=JhRHwRHWIkm/MXWp/oSdiYsP151OsvphnoFYVsrGiDU=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=QvracSuXqPHuXj2xwPq3ytRGngA68y6UQpU1fVJt6/5ndHFKQeyZIj/QC6aOyn01m
         hMT71Oy3EjHlRI8zKjZqBn0aEqXbY6Yy3O9lEwVUFj0ExFPLYF9SUL/kQg0b0qRNDI
         MhLujj477zcn+GWnWSOmsi1+QCiJ31idLH0Vm3SN2xtc96DceBtOy6qF26K+tePcHU
         c6wqNpyJJpbTMTuuhubCSy6CrcNR7QENvvNWRs0fGUlBADLA20GK/touiifr0dyPVb
         B4cCXf19KLYKjb8IrI9MhGjzSSHZXJW+fko3VYWJ6Lr7yJ3Z8aGLiY9vHygfvsi91h
         /iN8iXJYQjqmw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F175DE8DBDA;
        Thu, 19 May 2022 16:14:33 +0000 (UTC)
Subject: Re: [GIT PULL] Networking for 5.18-rc8
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220519092532.17746-1-pabeni@redhat.com>
References: <20220519092532.17746-1-pabeni@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20220519092532.17746-1-pabeni@redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.18-rc8
X-PR-Tracked-Commit-Id: fbb3abdf2223cd0dfc07de85fe5a43ba7f435bdf
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d904c8cc0302393640bc29ee62193f88ddc53126
Message-Id: <165297687398.7702.17169303321043218900.pr-tracker-bot@kernel.org>
Date:   Thu, 19 May 2022 16:14:33 +0000
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     torvalds@linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pull request you sent on Thu, 19 May 2022 11:25:32 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.18-rc8

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d904c8cc0302393640bc29ee62193f88ddc53126

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
