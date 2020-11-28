Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 988BD2C7312
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 23:13:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389453AbgK1VuA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Nov 2020 16:50:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:59612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387679AbgK1UUi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 28 Nov 2020 15:20:38 -0500
Received: from kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C743A221FF;
        Sat, 28 Nov 2020 20:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606594798;
        bh=C+efOhsgaww9VfIMDKFKC2yxzNAzm2et1F/UUofnQik=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dl+V9HVI//UFtwgBJj4Ux6Vh/X2yiKvJoRUMWwsulWrEVf5UPB6oPuDqx8PZZgXS6
         OtCCEPsIJYtxRv3qnrIUT6pE0KjwFf9jEqTSiIxL19FrBLD+ifG/K87upvMJNxbaXs
         l8NZITp5gbUL15AjnYyxjDLwzpfmvfhBZTPu8QD8=
Date:   Sat, 28 Nov 2020 12:19:57 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/6] net: ipa: start adding IPA v4.5 support
Message-ID: <20201128121957.133f7893@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201125204522.5884-1-elder@linaro.org>
References: <20201125204522.5884-1-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 25 Nov 2020 14:45:16 -0600 Alex Elder wrote:
> This series starts updating the IPA code to support IPA hardware
> version 4.5.
> 
> The first patch fixes a problem found while preparing these updates.
> Testing shows the code works with or without the change, and with
> the fix the code matches "downstream" Qualcomm code.
> 
> The second patch updates the definitions for IPA register offsets
> and field masks to reflect the changes that come with IPA v4.5.  A
> few register updates have been deferred until later, because making
> use of them involves some nontrivial code updates.
> 
> One type of change that IPA v4.5 brings is expanding the range of
> certain configuration values.  High-order bits are added in a few
> cases, and the third patch implements the code changes necessary to
> use those newly available bits.
> 
> The fourth patch implements several fairly minor changes to the code
> required for IPA v4.5 support.
> 
> The last two patches implement changes to the GSI registers used for
> IPA.  Almost none of the registers change, but the range of memory
> in which most of the GSI registers is located is shifted by a fixed
> amount.  The fifth patch updates the GSI register definitions, and
> the last patch implements the memory shift for IPA v4.5.

Applied, thanks!
