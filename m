Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 316663CA4BE
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 19:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235838AbhGORw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 13:52:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:60796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229865AbhGORw6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Jul 2021 13:52:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 660B661360;
        Thu, 15 Jul 2021 17:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626371404;
        bh=/y2o9rz72cNl4SHNPlmoEJDG2nI4CFOe4D13LRdLEOM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nlBzrBHBmr/ynpZlEJkhD910f+vP1D328A9ceJsE22hAkR6iMghQmXc1p5EcXKOL8
         K9wQ4/K6KYJsbfsIA5YIyaJL8XfQgJUz35KJhT21mYOD8A4TOoHvjlpBkd9oeDAjPh
         ryOK6pPwsgDuaTL9yzPiVxVCBeSzmeiVWxgGGudQMK4DTCCrITr+XYqTh9o5B1vH1Q
         i2W2nQpNfNm029qDKOrLtcgLLVzpKB+bwRLnQ4G6vUyWnXW9YjKfH+TpFYJRTTqEH3
         j6rSgCccbglT9181zjq7eOWR8vSixO3FKYgFyi+8ekB98ix2DPIrYQrz4xezSI29co
         R7V+bKVFd406Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 56318609B8;
        Thu, 15 Jul 2021 17:50:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] s390/bpf: perform r1 range checking before accessing
 jit->seen_reg[r1]
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162637140434.23218.4971515886855258652.git-patchwork-notify@kernel.org>
Date:   Thu, 15 Jul 2021 17:50:04 +0000
References: <20210715125712.24690-1-colin.king@canonical.com>
In-Reply-To: <20210715125712.24690-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     iii@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        borntraeger@de.ibm.com, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        holzheu@linux.vnet.ibm.com, schwidefsky@de.ibm.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-s390@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (refs/heads/master):

On Thu, 15 Jul 2021 13:57:12 +0100 you wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently array jit->seen_reg[r1] is being accessed before the range
> checking of index r1. The range changing on r1 should be performed
> first since it will avoid any potential out-of-range accesses on the
> array seen_reg[] and also it is more optimal to perform checks on
> r1 before fetching data from the array.  Fix this by swapping the
> order of the checks before the array access.
> 
> [...]

Here is the summary with links:
  - s390/bpf: perform r1 range checking before accessing jit->seen_reg[r1]
    https://git.kernel.org/bpf/bpf/c/91091656252f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


