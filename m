Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC30046EC6F
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 17:00:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240721AbhLIQDv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 11:03:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239849AbhLIQDq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 11:03:46 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26061C0617A1;
        Thu,  9 Dec 2021 08:00:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7A3EFCE26CB;
        Thu,  9 Dec 2021 16:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9F49BC341C7;
        Thu,  9 Dec 2021 16:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639065609;
        bh=yXF6WTBLyzXePcMl34JCMt1CYgTtkmYgS3KOCYelMEw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CbBSQGY8HRsHi2GiZj8Q9sji3fey3DaIGgahdUKK0vQ2dvECfL/iAZXzxoHAkYa4S
         GwZj1XL18NTI8TOTfwo4hw1ZTOuUIKv9V4VXetuEIjYyTEnpJV/104P7rzA9BZP+Hg
         AboWI2DFsWVAH7iHpMfYl9jvxj3D9UrCANm3aJKl/yF56mGt8kp6QvTWIqEYOp/Hb6
         QsMCVajirgi9XWicp9w+ppblhy7Xv75E7JzBypwYv04gshuKYocT85D7UNhgr523wC
         u2f/uyxRBRP8cSHPF+A/C7vwOmdINwGlY5iuOdobcNRGdV9DhJGfy2VGm0RvA4862/
         uX3lqiBiq2B3Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7B68B60A3C;
        Thu,  9 Dec 2021 16:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] nfc: fix potential NULL pointer deref in
 nfc_genl_dump_ses_done
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163906560950.14007.13680308284854233167.git-patchwork-notify@kernel.org>
Date:   Thu, 09 Dec 2021 16:00:09 +0000
References: <20211209081307.57337-1-krzysztof.kozlowski@canonical.com>
In-Reply-To: <20211209081307.57337-1-krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     davem@davemloft.net, kuba@kernel.org, sameo@linux.intel.com,
        linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, tadeusz.struk@linaro.org,
        stable@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  9 Dec 2021 09:13:07 +0100 you wrote:
> The done() netlink callback nfc_genl_dump_ses_done() should check if
> received argument is non-NULL, because its allocation could fail earlier
> in dumpit() (nfc_genl_dump_ses()).
> 
> Fixes: ac22ac466a65 ("NFC: Add a GET_SE netlink API")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> 
> [...]

Here is the summary with links:
  - nfc: fix potential NULL pointer deref in nfc_genl_dump_ses_done
    https://git.kernel.org/netdev/net/c/fd79a0cbf0b2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


