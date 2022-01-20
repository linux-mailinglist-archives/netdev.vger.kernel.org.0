Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44FD3494C25
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 11:51:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbiATKvD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 05:51:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232804AbiATKuL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 05:50:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05978C061574;
        Thu, 20 Jan 2022 02:50:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B6F76151B;
        Thu, 20 Jan 2022 10:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EC172C340E2;
        Thu, 20 Jan 2022 10:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642675810;
        bh=NqowiAMeZDXoTZn1mzYNvP3gKL0n2MW5IpjY4dst0aM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KPhUmUvmhNZwdfeBhmuWepa9loN49yjSHyzxSsGBDHoEEBHh4Wmnj9JwVv/GYOjVx
         IGDGwXg8o47UXbtLS0W3R83VJWqigS8+zPGs5zUPzEO/t13Z5vMvl2c3NjUplu0Bgx
         f/5Op1rf8WDFiVsp4hZxdAKDcv67mnGcAw520rkk7xUGfg4ReNQMrZ5h0tU8caetl0
         GK0lp5Q5h3rhXe5AOEONRQ9FGOBlBBtpNDFDeS3GNbKGIw5VJH+J0p5aJFa+XavXOr
         cfuqRqc3DvpBNw+Dv3z1TzCXWQg8JKFkQIEYV93o9f9Fh0MmKGTOT+xRK7XFBgUrM1
         kBnqtHlPPln+g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D5CC7F6079B;
        Thu, 20 Jan 2022 10:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net] net: fix information leakage in /proc/net/ptype
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164267580986.26718.1893811896925655041.git-patchwork-notify@kernel.org>
Date:   Thu, 20 Jan 2022 10:50:09 +0000
References: <20220118192013.1608432-1-liu3101@purdue.edu>
In-Reply-To: <20220118192013.1608432-1-liu3101@purdue.edu>
To:     Congyu Liu <liu3101@purdue.edu>
Cc:     davem@davemloft.net, kuba@kernel.org, yajun.deng@linux.dev,
        edumazet@google.com, willemb@google.com, mkl@pengutronix.de,
        rsanger@wand.net.nz, wanghai38@huawei.com, pablo@netfilter.org,
        jiapeng.chong@linux.alibaba.com, xemul@openvz.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 18 Jan 2022 14:20:13 -0500 you wrote:
> In one net namespace, after creating a packet socket without binding
> it to a device, users in other net namespaces can observe the new
> `packet_type` added by this packet socket by reading `/proc/net/ptype`
> file. This is minor information leakage as packet socket is
> namespace aware.
> 
> Add a net pointer in `packet_type` to keep the net namespace of
> of corresponding packet socket. In `ptype_seq_show`, this net pointer
> must be checked when it is not NULL.
> 
> [...]

Here is the summary with links:
  - [v2,net] net: fix information leakage in /proc/net/ptype
    https://git.kernel.org/netdev/net/c/47934e06b656

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


