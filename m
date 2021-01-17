Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B0162F904D
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 04:14:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728113AbhAQDMy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jan 2021 22:12:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:48988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728042AbhAQDMs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Jan 2021 22:12:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB21022CB8;
        Sun, 17 Jan 2021 03:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610853128;
        bh=vRqKCCOkGgRniz8vgd4WAhRkMJVfeg4S9wdz9NnQo9o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eCUv26krGigkBC6mubNjbc9CpzNJ2yb5SPHkBPrlK4/s+nLIxmEMwcD4r9JKCsnt1
         WNKbGyGUYoZhImDRF/X5eFzNKe0mBs/ZuZT5JBvIdAen/C45iE5vqtqdOev5tsFRsD
         w0FX1XIKYz9G4zLUv7BB0ocAexGbtLLVsyk92i68/WvSzbnLPe+skoehbG1ynvcwVM
         Bx/eRjMr00CzERqZ7vYf6mP2RJmitrlObOLDiBHyQwUscQLQ1/4aoxtLolGqClb36U
         7RN3SBM2HBLHeiuQqitZVX4978h17CZi1Lup/NQJmGNMV9An6VI8ZTK0LYY/fMciBy
         zO7gsLTwgvzVw==
Date:   Sat, 16 Jan 2021 19:12:07 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, evgreen@chromium.org,
        bjorn.andersson@linaro.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 7/7] net: ipa: allow arbitrary number of
 interconnects
Message-ID: <20210116191207.277a391a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210115125050.20555-8-elder@linaro.org>
References: <20210115125050.20555-1-elder@linaro.org>
        <20210115125050.20555-8-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 15 Jan 2021 06:50:50 -0600 Alex Elder wrote:
> Currently we assume that the IPA hardware has exactly three
> interconnects.  But that won't be guaranteed for all platforms,
> so allow any number of interconnects to be specified in the
> configuration data.
> 
> For each platform, define an array of interconnect data entries
> (still associated with the IPA clock structure), and record the
> number of entries initialized in that array.
> 
> Loop over all entries in this array when initializing, enabling,
> disabling, or tearing down the set of interconnects.
> 
> With this change we no longer need the ipa_interconnect_id
> enumerated type, so get rid of it.

Okay, all the platforms supported as of the end of the series 
still have 3 interconnects, or there is no upstream user of 
this functionality, if you will. What's the story?
