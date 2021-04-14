Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61EA735FD5F
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 23:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232823AbhDNVkj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 17:40:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:38000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231459AbhDNVke (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 17:40:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 99CA661042;
        Wed, 14 Apr 2021 21:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618436412;
        bh=rwCNBS+L9z8tI/3KIueO5s85cBXj6vQlE6pLp7nfrC8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Umglwz/AeLnRppDfVbTr9w6xxtbvq5MeIMqTtVAhffflDkFsWUReAQsTQEgUGv07q
         5hUxB5ZJsYYbzoPBIzlfLUE22jk0C8xdIyOM35QIPmbnqVzajLkoU0RN/t9uV0Cvci
         UnUXJaojGqvpSZVh+ufmMAz+yNRjU8K0YnD56P6AOju1/cdbCcuvJyVLEmDW1duTEC
         tesbLivyBtrN9WJasTxpquqg8JtZgquStNZjqWLpLmzHzM4MZdEzR+JhdYMhLUjIFX
         K+ymdqvZNEdI9Hd5+/xnI7/6Qp8Ma0jBTbX656TXlwVuQXj4L9Fw5QMRmA3IHtWt96
         ZHe+6hG3XlT7Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 895EA60CCF;
        Wed, 14 Apr 2021 21:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: can-next 2021-04-14
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161843641255.17301.9436246472141295328.git-patchwork-notify@kernel.org>
Date:   Wed, 14 Apr 2021 21:40:12 +0000
References: <20210414200352.2473363-1-mkl@pengutronix.de>
In-Reply-To: <20210414200352.2473363-1-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (refs/heads/master):

On Wed, 14 Apr 2021 22:03:51 +0200 you wrote:
> Hello Jakub, hello David,
> 
> this is a pull request of a single patch for net-next/master.
> 
> Vincent Mailhol's patch fixes a NULL pointer dereference when handling
> error frames in the etas_es58x driver, which has been added in the
> previous PR.
> 
> [...]

Here is the summary with links:
  - pull-request: can-next 2021-04-14
    https://git.kernel.org/netdev/net-next/c/3a1aa533f7f6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


