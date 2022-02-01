Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAEC14A5C06
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 13:15:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237918AbiBAMPL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 07:15:11 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:51590 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231532AbiBAMPL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 07:15:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 346D7CE1861;
        Tue,  1 Feb 2022 12:15:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25F93C340EB;
        Tue,  1 Feb 2022 12:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643717707;
        bh=0a1TtzEvtL/O3TpSRngLbWpLXRNeNDog4yEmHJQGNDo=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=IpC4vWp6RHJ5FwN++YMaddqaL/p1K4pRVfiAfchmQyaimjCd45b3sjaouwR/z2tIg
         VapFN/QPphMIFfXgm0UqPk+6rNjq1t1y1K2vprcMCjdbDQlxedhKUyO0WvNt2QmwMv
         hQhSns0Jpe9sH8g9qV5Joc6e6JWnSY+weVNnqOSRMUUCbdXUvJfLVcEv9ei0QRNpca
         LiU/3ml6Z9IMEdAODAYUt025/H4fYdUZULTqMSZJdJyZUbg22/9Fhs6C/x2ZUdJhNu
         pYYOYJVd/F3GCwyqV34c6ROnexwNj199N7NbgtWMlEXyI53q1RF0bYnKISpgasL0rZ
         BC0KuEM0dU2wg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ipw2100: inproper error handling of ipw2100_pci_init_one
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <tencent_205AA371C910BBA2CF01B311811ABDF2560A@qq.com>
References: <tencent_205AA371C910BBA2CF01B311811ABDF2560A@qq.com>
To:     Peiwei Hu <jlu.hpw@foxmail.com>
Cc:     stas.yakovlev@gmail.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        trivial@kernel.org, Peiwei Hu <jlu.hpw@foxmail.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164371770337.16633.7286807059175242667.kvalo@kernel.org>
Date:   Tue,  1 Feb 2022 12:15:04 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Peiwei Hu <jlu.hpw@foxmail.com> wrote:

> goto fail instead of returning directly in error exiting
> 
> Signed-off-by: Peiwei Hu <jlu.hpw@foxmail.com>

The commit log does not answer to "why?". Also looking at
ipw2100_pci_init_one() I think it would need more cleanup in error
handling, for example pci_ionumap() is called in different order etc.

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/tencent_205AA371C910BBA2CF01B311811ABDF2560A@qq.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

