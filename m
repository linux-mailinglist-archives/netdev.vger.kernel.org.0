Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 697D230B67F
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 05:32:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231668AbhBBEav (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 23:30:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:60242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231530AbhBBEas (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Feb 2021 23:30:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 7489B64ED3;
        Tue,  2 Feb 2021 04:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612240207;
        bh=NLexvhL4GxQN8+BL1dO6nd9YgRqkA1vWK17HJEpiAU4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=C4Wiik7YJRJXtnqqee/4uZml8b9Vj/rY0ShpslIFPEDY9QObpj5vrdNinkvXnfq/v
         Lc5M2F0uXugeCthyZAymBIhw0KZ2BePvfLDLd0pBRG/terWfMZiuyntOiA/4PJyFdp
         IoVcw/17wpDPMai75Jl/PyFlklVpk59z5K7jCRv0L1ZdG46rFX+3KW9YkC4C6SI/cL
         +0KDrBG/dGxpMUkfmeJ1o501cmLZyOPl3IxfvWcyCY3Rc1TPbHxeyEbnpYUAM0+ZAq
         a5xa0WCHrwVet2rJgwcCg5+VB+6sAN9jIkHMnlYM7d80RtCNMLByfrC09eV5B+pOAk
         7kZwnalBVb+MA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5F6C0609D7;
        Tue,  2 Feb 2021 04:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] docs: networking: swap words in
 icmp_errors_use_inbound_ifaddr doc
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161224020738.9509.7533288789637730431.git-patchwork-notify@kernel.org>
Date:   Tue, 02 Feb 2021 04:30:07 +0000
References: <20210130190518.854806-1-vincent@bernat.ch>
In-Reply-To: <20210130190518.854806-1-vincent@bernat.ch>
To:     Vincent Bernat <vincent@bernat.ch>
Cc:     davem@davemloft.net, corbet@lwn.net, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sat, 30 Jan 2021 20:05:18 +0100 you wrote:
> Signed-off-by: Vincent Bernat <vincent@bernat.ch>
> ---
>  Documentation/networking/ip-sysctl.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net] docs: networking: swap words in icmp_errors_use_inbound_ifaddr doc
    https://git.kernel.org/netdev/net/c/316282015455

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


