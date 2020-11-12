Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E55A2B0E12
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 20:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbgKLTaF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 14:30:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:37944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726255AbgKLTaF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 14:30:05 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605209404;
        bh=MktLR3ErEQR7NTVmRcmE5yX5CcXyvAjgR8M9WIzL+nU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EdFi7I5/f86zTc/U4D/phHoJLSf9TrVdWheWEQaabTzgZtXvrQaVaBqZbhur5HKPc
         KjEgD22nb74tVmZ8XAc/tSx6uoXLTpP6Gqa9brWLouHMTkB1CY97JRlycylwYYWlnY
         DDeroCgjkF+3ixw0z0PAWJHGVkqlZbrZ04EaXZl8=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf] MAINTAINERS/bpf: Update Andrii's entry.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160520940479.15115.7636945796820422432.git-patchwork-notify@kernel.org>
Date:   Thu, 12 Nov 2020 19:30:04 +0000
References: <20201112180340.45265-1-alexei.starovoitov@gmail.com>
In-Reply-To: <20201112180340.45265-1-alexei.starovoitov@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (refs/heads/master):

On Thu, 12 Nov 2020 10:03:40 -0800 you wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> Andrii has been a de-facto maintainer for libbpf and other components.
> Update maintainers entry to acknowledge his work de-jure.
> 
> The folks with git write permissions will continue to follow the rule
> of not applying their own patches unless absolutely trivial.
> 
> [...]

Here is the summary with links:
  - [bpf] MAINTAINERS/bpf: Update Andrii's entry.
    https://git.kernel.org/bpf/bpf/c/9602182810cc

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


