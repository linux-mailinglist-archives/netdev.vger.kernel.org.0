Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A0F2338399
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 03:30:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231631AbhCLCa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 21:30:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:37054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229664AbhCLCaP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 21:30:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 9C7BF64F8E;
        Fri, 12 Mar 2021 02:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615516215;
        bh=D9MGN+fFbdK2/TfRH+aX4F9qV+vkMaXDR6zIXqOBh0Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WgQYNjAQrq31VD+J0hE6MEuogKxf2Iir3eHtmYXtQ9WVins9FpZ2yk/CXNDl/11mR
         C0OdBHp+1kr+ODjwsqpZAtpGexv4cOX7amH2/peAkRTcsbr90aHiM84svS75ruG+Fp
         LUDxTGG4mF9kZo9trGQV2JQULAtIZSzlnfE4qPE9rREnXNZCaE+HLN+oPfOV4Jq2Tj
         H35/VXsyrubVwjm+mcrkBJ0yWQ+U21rx1FUTITTiSqKQP2cj7D47xlkqKFvOUwd7I4
         9V2vhFZz7bu7Cc8e6kCvtpIb02U82RUVCsJuQQWmzSVCIyMeXADilAWzYMEgXRIj1K
         icaZBDn6egSvg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 94AFC6096F;
        Fri, 12 Mar 2021 02:30:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net/qlcnic: Fix a use after free in
 qlcnic_83xx_get_minidump_template
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161551621560.2118.16949794458135150794.git-patchwork-notify@kernel.org>
Date:   Fri, 12 Mar 2021 02:30:15 +0000
References: <20210311040140.7339-1-lyl2019@mail.ustc.edu.cn>
In-Reply-To: <20210311040140.7339-1-lyl2019@mail.ustc.edu.cn>
To:     Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Cc:     shshaikh@marvell.com, manishc@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 10 Mar 2021 20:01:40 -0800 you wrote:
> In qlcnic_83xx_get_minidump_template, fw_dump->tmpl_hdr was freed by
> vfree(). But unfortunately, it is used when extended is true.
> 
> Fixes: 7061b2bdd620e ("qlogic: Deletion of unnecessary checks before two function calls")
> Signed-off-by: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
> ---
>  drivers/net/ethernet/qlogic/qlcnic/qlcnic_minidump.c | 3 +++
>  1 file changed, 3 insertions(+)

Here is the summary with links:
  - net/qlcnic: Fix a use after free in qlcnic_83xx_get_minidump_template
    https://git.kernel.org/netdev/net/c/db74623a3850

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


