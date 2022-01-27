Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2AF449D941
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 04:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235410AbiA0DaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 22:30:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231300AbiA0DaN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 22:30:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B4ACC06173B
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 19:30:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E1869B8213F
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 03:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 93813C340EB;
        Thu, 27 Jan 2022 03:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643254210;
        bh=SIyHAioOeimWH9KReQmhMIo01sn94/6a7EIqpE8N3jo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WQYYRylsjAmcl6E3o0NlD8fUI0vRwCKUmiF8OxKSYJD/4XZ9rHKffN3TGqSaOI4cr
         TFDkbAum/sBl5rIcB/I0hTnHMQCmA1QgnwDwrt5Io7FHNIGqmBRMUh4Bzjg5BTPMfi
         OQLsiOr0JVic6b5cOcWaJessPsG8XCTlTRnjXIUR/0eUJcw3q13njtYph5kikCEKSP
         QhxNnn8O0IeXm/3uK8ao3kYdgTIbndMwPgirbG3oRZe6lXggbvJYG2EWEL4D4FHzk4
         zTjrWtroLJT2O+EiR4CEfE0px2E1gGNEjXdIzDAo6LvmdGauXEFLQGh+b8WQ98Sbes
         iX/JnvZ33qRcQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7F00DE5D08C;
        Thu, 27 Jan 2022 03:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] nfp: only use kdoc style comments for kdoc
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164325421051.18421.6489550284964171406.git-patchwork-notify@kernel.org>
Date:   Thu, 27 Jan 2022 03:30:10 +0000
References: <20220126090803.5582-1-simon.horman@corigine.com>
In-Reply-To: <20220126090803.5582-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        oss-drivers@corigine.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 26 Jan 2022 10:08:03 +0100 you wrote:
> Update comments to only use kdoc style comments, starting with '/**',
> for kdoc.
> 
> Flagged by ./scripts/kernel-doc
> 
> Signed-off-by: Simon Horman <simon.horman@corigine.com>
> 
> [...]

Here is the summary with links:
  - [net-next] nfp: only use kdoc style comments for kdoc
    https://git.kernel.org/netdev/net-next/c/49db8a70a01e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


