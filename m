Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC2F3050E4
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 05:33:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238940AbhA0E3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 23:29:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:48860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405004AbhA0Bav (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 20:30:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id CB8FD64D82;
        Wed, 27 Jan 2021 01:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611711010;
        bh=LtAGqBU13q8S7kibgmtVwIdRCXDazuPH5xJSA3uwi58=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MOS0LcGcJmBQB1GgHL8vG65SDoINrBJdqfg7IJGFHnz1S//F4MYRcAkg2ZNfx14T9
         fqdjSVItkXnYVGPjKqTsgMJaqL04HVvdFV1+WYwPPO/TRJ8JMCrXVR60oHB2neKDsE
         uq8llfTXCEFvXb2QzeRg/te5iwUiK6e7H101J4z+5BCzMg33sM5IWwZUbD77V0pH6o
         SMNkmzv1PBkapFyQrBGIqwJ09eayVIBqjtWFEuvzHFs86X8SWE0TomZLPsA8+r+S7o
         THJUBGM1YbNPkxs/I1uZiXbSjLfpIw2QkzQURaV3EWh18t9OEeQYydPgnm1fGn8I0b
         QZYJDWLJvdVnA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BB4FC61FC5;
        Wed, 27 Jan 2021 01:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] usbnet: fix the indentation of one code snippet
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161171101076.7397.12147674119821236655.git-patchwork-notify@kernel.org>
Date:   Wed, 27 Jan 2021 01:30:10 +0000
References: <20210123051102.1091541-1-mudongliangabcd@gmail.com>
In-Reply-To: <20210123051102.1091541-1-mudongliangabcd@gmail.com>
To:     =?utf-8?b?5oWV5Yas5LquIDxtdWRvbmdsaWFuZ2FiY2RAZ21haWwuY29tPg==?=@ci.codeaurora.org
Cc:     oneukum@suse.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat, 23 Jan 2021 13:11:02 +0800 you wrote:
> Every line of code should start with tab (8 characters)
> 
> Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
> ---
>  drivers/net/usb/usbnet.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)

Here is the summary with links:
  - usbnet: fix the indentation of one code snippet
    https://git.kernel.org/netdev/net-next/c/2961f562bb7b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


