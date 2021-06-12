Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 309643A5083
	for <lists+netdev@lfdr.de>; Sat, 12 Jun 2021 22:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231435AbhFLUWH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Jun 2021 16:22:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:36660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229985AbhFLUWE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Jun 2021 16:22:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8E14A611CE;
        Sat, 12 Jun 2021 20:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623529204;
        bh=OGJj8WP+Lc39n3Kdvxa0uDqxB9fN7t3qAGgHABhDuz8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RlG9EqCH5mCQZNl0+pu6USnXh9ny7p+e8QkNA9hQsNx0A5mK9YpZ4cizJNuQsaPSb
         MRQ1TThuNt4HrDiPL8DQeluu6usmb9khY9WJi8nM8DQ0ut1AeTJObqpD11XHoJrNV3
         7+aSaw288BcNyEIMCvPjM/jx1dsch+Qlmi7iZHgmbQ0TfpKb2f4y8spCSZU26QdekZ
         FQZGZgj7hdUi3hTIPVQT32n4JrRctcJqbDFeVRyhKdXmww858+O0tBW+3Rdk28nbAI
         tU/TwjhqiE8YjTae9+HQmVAgvkitqPTnHSTIFZSwsQrxLyWIMGcv81Dfd0vftvXO7Q
         cQcmGBECI47Bw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7E3BB60D0A;
        Sat, 12 Jun 2021 20:20:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ibmvnic: fix kernel build warning
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162352920451.6609.1394357987727772005.git-patchwork-notify@kernel.org>
Date:   Sat, 12 Jun 2021 20:20:04 +0000
References: <20210611153537.83420-1-lijunp213@gmail.com>
In-Reply-To: <20210611153537.83420-1-lijunp213@gmail.com>
To:     Lijun Pan <lijunp213@gmail.com>
Cc:     netdev@vger.kernel.org, lkp@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 11 Jun 2021 10:35:37 -0500 you wrote:
> drivers/net/ethernet/ibm/ibmvnic.c: In function ‘adapter_state_to_string’:
> drivers/net/ethernet/ibm/ibmvnic.c:855:2: warning: enumeration value ‘VNIC_DOWN’ not handled in switch [-Wswitch]
>   855 |  switch (state) {
>       |  ^~~~~~
> drivers/net/ethernet/ibm/ibmvnic.c: In function ‘reset_reason_to_string’:
> drivers/net/ethernet/ibm/ibmvnic.c:1958:2: warning: enumeration value ‘VNIC_RESET_PASSIVE_INIT’ not handled in switch [-Wswitch]
>  1958 |  switch (reason) {
>       |  ^~~~~~
> 
> [...]

Here is the summary with links:
  - [net-next] ibmvnic: fix kernel build warning
    https://git.kernel.org/netdev/net-next/c/822ebc2cf50c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


