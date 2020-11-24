Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A32A72C3447
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 00:01:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729619AbgKXXAH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 18:00:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:58666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729123AbgKXXAG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 18:00:06 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606258805;
        bh=5ZCtlxSVdUMqM+t8iUS2XIQVlAz58FSC6B+HEfjVsDQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=reZC/PXbnKClCGlw6tJ4VZM1EWDFaI6oAxfrvauBDoHCTnhjr3iB3EZvkJc5qmVPs
         wXdESDniB1BP9dAtvvxh9Zr7kR0QymNuVjyELqvmN5SC1X9m68dhaDKde6LuBLuQqs
         WgwZHYnAbXHGx1s6gOji5sFs9exbsEQH4HYBV8WE=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] net: page_pool: Add page_pool_put_page_bulk() to
 page_pool.rst
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160625880574.8800.3451224404719001897.git-patchwork-notify@kernel.org>
Date:   Tue, 24 Nov 2020 23:00:05 +0000
References: <a6a5141b4d7b7b71fa7778b16b48f80095dd3233.1606146163.git.lorenzo@kernel.org>
In-Reply-To: <a6a5141b4d7b7b71fa7778b16b48f80095dd3233.1606146163.git.lorenzo@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, kuba@kernel.org, brouer@redhat.com,
        ilias.apalodimas@linaro.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 23 Nov 2020 16:45:46 +0100 you wrote:
> Introduce page_pool_put_page_bulk() entry into the API section of
> page_pool.rst
> 
> Acked-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
> Changes since v1:
> - addressed Ilias's comments
> 
> [...]

Here is the summary with links:
  - [v2,net-next] net: page_pool: Add page_pool_put_page_bulk() to page_pool.rst
    https://git.kernel.org/netdev/net-next/c/2f1cce214b23

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


