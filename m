Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA849476BEE
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 09:29:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232475AbhLPI3G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 03:29:06 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:57534 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbhLPI3G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 03:29:06 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 22C5B61CB6;
        Thu, 16 Dec 2021 08:29:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D39AC36AE2;
        Thu, 16 Dec 2021 08:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639643345;
        bh=p8GteedAkv4xqbgcow92LTN0/jCLG54OrLktXFsBnpc=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=lPAVZssgEW1PsFZpnAwssye5AgFDJUczBzcgGl/vBGR5yXK9/3UrcUuiLG9VUl2Jh
         jFLGANg8Q20UvwfP5DiLN+YzLfMAx/rA7bSjA5iSXOL3xDx0rXi92jKxaLjYzyPx0B
         8Ah9J7Pbht6FXuv7Cf/fB3343IX5rGj3A/oJx7vDDeZNdtdBbKWSIpHLOxgVp/93zM
         H7Fg45jzOYAUcm+BRhhH6k8RiFqk63j63btvk825CB5cqj3wzQOXyGI6cn5rw+5Pd5
         CEOpZGeCRjS3iftPTRM/nYIdHFV2sOP9QjPJCa9HJhXFKEUSVQdbBT0KU9q3EPGbhh
         ixHxIzWxhgFNA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wl1251: specify max. IE length
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20211212221310.5453-1-merlijn@wizzup.org>
References: <20211212221310.5453-1-merlijn@wizzup.org>
To:     Merlijn Wajer <merlijn@wizzup.org>
Cc:     merlijn@wizzup.org, Paul Fertser <fercerpav@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <163964334199.18270.214273609700735444.kvalo@kernel.org>
Date:   Thu, 16 Dec 2021 08:29:03 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Merlijn Wajer <merlijn@wizzup.org> wrote:

> This fix is similar to commit 77c91295ea53 ("wil6210: specify max. IE
> length").  Without the max IE length set, wpa_supplicant cannot operate
> using the nl80211 interface.
> 
> This patch is a workaround - the number 512 is taken from the wlcore
> driver, but note that per Paul Fertser:
> 
>     there's no correct number because the driver will ignore the data
>     passed in extra IEs.
> 
> Suggested-by: Paul Fertser <fercerpav@gmail.com>
> Signed-off-by: Merlijn Wajer <merlijn@wizzup.org>

Patch applied to wireless-drivers-next.git, thanks.

97affcfa15bb wl1251: specify max. IE length

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20211212221310.5453-1-merlijn@wizzup.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

