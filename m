Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C0033146A4
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 03:51:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbhBICvi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 21:51:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:36048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229564AbhBICvh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 21:51:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C48064E3B;
        Tue,  9 Feb 2021 02:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612839056;
        bh=TuKNzJ5lHo89i9UDdSPbDKKAczX7oGRQVcJ/ZpQAkoA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lEgB2Occ4EyF9VQ33DkvLy9B0RVR8LZZy461mbP7+niQKqAXx4Wqe9EGpGPQ0Truj
         UVfeGFd8fmZ6Jn0fMTaAXorpfytn5FnloFKoPowgy957xvbK2i9JSdePWh1P1D24cC
         cqotp3yOSFBQvof+CPsSKFNfBzGFW1KpnARocCMucTilSqYwW44XFa971LY6gBs7GK
         e33Fx9OviuizrO1Sp/4DUCTHBSjDCTq3FLTLTSQzkMMWcxh8GKPAtaHvcMBBuJAXQw
         ev3VzlvZBrd6PhshsgrnxDiYKMsc3n43pSpoIMcegTKtBdf4F4HGk3RNvlavystLXx
         HfymP8f+USRKA==
Date:   Mon, 8 Feb 2021 18:50:55 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, sassmann@redhat.com,
        bjorn.topel@intel.com, maciej.fijalkowski@intel.com,
        magnus.karlsson@intel.com
Subject: Re: [PATCH net-next v2 0/5][pull request] 40GbE Intel Wired LAN
 Driver Updates 2021-02-08
Message-ID: <20210208185055.0167594a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210209022323.2440775-1-anthony.l.nguyen@intel.com>
References: <20210209022323.2440775-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  8 Feb 2021 18:23:18 -0800 Tony Nguyen wrote:
> This series contains updates to i40e driver only.
> 
> Cristian makes improvements to driver XDP path. Avoids writing
> next-to-clean pointer on every update, removes redundant updates of
> cleaned_count and buffer info, creates a helper function to consolidate
> XDP actions and simplifies some of the behavior.
> 
> Eryk adds messages to inform the user when MTU is larger than supported
> 
> v2:
> - Drop XDP_REDIRECT messaging patch (previously patch 5)
> - Use only extack for XDP MTU error

Acked-by: Jakub Kicinski <kuba@kernel.org>

Thanks for the changes!
