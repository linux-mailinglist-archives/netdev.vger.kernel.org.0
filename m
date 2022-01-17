Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 596EC49091D
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 14:00:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240066AbiAQNAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 08:00:33 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:51946 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbiAQNAd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 08:00:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B4021B81055;
        Mon, 17 Jan 2022 13:00:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7707C36AE7;
        Mon, 17 Jan 2022 13:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642424430;
        bh=3S0Ctk48yPY97wks1dFDFxCroL+JI9L03ZRiPTjDIP0=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=vHcl/fastd0J7QDqzul7f7BJIM6UUDwlRAL6kbYsf86E724PGa5b9JOZZNL6mlauz
         AnAn5jxA8O4OXwZWpAO0ZoIRb0UCJQ/5P1o7DRv/VQLjgMGC6Q2fck23u84squf0/k
         bkvsQ/3HY00untoCkCH2Ue5egj/aiiRmDDmt+P+CtZHijve+FmiJGNSkI3q/ch6iFQ
         mqqNCSv8ixjWr0IKzdiXFGcyTjrNzOoRaPwVO2KQ6D5KzM9JQyDVu+tq3EfY9dXvR9
         6xoHbvckOOtN2ChG1ATEy1DQui8RY/8lNt11PIHBFKD7aJVwIrFS+YruGfBm7C171O
         9bytcJg9wepZA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath11k: fix error handling in
 ath11k_qmi_assign_target_mem_chunk()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220116144206.399385-1-trix@redhat.com>
References: <20220116144206.399385-1-trix@redhat.com>
To:     trix@redhat.com
Cc:     davem@davemloft.net, kuba@kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, akolli@codeaurora.org,
        ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, Tom Rix <trix@redhat.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164242442618.16718.73054650971271178.kvalo@kernel.org>
Date:   Mon, 17 Jan 2022 13:00:27 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

trix@redhat.com wrote:

> From: Tom Rix <trix@redhat.com>
> 
> Clang static analysis reports this problem
> qmi.c:1935:5: warning: Undefined or garbage value returned to caller
>   return ret;
>   ^~~~~~~~~~
> 
> ret is uninitialized.  When of_parse_phandle() fails, garbage is
> returned.  So return -EINVAL.
> 
> Fixes: 6ac04bdc5edb ("ath11k: Use reserved host DDR addresses from DT for PCI devices")
> Signed-off-by: Tom Rix <trix@redhat.com>

I just applied a fix from Dan:

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/commit/?h=ath-next&id=c9b41832dc08

Patch set to Superseded.

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220116144206.399385-1-trix@redhat.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

